//
//  Utility.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/2/21.
//

import Foundation

// The methods that use Int as indices are unsafe, but enable easier String manipulation.
// Not good for production code, but good enough for this.
extension String {
  subscript(unsafeCharacter index: Int) -> Character {
    guard count > index else {
      fatalError("Trying to access string index after end of string.")
    }
    return self[self.index(startIndex, offsetBy: index)]
  }

  func substring(starting startIndex: Int, length: Int? = nil) -> String {
    let length = length ?? (count - startIndex)
    return self[unsafe: startIndex..<startIndex+length]
  }

  subscript(unsafe index: Int) -> String {
    return String(self[unsafeCharacter: index])
  }

  subscript<R: RangeExpression>(unsafe rangeExpression: R) -> String where R.Bound == Int {
    // Convert any RangeExpression to a Range, which allows offsetting within the String.
    let range = rangeExpression.relative(to: 0..<count)

    // Fail deterministically if something unsafe is happening.
    guard !range.isEmpty && range.first! >= 0 && range.last! < count else {
      fatalError("Unsafe String range access!!")
    }

    let startIndex = self.index(startIndex, offsetBy: range.first!)
    let endIndex = self.index(startIndex, offsetBy: range.count)
    return String(self[startIndex..<endIndex])
  }
}

extension String {
  subscript(range: NSRange) -> String {
    (self as NSString).substring(with: range)
  }

  mutating func replaceSubstring(at range: NSRange, with newSubString: String) {
    self = (self as NSString).replacingCharacters(in: range, with: newSubString)
  }
}

extension String {
  // There must be a better way to do this.
  func enumeratedStrings() -> EnumeratedSequence<[String]> {
    return toArray().enumerated()
  }

  func alphabetized() -> String {
    return String(sorted())
  }

  mutating func alphabetize() {
    self = alphabetized()
  }

  func toArray() -> [String] {
    return Array(self).map({ String($0) })
  }
}


// MARK: - Splitting
extension String {
  func splitInHalf() -> [Self] {
    let ct = self.count
    let half = index(startIndex, offsetBy: ct / 2)

    let leftSplit = self[startIndex ..< half]
    let rightSplit = self[half ..< endIndex]
    return [Self(leftSplit), Self(rightSplit)]
  }
}
