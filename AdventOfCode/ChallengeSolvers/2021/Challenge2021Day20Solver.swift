//
//  Challenge2021Day20Solver.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/6/21.
//

import Foundation

struct Challenge2021Day20Solver: ChallengeSolver {
  static let defaultValue = """
..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..###..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#..#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#......#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#.....####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.......##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#

#..#.
#....
##..#
..#..
..###
"""

  private struct Pixel: CustomStringConvertible {
    var isOn: Bool

    init(isOn: Bool) {
      self.isOn = isOn
    }
    init(description: String) {
      self.init(isOn: description == "#")
    }

    var binaryValue: String {
      isOn ? "1" : "0"
    }

    var description: String {
      return isOn ? "#" : "."
    }
  }

  static func solution(number challengeNumber: ChallengeNumber, for input: String) -> String {
    var lines = inputComponents(from: input)
    let enhancementAlgorithm = lines.popFirst()!

    let map = lines.map({ line in
      line.toArray().map({
        Pixel(description: $0)
      })
    })
//    print(map.fieldDescription(separator: ""))
    switch challengeNumber {
    case .one:
      return getAnswer1(given: map, enhancementAlgorithm: enhancementAlgorithm)
    case .two:
      return getAnswer2(given: map, enhancementAlgorithm: enhancementAlgorithm)
    }
  }

  static private func enhance(map map1: [[Pixel]], using enhancementAlgorithm: String, times count: Int) -> [[Pixel]]{
    var map = map1
    let offPixel = Pixel(isOn: false)
    map.grow(repeating: offPixel)
    map.grow(repeating: offPixel)

//    print(map.fieldDescription(separator: ""))
//    printDivider()

    for _ in 0..<count {
      // Sample the first pixel to get the
      let infiniteRepresentativePixel = map[1][1]
//      print("Adding 2 wrappers of: \(firstPixel)")
      map.grow(repeating: offPixel)
      map.grow(repeating: offPixel)
//      printDivider()
//      print(map.fieldDescription(separator: ""))

      var mapCopy = map
      // make the map wider to account for growth.

      for x in 1..<(map.count-1) {
        for y in 1..<(map.first!.count-1) {
          let points: [Point?] = map.pointsAdjacent(to: Point(x: x, y: y), includeDiagonals: true, includePoint: true)
          let index = points.map { (currPoint: Point?) -> String in
            if let currPoint: Point = currPoint {
              return map[currPoint].binaryValue
            } else {
              return infiniteRepresentativePixel.binaryValue
            }
          }.joined(separator: "")
          mapCopy[Point(x: x, y: y)] = Pixel(description: enhancementAlgorithm[unsafe: Int(index, radix: 2)!])
        }
      }


//      printDivider()
//      print(map.fieldDescription(separator: ""))
      mapCopy.shrink()
//      printDivider()
//      print(mapCopy.fieldDescription(separator: ""))
//      printDivider()
      map = mapCopy
    }
    return map
  }

  static private func getAnswer1(given map: [[Pixel]], enhancementAlgorithm: String) -> String {
    let newMap = enhance(map: map, using: enhancementAlgorithm, times: 2)
    return "\(newMap.map({ $0.filter({ $0.isOn }).count }).sum())"
  }

  static private func getAnswer2(given map: [[Pixel]], enhancementAlgorithm: String) -> String {
    let newMap = enhance(map: map, using: enhancementAlgorithm, times: 50)
    return "\(newMap.map({ $0.filter({ $0.isOn }).count }).sum())"
  }
}
