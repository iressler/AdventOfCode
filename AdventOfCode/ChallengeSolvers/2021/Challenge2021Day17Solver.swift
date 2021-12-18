//
//  Challenge2021Day17Solver.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/6/21.
//

import Foundation

struct Challenge2021Day17Solver: ChallengeSolver {
  static let defaultValue = "target area: x=20..30, y=-10..-5"
  // Actual input.
  static let defaultValue1 = "target area: x=137..171, y=-98..-73"


  static func range(from input: String) -> ClosedRange<Int> {
    let rangeComponents = input.components(separatedBy: ".").filter({ !$0.isEmpty })
    let min = Int(rangeComponents[0].components(separatedBy: "=").last!)!
    let max = Int(rangeComponents.last!.components(separatedBy: ",").first!)!
    return min...max
  }
  static func solution(number challengeNumber: ChallengeNumber, for input: String) -> String {
    let components = inputComponents(from: input, separators: .whitespacesAndNewlines)
    let xRange = range(from: components.first(where: { $0.hasPrefix("x=") })!)
    let yRange = range(from: components.first(where: { $0.hasPrefix("y=") })!)

    let map = Map(xTargetArea: xRange, yTargetArea: yRange)

    switch challengeNumber {
    case .one:
      return getAnswer1(given: map)
    case .two:
      return getAnswer2(given: map)
    }
  }

  struct Map {
    let xTargetArea: ClosedRange<Int>
    let yTargetArea: ClosedRange<Int>

    init(xTargetArea: ClosedRange<Int>, yTargetArea: ClosedRange<Int>) {
      self.xTargetArea = xTargetArea
      self.yTargetArea = yTargetArea
    }

    struct ProbeResult {
      let path: [Point]
      let hitTarget: Bool
    }

    func fireProbe(xVelocity initialXVelocity: Int, yVelocity initialYVelocity: Int) -> ProbeResult {
      var probe = Point(x: 0, y: 0)
      var probePath = [Point]()

      var xVelocity = initialXVelocity
      var yVelocity = initialYVelocity

      func passedTarget(_ probePoint: Point) -> Bool {
        return probePoint.x > xTargetArea.last! || probePoint.y < yTargetArea.first!
      }

      func inTarget(_ probePoint: Point) -> Bool {
        return xTargetArea.contains(probePoint.x) && yTargetArea.contains(probePoint.y)
      }

      probePath.append(probe)
      while !passedTarget(probe) && !inTarget(probe) {
        probe = Point(x: probe.x + xVelocity, y: probe.y + yVelocity)
        xVelocity.moveTowardZero(by: 1)
        yVelocity -= 1
        probePath.append(probe)
      }

      return ProbeResult(
        path: probePath,
        hitTarget: xTargetArea.contains(probe.x) && yTargetArea.contains(probe.y)
      )
    }
  }

  static private func probeHits(on map: Map, xVelocities: ClosedRange<Int>, yVelocities: ClosedRange<Int>) -> [[Point]] {
    var paths = [[Point]]()
    for x in xVelocities {
      for y in yVelocities {
        let result = map.fireProbe(xVelocity: x, yVelocity: y)
        if result.hitTarget {
          paths.append(result.path)
        }
      }
    }
    return paths
  }

  static private func getAnswer1(given map: Map) -> String {
    return "\(probeHits(on: map, xVelocities: 0...100, yVelocities: 0...100).map({ $0.map({ $0.y }).max()! }).max()!)"
  }

  static private func getAnswer2(given map: Map) -> String {
    // If x is more than the last target it will always overshoot it immediately.
    let maxXVelocity = map.xTargetArea.last!
    // If y is below the lowest target it will never get high enough to hit it.
    let minYVelocity = map.yTargetArea.first!
    // An approximation, can probably calculate what it actually is but this is good enough.
    let maxYVelocity = abs(minYVelocity * 2)

    return "\(probeHits(on: map, xVelocities: 0...maxXVelocity, yVelocities: minYVelocity...maxYVelocity).count)"
  }
}

private extension Int {
  mutating func moveTowardZero(by amount: Int) {
    if self > 0 {
      self -= amount
    } else if self < 0 {
      self += amount
    }
  }
}
