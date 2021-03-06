//
//  print.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/7/21.
//

import Foundation

func printDefaultValueMessage<T: CustomStringConvertible>(_ defaultValue: T) {
  print("No input provided, using default:\n\(defaultValue)")
  printDivider()
}

func printDivider(character: String = "=") {
  print(String(repeating: character, count: 40))
}
