//
//  main.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/2/21.
//

import Foundation
import ArgumentParser

enum Command {}

private struct TransformationError: Error, CustomStringConvertible {
  let description: String
}

extension Command {
  struct Main: ParsableCommand {
    typealias IntArgument = Comparable & ExpressibleByArgument & CaseIterable & RawRepresentable

    static func transformer<T: IntArgument>() -> (String) throws -> T {
      return { input in
        guard let number = T(argument: input) else {
          throw TransformationError(description: "The provided value was not a number.")
        }
        let min = T.allCases.first!
        let max = T.allCases[T.allCases.index(T.allCases.indices.first!, offsetBy:T.allCases.count - 1)]
        if number < min || number > max {
          throw TransformationError(description: "The provided number must be between \(min.rawValue) and \(max.rawValue) (inclusive).")
        }
        return number
      }
    }

    @Argument(help: "The challenge year.", transform: Self.transformer()) var challengeYear: ChallengeYear
    @Argument(help: "The challenge day number.", transform: Self.transformer()) var challengeDay: ChallengeDay
    @Argument(help: "The challenge number.", transform: Self.transformer()) var challengeNumber: ChallengeNumber
    @Argument(help: "The challenge input or a path to a file containing the challenge input") var input: String?

    static var configuration: CommandConfiguration {
      .init(
        commandName: "AdventOfCode",
        abstract: "A program to solve the Advent of Code challenges",
        version: "1.0",
        subcommands: []
      )
    }

    func run() throws {
      let fm = FileManager.default
      var input: String = ""

      if let tempInput = self.input, !tempInput.isEmpty {
        let url = URL(fileURLWithPath: tempInput)
        if fm.fileExists(atPath: url.path), fm.isReadableFile(atPath: url.path) {
          print("Found input file, loading...")
          do {
            input = try String(contentsOf: url)
          } catch {
            print("Failed to load input from \(url.path)")
            throw error
          }
        } else {
          input = tempInput
        }
      }

      let challenge = Challenge(year: challengeYear, day: challengeDay, number: challengeNumber)

      print("Solution for day #\(challengeDay.rawValue) challenge #\(challengeNumber.rawValue):")
      print(challenge.solution(for: input))
    }
  }
}

Command.Main.main()
