//
//  Math.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/13/22.
//

import Foundation

func greatestCommonDenominator(_ a: Int, _ b: Int) -> Int {
  guard a != b else {
    return a
  }
  if a > b {
    return greatestCommonDenominator(a-b,b)
  } else {
    return greatestCommonDenominator(a,b-a)
  }
}

func lowerCommonMultiple(_ a: Int, _ b: Int) -> Int {
  return (a * b) / greatestCommonDenominator(a, b)
}
