//
//  Array.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/7/21.
//

import Foundation

extension Array {
  subscript(wrapping index: Index) -> Element {
    return self[((index % count) + count) % count]
  }
}
