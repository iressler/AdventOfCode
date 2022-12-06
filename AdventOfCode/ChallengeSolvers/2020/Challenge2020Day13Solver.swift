//
//  Challenge2020Day13Solver.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/6/21.
//

import Foundation

struct Challenge2020Day13Solver: ChallengeSolver {
  static let defaultValue = """
939
7,13,x,x,59,x,31,19
"""

  static func solution(number challengeNumber: ChallengeNumber, for input: String) -> String {
    let lines = inputComponents(from: input)
    let arrivalTime = Int(lines[0])!
    let busIDs = lines[1].components(separatedBy: ",").map({ Int($0) })

    switch challengeNumber {
    case .one:
      return getAnswer1(arrivalTime: arrivalTime, busIds: busIDs)
    case .two:
      return getAnswer2(busIds: busIDs)
    }
  }

  static private func getAnswer1(arrivalTime: Int, busIds busIDs: [Int?]) -> String {
//    var busIds = busIDs.compactMap()
//
//    var busIDsWithArrivalTime: [(Int, Int)] = busIds.map { busId in
//
//
//      (busId, -(arrivalTime % busId) + busId)
//    }
//
//    let busIdsByArrivalTime = busIDsWithArrivalTime.sorted(by: { $0.1 < $1.1 })
//    print("\(busIdsByArrivalTime.first!)")
//    return "\(busIdsByArrivalTime.first!.0 * busIdsByArrivalTime.first!.1)"
    return ""
  }

  static private func getAnswer2(busIds: [Int?]) -> String {
//    var busIdIndex = [Int: Int]()

//    let maxId = busIds
//
//    var step = maxId
//    while true {
//      if (step % 1000) < maxId {
//        print(step)
//      }
//
//      step += maxId
//      if step % maxId != 0 {
//        print("huh?")
//      }
//      if step >= 1068781 {
//        return ""
//      }
//    }

//    let target = 1068781
//    for (i, id) in busIds.enumerated() {
//      guard let id = id else {
//        continue
//      }
//
//      print("\(target) % \(id): \(target % id)")
//      print("\(target)+\(i) % \(id): \((target+i) % id)")
//      print("\(target) % \(id)+\(i): \(target % (id+i))")
//      print("\(target) % \(id)-\(i): \(target % (id-i))")
//      print("(\(target) % \(id)-\(i))-\(i): \((target % (id-i)) - i)")
//    }
    return ""
  }
}
