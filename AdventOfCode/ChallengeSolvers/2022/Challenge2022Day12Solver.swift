//
//  Challenge2022Day12Solver.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/6/21.
//

import Foundation

private extension Character {
  var height: Int {
    switch self {
    case "S":
      return 0
    case "E":
      return 25
    default:
      return ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
        .firstIndex(of: self)!
    }
  }
}

private class Node: CustomStringConvertible {
  let height: Int
  private(set) var distance: Int?
  var parent: Node?
  var neighbors: [Node]

  init(height: Int, distance: Int? = nil, parent: Node? = nil, neighbors: [Node] = []) {
    self.height = height
    self.distance = distance
    self.parent = parent
    self.neighbors = neighbors
  }

  var description: String {
    var description = "(\(height)): \(distance ?? -1)"
    for neighbor in neighbors {
      description += "\n  \(neighbor.height): \(neighbor.distance ?? -1)"
    }

    return description
  }

  func update(distance newDistance: Int) {
    self.updatedistanceIfShorter(newDistance)
  }

  private func updatedistanceIfShorter(_ newDistance: Int) {
    guard distance == nil || newDistance < distance! else {
      return
    }
    distance = newDistance
    for neighbor in neighbors {
      neighbor.updatedistanceIfShorter(newDistance + 1)
    }
  }
}


//extension Node: Equatable {
//  static func == (lhs: Node, rhs: Node) -> Bool {
//    return lhs.value == rhs.value
//  }
//}

//extension Node: Hashable {
//  func hash(into hasher: inout Hasher) {
//    height.hash(into: &hasher)
//  }
//}

private struct Map {
  let nodes: [[Node]]
  let start: Point
  let end: Point

  init(description: [String]) {
    let map = description.map({ Array($0) })
    self.nodes = map.indices.map({ x in
      let row = map[x]
      return row.indices.map({ y in
        return Node(height: map[x][y].height)
      })
    })

    var start: Point?
    var end: Point?
    for x in map.indices {
      let row = map[x]
      for y in row.indices {
        if row[y] == "S" {
          start = Point(x: x, y: y)
        } else if row[y] == "E" {
          end = Point(x: x, y: y)
        }
      }
    }

    self.start = start!
    self.end = end!
  }

  func findShortestPathToEnd(startPoints: [Point]? = nil) -> Int {
    var pointsToProcess = startPoints ?? [start]

    for point in pointsToProcess {
      nodes[point].update(distance: 0)
    }

    while let currPoint = pointsToProcess.popFirst() {
      let currNode = nodes[currPoint]
      let maxDestinationHeight = currNode.height + 1
      let newNeighborDistance = currNode.distance! + 1
      for neighborPoint in nodes.pointsAdjacent(to: currPoint) {
        let neighborNode = nodes[neighborPoint]
        // If it can be reached from the currentNode.
        if neighborNode.height <= maxDestinationHeight {
          if neighborNode.distance == nil {
            pointsToProcess.append(neighborPoint)
          }
          if neighborNode.distance == nil || neighborNode.distance! > newNeighborDistance {
            neighborNode.parent = currNode
            neighborNode.update(distance: newNeighborDistance)
          } // Else this is slower than any previous paths to this neighbor.
        } // Else it's to tall to reach.
      }
    }

    return nodes[end].distance!
  }

//  func old() -> Int {
//    let totalNodesCount = map.count * map[0].count
//
//    let endNode = Node(value: end)
//
//    var processedNodes = Set(arrayLiteral: endNode)
//
//    var nextNodes = [Node(value: start, distance: 0)]
//
//    while let currNode = nextNodes.popFirst() {
//      let maxDestinationHeight = map[currNode.value].height + 1
//      let newDistance = currNode.distance + 1
//      let adjacentPoints: [Point] = map.pointsAdjacent(to: currNode.value)
//      for adjacentPoint in adjacentPoints {
//        // If the point can be accessed from the current point.
//        if map[adjacentPoint].height <= maxDestinationHeight {
//          // If the node was already processed update it.
//          if let existingNode = processedNodes.first(where: { $0.value == adjacentPoint }) {
//            if existingNode.distance > newDistance {
//              existingNode.parent = currNode
//              existingNode.update(distance: newDistance)
//            } // Else this is a longer path to this node, do nothing.
//            // If the path is needed need to track the parent, and update here *if* the the distance is shorter than the current distance.
//          } else {
//            nextNodes.append(Node(value: adjacentPoint, distance: newDistance))
//          }
//        }
//      }
//
//      processedNodes.insert(currNode)
//      if processedNodes.count % 100 == 0 {
//        print("\(processedNodes.count) / \(totalNodesCount)")
//      }
//    }
//
//    return endNode.distance
//  }
}

struct Challenge2022Day12Solver: ChallengeSolver {
  static let defaultValue = """
Sabqponm
abcryxxl
accszExk
acctuvwj
abdefghi
"""

  static func solution(number challengeNumber: ChallengeNumber, for input: String) -> String {
    let lines = Map(description: inputComponents(from: input))

    switch challengeNumber {
    case .one:
      return getAnswer1(given: lines)
    case .two:
      return getAnswer2(given: lines)
    }
  }

  static private func getAnswer1(given map: Map) -> String {
    let length = map.findShortestPathToEnd()
    return "\(length)"
  }

  static private func getAnswer2(given map: Map) -> String {
    var startPoints = [Point]()
    for x in map.nodes.indices {
      for y in map.nodes[x].indices {
        if map.nodes[x][y].height == 0 {
          startPoints.append(Point(x: x, y: y))
        }
      }
    }
    let length = map.findShortestPathToEnd(startPoints: startPoints)
    return "\(length)"
  }}
