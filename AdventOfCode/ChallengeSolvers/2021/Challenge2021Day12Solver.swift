//
//  Challenge2021Day7Solver.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/6/21.
//

import Foundation

struct Challenge2021Day12Solver: ChallengeSolver {
  private class Node: Equatable, Hashable, CustomStringConvertible {
    static func == (lhs: Node, rhs: Node) -> Bool {
      return lhs.name == rhs.name
    }

    func hash(into hasher: inout Hasher) {
      hasher.combine(name)
    }

    let name: String
    private(set) var connections: [Node] = []

    init(name: String) {
      self.name = name
    }

    func addConnection(to node: Node) {
      self.connections.append(node)
      node.connections.append(self)
    }

    var isBigCave: Bool {
      return name.uppercased() == name
    }

    var isStart: Bool {
      return name == "start"
    }

    var isEnd: Bool {
      return name == "end"
    }

    var description: String {
      return name
    }
  }

  static let defaultValue = """
start-A
start-b
A-c
A-b
b-d
A-end
b-end
"""

  static let defaultValue2 = """
dc-end
HN-start
start-kj
dc-start
dc-HN
LN-dc
HN-end
kj-sa
kj-HN
kj-dc
"""

  static let defaultValue3 = """
fs-end
he-DX
fs-he
start-DX
pj-DX
end-zg
zg-sl
zg-pj
pj-he
RW-he
fs-DX
pj-RW
zg-RW
start-pj
he-WI
zg-he
pj-fs
start-RW
"""

  static func solution(number challengeNumber: ChallengeNumber, for input: String) -> String {
    let lines = inputComponents(from: input)
    switch challengeNumber {
    case .one:
      return getAnswer1(given: lines)
    case .two:
      return getAnswer2(given: lines)
    }
  }

  static private func node(named name: String, in nodes: inout [Node]) -> Node {
    if let node = nodes.first(where: { $0.name == name }) {
      return node
    } else {
      let newNode = Node(name: name)
      nodes.append(newNode)
      return newNode
    }
  }

  static private var canVisitOneSmallCaveTwice = false

  static private func chains(for nodes: [Node], startingAt startNode: Node, alreadyVisited: [Node] = []) -> [String] {
    var chains = [String]()
    let alreadyVisited = alreadyVisited + [startNode]
    for node in startNode.connections {
      // If the node is the start cave , or if it is a smallCave and has already been visited nothing more to do.
      if node.isStart {
        continue
      } else if node.isEnd {
        chains.append((alreadyVisited + [node]).map({ $0.name }).joined(separator: ","))
      } else if !node.isBigCave && alreadyVisited.contains(node) {
        let smallCaves = alreadyVisited.filter({ !$0.isBigCave })
        if canVisitOneSmallCaveTwice && smallCaves.count == Set(smallCaves).count {
          chains.append(contentsOf: self.chains(for: nodes, startingAt: node, alreadyVisited: alreadyVisited))
        } else {
          continue
        }
      } else {
        chains.append(contentsOf: self.chains(for: nodes, startingAt: node, alreadyVisited: alreadyVisited))
      }
    }
    return chains
  }

  static private func getAnswer1(given lines: [String]) -> String {
    var nodes = [Node]()

    for line in lines {
      let nodeNames = line.components(separatedBy: "-")
      node(named: nodeNames.first!, in: &nodes).addConnection(to: node(named: nodeNames.last!, in: &nodes))

    }
//    for node in nodes {
//      print("\(node.name): \(node.connections)")
//    }

    let chains = chains(for: nodes, startingAt: nodes.first(where: { $0.isStart })!)
//    print(chains)
    return "\(chains.count)"
  }

  static private func getAnswer2(given lines: [String]) -> String {
    self.canVisitOneSmallCaveTwice = true
    return "\(getAnswer1(given: lines))"
  }
}
