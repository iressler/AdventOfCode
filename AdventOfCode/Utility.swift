//
//  Utility.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/2/21.
//

import Foundation

func printDefaultValueMessage<T: CustomStringConvertible>(_ defaultValue: T) {
  print("No input provided, using default:\n\(defaultValue)")
}

func printResult(_ result: String) {
  print("Result: \(result)")
}
