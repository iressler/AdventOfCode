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
      Challenge2020Day3Solver.self,
      Challenge2020Day4Solver.self,
      Challenge2020Day5Solver.self,
      Challenge2020Day6Solver.self,
      Challenge2020Day7Solver.self,
      Challenge2020Day8Solver.self,
      Challenge2020Day9Solver.self,
      Challenge2020Day10Solver.self,
      Challenge2020Day11Solver.self,
      Challenge2020Day12Solver.self,
      Challenge2020Day13Solver.self,
      Challenge2020Day14Solver.self,
      Challenge2020Day15Solver.self,
      Challenge2020Day16Solver.self,
      Challenge2020Day17Solver.self,
      Challenge2020Day18Solver.self,
      Challenge2020Day19Solver.self,
      Challenge2020Day20Solver.self,
      Challenge2020Day21Solver.self,
      Challenge2020Day22Solver.self,
      Challenge2020Day23Solver.self,
      Challenge2020Day24Solver.self,
      Challenge2020Day25Solver.self
    ],
    .twentyTwentyOne: [
      Challenge2021Day1Solver.self,
      Challenge2021Day2Solver.self,
      Challenge2021Day3Solver.self,
      Challenge2021Day4Solver.self,
      Challenge2021Day5Solver.self,
      Challenge2021Day6Solver.self,
      Challenge2021Day7Solver.self,
      Challenge2021Day8Solver.self,
      Challenge2021Day9Solver.self,
      Challenge2021Day10Solver.self,
      Challenge2021Day11Solver.self,
      Challenge2021Day12Solver.self,
      Challenge2021Day13Solver.self,
      Challenge2021Day14Solver.self,
      Challenge2021Day15Solver.self,
      Challenge2021Day16Solver.self,
      Challenge2021Day17Solver.self,
      Challenge2021Day18Solver.self,
      Challenge2021Day19Solver.self,
      Challenge2021Day20Solver.self,
      Challenge2021Day21Solver.self,
      Challenge2021Day22Solver.self,
      Challenge2021Day23Solver.self,
      Challenge2021Day24Solver.self,
      Challenge2021Day25Solver.self
    ],
    .twentyTwentyTwo: [
      Challenge2022Day1Solver.self,
      Challenge2022Day2Solver.self,
      Challenge2022Day3Solver.self,
      Challenge2022Day4Solver.self,
      Challenge2022Day5Solver.self,
      Challenge2022Day6Solver.self,
      Challenge2022Day7Solver.self,
      Challenge2022Day8Solver.self,
      Challenge2022Day9Solver.self,
      Challenge2022Day10Solver.self,
      Challenge2022Day11Solver.self,
      Challenge2022Day12Solver.self,
      Challenge2022Day13Solver.self,
      Challenge2022Day14Solver.self,
      Challenge2022Day15Solver.self,
      Challenge2022Day16Solver.self,
      Challenge2022Day17Solver.self,
      Challenge2022Day18Solver.self,
      Challenge2022Day19Solver.self,
      Challenge2022Day20Solver.self,
      Challenge2022Day21Solver.self,
      Challenge2022Day22Solver.self,
      Challenge2022Day23Solver.self,
      Challenge2022Day24Solver.self,
      Challenge2022Day25Solver.self
    ]
  ]

  func solution(for input: String) -> String {
    return solvers[year]![day.rawValue - 1].solution(number: number, for: input)
  }
}
