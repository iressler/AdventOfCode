//
//  print.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/7/21.
//

import Foundation

func printDefaultValueMessage<T: CustomStringConvertible>(_ defaultValue: T) {
#if !TESTING
  print("No input provided, using default:\n\(defaultValue)")
  printDivider()
#endif
}

func printDivider(character: String = "=") {
#if !TESTING
  print(String(repeating: character, count: 40))
#endif
}
