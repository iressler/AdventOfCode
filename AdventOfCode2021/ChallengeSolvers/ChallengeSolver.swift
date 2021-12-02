//
//  ChallengeSolver.swift
//  AdventOfCode2021
//
//  Created by Isaac Ressler on 12/2/21.
//

import Foundation

protocol ChallengeSolver {
  static func getAnswer(challengeNumber: ChallengeNumber, input: String) -> String
}
