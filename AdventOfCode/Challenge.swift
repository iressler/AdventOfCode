//
//  Challenge.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/3/21.
//

import Foundation

struct Challenge {
  let year: ChallengeYear
  let day: ChallengeDay
  let number: ChallengeNumber

  init(year: ChallengeYear, day: ChallengeDay, number: ChallengeNumber) {
    self.year = year
    self.day = day
    self.number = number
  }

  private var solvers: [ChallengeYear: [ChallengeSolver.Type]] = [
    .twentyTwenty: [
      Challenge2020Day1Solver.self,
      Challenge2020Day2Solver.self,
      Challenge2020Day3Solver.self
    ],
    .twentyTwentyOne: [
      Challenge2021Day1Solver.self,
      Challenge2021Day2Solver.self,
      Challenge2021Day3Solver.self,
      Challenge2021Day4Solver.self,
      Challenge2021Day5Solver.self
    ]
  ]

  func solution(for input: String) -> String {
    return solvers[year]![day.rawValue - 1].solution(number: number, for: input)
  }
}
