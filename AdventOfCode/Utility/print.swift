//
//  print.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/7/21.
//

import Foundation

func print(_ item: String, separator: String = " ", terminator: String = "\n") {
#if !TESTING
  Swift.print(item, separator: separator, terminator: terminator)
#endif
}

func print(_ items: [Any], separator: String = " ", terminator: String = "\n") {
#if !TESTING
  Swift.print(items, separator: separator, terminator: terminator)
#endif
}


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
