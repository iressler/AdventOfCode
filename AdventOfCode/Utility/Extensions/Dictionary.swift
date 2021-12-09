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

extension Dictionary where Value: RangeReplaceableCollection {
  mutating func appendValue(for key: Key, _ value: Value.Element) {
    self.appendValues(for: key, Value([value]))
  }

  mutating func appendValues(for key: Key, _ value: Value) {
    if var existingValue = self[key] {
      existingValue.append(contentsOf: value)
      self[key] = existingValue
    } else {
      self[key] = value
    }
  }
}

extension Dictionary where Value: RangeReplaceableCollection, Value.Element: Equatable {
  mutating func removeValue(for key: Key, _ value: Value.Element) {
    self.removeValues(for: key, Value([value]))
  }

  mutating func removeValues(for key: Key, _ value: Value) {
    self[key] = self[key]?.filter({ !value.contains($0)})
  }
}

extension Dictionary where Value: Hashable {
  func inverted() -> Dictionary<Value, Key> {
    var newDictionary = [Value: Key]()

    for (key, value) in self {
      newDictionary[value] = key
    }

    return newDictionary
  }
}

extension Dictionary where Key == Value {
  mutating func invert() {
    self = inverted()
  }
}
