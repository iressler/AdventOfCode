//
//  Challenge2020Day17Solver.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/6/21.
//

import Foundation

struct Challenge2020Day17Solver: ChallengeSolver {
  static let defaultValue = """
.#.
..#
###
"""

  static func solution(number challengeNumber: ChallengeNumber, for input: String) -> String {
    let cubes = inputComponents(from: input).map({ Array($0).map({ $0 == "#" }) })
    switch challengeNumber {
    case .one:
      return getAnswer1(given: cubes)
    case .two:
      return getAnswer2(given: cubes)
    }
  }

  // Update the activeCubes to always have at least one false point surrounding them.

  // e.g. (ignoring z&w) convert this:
  // .#.
  // ###
  // ...
  // Into:
  // .....
  // ..#..
  // .###.
  // .....
  private struct PaddingCalculation {
    var maxW: Int = 0
    var minW: Int
    var maxZ: Int = 0
    var minZ: Int
    var maxX: Int = 0
    var minX: Int
    var maxY: Int = 0
    var minY: Int

    let wCount: Int
    let zCount: Int
    let xCount: Int
    let yCount: Int


    private init(wCount: Int, for array: [[[Bool]]]) {
      self.minW = wCount
      self.wCount = wCount
      let zCount = array.count
      self.minZ = zCount
      self.zCount = zCount
      let xCount = array[0].count
      self.minX = xCount
      self.xCount = xCount
      let yCount = array[0][0].count
      self.minY = yCount
      self.yCount = yCount
    }

    mutating private func calculate(for activeCubes: [[[[Bool]]]]) {
      for w in 0..<activeCubes.count {
        calculate(for: activeCubes[w], w: w)
      }
    }

    mutating private func calculate(for activeCubes: [[[Bool]]], w: Int = -1) {
      for z in 0..<activeCubes.count {
        let field = activeCubes[z]
        for x in 0..<field.count {
          let row = field[x]
          for y in 0..<row.count {
            if row[y] {
              maxW = max(maxW, w)
              minW = min(minW, w)
              maxZ = max(maxZ, z)
              minZ = min(minZ, z)
              maxX = max(maxX, x)
              minX = min(minX, x)
              maxY = max(maxY, y)
              minY = min(minY, y)
            }
          }
        }
      }
    }

    init(for array: [[[Bool]]]) {
      self.init(wCount: -1, for: array)
      self.calculate(for: array)
    }

    init(for array: [[[[Bool]]]]) {
      self.init(wCount: array.count, for: array[0])
      self.calculate(for: array)
    }

    // - 2 is -1 because count is 1 more than the index, and -1 for growth.
    private lazy var wRemoveSuffixCount: Int = {
      return (wCount - maxX) - 2
    }()

    private lazy var zRemoveSuffixCount: Int = {
      return (zCount - maxZ) - 2
    }()

    private lazy var xRemoveSuffixCount: Int = {
      return (xCount - maxX) - 2
    }()

    private lazy var yRemoveSuffixCount: Int = {
      return (yCount - maxY) - 2
    }()


    // -1 for growth
    private lazy var wRemovePrefixCount: Int = {
      minW - 1
    }()

    private(set) lazy var zRemovePrefixCount: Int = {
      minZ - 1
    }()

    private lazy var xRemovePrefixCount: Int = {
      minX - 1
    }()

    private lazy var yRemovePrefixCount: Int = {
      minY - 1
    }()

    private lazy var newXArray: [Bool] = {
      return [Bool](repeating: false, count: yCount)
    }()

    private lazy var newZArray: [[Bool]] = {
      return [[Bool]](repeating: newXArray, count: xCount)
    }()

    private lazy var newWArray: [[[Bool]]] = {
      return [[[Bool]]](repeating: newZArray, count: zCount)
    }()

    mutating func update(_ activeCubes: inout [[[[Bool]]]]) {
      // Everything is max before min, because when updating doing the min first can break the max calculations.
      if maxW == (activeCubes.count-1) {
        activeCubes.append(newWArray)
      } else if wRemoveSuffixCount > 0 {
        activeCubes.removeLast(wRemoveSuffixCount)
      }

      if minW == 0 {
        activeCubes.prepend(newWArray)
      } else if wRemovePrefixCount > 0 {
        activeCubes.removeFirst(wRemovePrefixCount)
      }

      for i in 0..<activeCubes.count {
        var array = activeCubes[i]
        update(&array)
        activeCubes[i] = array
      }
    }

