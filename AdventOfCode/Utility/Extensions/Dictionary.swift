//
//  Dictionary.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/7/21.
//

import Foundation

extension Dictionary where Value: AdditiveArithmetic {
  mutating func incrementValue(for key: Key, by value: Value) {
    incrementValue(for: key, amount: value)
  }

  mutating func incrementValue(for key: Key, by value: Value = 1) where Value == IntegerLiteralType {
    incrementValue(for: key, amount: value)
  }

  private mutating func incrementValue(for key: Key, amount: Value) {
    if let existingValue = self[key] {
      self[key] = existingValue + amount
    } else {
      self[key] = amount
    }
  }
}
