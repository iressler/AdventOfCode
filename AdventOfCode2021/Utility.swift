//
//  Utility.swift
//  AdventOfCode2021
//
//  Created by Isaac Ressler on 12/2/21.
//

import Foundation

func printDefaultValueMessage<T: CustomStringConvertible>(_ defaultValue: T) {
  print("No input provided, using default: \(defaultValue)")
}

func printResult(_ result: String) {
  print("Result: \(result)")
}
