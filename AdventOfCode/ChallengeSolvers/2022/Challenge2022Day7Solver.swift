//
//  Challenge2022Day7Solver.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/6/21.
//

import Foundation

private class Directory: CustomStringConvertible {
  private(set) var subDirectories = [Directory]()
  private(set) var files = [File]()

  let parent: Directory?
  let name: String

  var _size: Int?
  var size: Int {
    if let size = _size {
      return size
    }
    _size = subDirectories.map(\.size).sum() + files.map(\.size).sum()
    return _size!
  }

  init(name: String, parent: Directory?) {
    self.name = name
    self.parent = parent
    self.parent?.add(self)
  }

  func add(_ child: Directory) {
    self.subDirectories.append(child)
  }

  func add(_ child: File) {
    self.files.append(child)
  }

  @discardableResult
  func addSubdirectory(named name: String) -> Directory {
    return Directory(name: name, parent: self)
  }

  @discardableResult
  func addFile(named name: String, size: Int) -> File {
    return File(name: name, size: size, parent: self)
  }

  func file(named name: String) -> File? {
    return files.first(where: { $0.name == name })
  }

  func subDirectory(named name: String) -> Directory? {
    return subDirectories.first(where: { $0.name == name })
  }

  var description: String {
    return description(indentation: 0)
  }

  private func description(indentation: Int) -> String {
    var description = "\(String(repeating: " ", count: indentation))- \(name.isEmpty ? "/" : name) (dir)"
    for subDirectory in subDirectories {
      description = description + "\n" + subDirectory.description(indentation: indentation + 2)
    }

    for file in files {
      description = description + "\n\(String(repeating: " ", count: indentation + 2))" + String(describing: file)
    }
    return description
  }
}

private class File: CustomStringConvertible {
  let name: String
  let size: Int
  let parent: Directory?

  var description: String

  init(name: String, size: Int, parent: Directory) {
    self.name = name
    self.size = size
    self.parent = parent
    self.description = "- \(name) (file, size=\(size))"
    parent.add(self)
  }
}

struct Challenge2022Day7Solver: ChallengeSolver {
  static let defaultValue = """
$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k
"""

  static func solution(number challengeNumber: ChallengeNumber, for input: String) -> String {
    let lines = inputComponents(from: input)
    let root = Directory(name: "", parent: nil)
    var currDirectory = root

    guard lines.first! == "$ cd /" else {
      fatalError("Did not start by CDing to root directory.")
    }

    var index: Int = 1
    while index < lines.endIndex {
      let components = lines[index].components(separatedBy: " ")
      guard components.count >= 2, components.first! == "$" else {
        fatalError("Invalid number of command components")
      }

      // components[0] is already validated to be $
      let commandName = components[1]

      switch commandName {
      case "cd":
        let fileName = components[2]
        switch fileName {
        case "..":
          currDirectory = currDirectory.parent!
        case "/":
          currDirectory = root
        default:
          // If the directory already exists CD to it, otherwise create it and CD to it.
          currDirectory = currDirectory.subDirectory(named: fileName) ?? Directory(name: fileName, parent: currDirectory)
        }
      case "ls":
        while index + 1 < lines.endIndex {
          let components = lines[index+1].components(separatedBy: " ")
          if components.first == "$" {
            break
          }

          if components[0] == "dir" {
            currDirectory.addSubdirectory(named: components[1])
          } else {
            let size = Int(components[0])!
            let name = components[1]
            currDirectory.addFile(named: name, size: size)
          }

          index += 1
        }
      default:
        fatalError("Unknown command: \(components[1])")
      }
      index += 1
    }

//    print(root)
    switch challengeNumber {
    case .one:
      return getAnswer1(given: root)
    case .two:
      return getAnswer2(given: root)
    }
  }

  static private func getAnswer1(given filesystem: Directory) -> String {
    var directoriesToCheck = [filesystem]
    var sizeToRemove = 0
    while let currDir = directoriesToCheck.popFirst() {
      if currDir.size <= 100000 {
        sizeToRemove += currDir.size
      }
      directoriesToCheck.append(contentsOf: currDir.subDirectories)
    }
    return "\(sizeToRemove)"
  }

  static private func getAnswer2(given filesystem: Directory) -> String {
    let freeSpace = 70000000 - filesystem.size
    guard freeSpace >= 0 else {
      fatalError("Filesystem uses more space than the entire disk.")
    }

    let spaceRequired = 30000000 - freeSpace
    guard spaceRequired >= 0 else {
      fatalError("Filesystem already has enough free space.")
    }

    var directoriesToSearch = filesystem.subDirectories
    var currDeletionDir = filesystem

    while let currDir = directoriesToSearch.popFirst() {
      if currDir.size >= spaceRequired && currDir.size <= currDeletionDir.size {
        currDeletionDir = currDir
      }
      directoriesToSearch.append(contentsOf: currDir.subDirectories)
    }

    return "\(currDeletionDir.size)"
  }
}