    mutating func update(_ activeCubes: inout [[[Bool]]]) {
      // Everything is max before min, because when updating doing the min first can break the max calculations.
      // Update the Z array to have exactly 1 all false field on each end.
      if maxZ == (activeCubes.count-1) {
        activeCubes.append(newZArray)
      } else if zRemoveSuffixCount > 0 {
        activeCubes.removeLast(zRemoveSuffixCount)
      }

      if minZ == 0 {
        activeCubes.prepend(newZArray)
      } else if zRemovePrefixCount > 0 {
        activeCubes.removeFirst(zRemovePrefixCount)
      }

      for z in 0..<activeCubes.count {
        // Update the X array at position z to have the correct number of arrays.
        if maxX == (activeCubes[z].count-1) {
          activeCubes[z].append(newXArray)
        } else if xRemoveSuffixCount > 0 {
          activeCubes[z].removeLast(xRemoveSuffixCount)
        }

        if minX == 0 {
          activeCubes[z].prepend(newXArray)
        } else if xRemovePrefixCount > 0 {
          activeCubes[z].removeFirst(xRemovePrefixCount)
        }

        for x in 0..<activeCubes[z].count {
          // Update the Y array at position z,x to have the correct number of "cubes".
          if maxY == (activeCubes[z][x].count-1) {
            activeCubes[z][x].append(false)
          } else if yRemoveSuffixCount > 0 {
            activeCubes[z][x].removeLast(yRemoveSuffixCount)
          }

          if minY == 0 {
            activeCubes[z][x].prepend(false)
          } else if yRemovePrefixCount > 0 {
            activeCubes[z][x].removeFirst(yRemovePrefixCount)
          }
        }
      }
    }
  }


  static private func addPadding(to activeCubes: inout [[[[Bool]]]]) {
    var result = PaddingCalculation(for: activeCubes)
    result.update(&activeCubes)
  }

  static private func addPadding(to activeCubes: inout [[[Bool]]]) {
    var result = PaddingCalculation(for: activeCubes)
    result.update(&activeCubes)
  }

  private static func updateLife(in activeCubes: inout [[[[Bool]]]]) {
    var newCubes = activeCubes
    for w in 0..<activeCubes.count{
      for z in 0..<activeCubes[w].count {
        for x in 0..<activeCubes[w][z].count {
          for y in 0..<activeCubes[w][z][x].count {
            let point = Point(x: x, y: y, z: z, w: w)
            let numberActiveNeighbors = activeCubes.pointsAdjacent(to: point, includeDiagonals: true).filter({ activeCubes[$0] }).count
            if activeCubes[point] {
              newCubes[point] = (2...3).contains(numberActiveNeighbors)
            } else if numberActiveNeighbors == 3 {
              newCubes[point] = true
            }
          }
        }
      }
    }
    activeCubes = newCubes
  }

  private static func updateLife(in activeCubes: inout [[[Bool]]]) {
    var superActiveCubes = [activeCubes]
    updateLife(in: &superActiveCubes)
    activeCubes = superActiveCubes[0]
  }

  static private func getAnswer1(given cubes: [[Bool]]) -> String {
    // Indexed [z][x][y]
    var activeCubes = [cubes]

    for _ in 0..<6 {
//      print(activeCubes.fieldDescription())
      addPadding(to: &activeCubes)

      updateLife(in: &activeCubes)
    }
//    print(activeCubes.fieldDescription())

    return "\(activeCubes.map({ $0.map({ $0.filter({ $0 }).count }).sum() }).sum())"
  }

  static private func getAnswer2(given cubes: [[Bool]]) -> String {
    // Indexed [w][z][x][y]
    var activeCubes = [[cubes]]

    for _ in 0..<6 {
      //      print(activeCubes.fieldDescription())
      addPadding(to: &activeCubes)

      updateLife(in: &activeCubes)
    }
    //    print(activeCubes.fieldDescription())

    return "\(activeCubes.map({ $0.map({ $0.map({ $0.filter({ $0 }).count }).sum() }).sum() }).sum())"
  }
}

extension Collection where Element: Collection, Element.Element: Equatable {
  func contains(_ element: Element.Element) -> Bool {
    for row in self where row.contains(element) {
      return true
    }
    return false
  }
}
