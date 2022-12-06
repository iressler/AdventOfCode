//
//  OtherSolution.swift
//  AdventOfCode
//  Created by Greg Kettell on 12/12/21.
//

import Foundation


class Day19Of2021 {
  let test = false
  let day = 19
  let puzzleName = "Beacon Scanner"
  var scanners: [Scanner]
  var solvedScanners: [Scanner]

  init(dataSet: [String]) {
//    let dataset = readFile((test ? "test\(day)" : "day\(day)")).components(separatedBy: "\n\n")
    scanners = []
    solvedScanners = []
    var i = 0
    while i < dataSet.count {
      let idSection = dataSet[i]
      i += 1

      let id = idSection.components(separatedBy: CharacterSet(charactersIn: "0123456789").inverted).filter{!$0.isEmpty}.map{ Int($0)!}[0]

      var points = [Point]()

      // parse coords
      while i < dataSet.count && !dataSet[i].isEmpty {
        let row = dataSet[i]
        i += 1
        let xyz:[Int] = row.components(separatedBy: CharacterSet(charactersIn: "-0123456789").inverted).filter{!$0.isEmpty}.map{ Int($0)!}
        points.append(Point(xyz[0], xyz[1], xyz[2]))
      }

      scanners.append(Scanner(id, points))
      i += 1
    }
  }

  func run() {
    print ("Day \(day): \(puzzleName)")

    var myscanners = scanners
    // target will contain all found coordinates. Start with scanner 0
    solvedScanners.append(myscanners[0])
    var target = myscanners.removeFirst()

    var lastcount = myscanners.count
    while true {
      for idx in 0..<myscanners.count {  // Scanner 0 is our reference
        var scanner = myscanners[idx]
        if register(source: &scanner, target: &target) {
          solvedScanners.append(myscanners.remove(at: idx))
          break  // restart loop since we removed a scanner
        }
      }
      if myscanners.count == 0 {
        break
      } else if lastcount == myscanners.count {
        print("no hits on last iteration, aborting. \(myscanners.count) scanners incomplete")
        break
      }
      lastcount = myscanners.count
    }
    print("Pt 1: \(target.coords.count) beacons mapped")

    // Part 2 - Manhattan distance
    var maxdist = 0
    for i in 0..<solvedScanners.count {
      for j in 0..<solvedScanners.count {
        if i != j {
          let md = abs(solvedScanners[i].scannerLoc.x - solvedScanners[j].scannerLoc.x) +
          abs(solvedScanners[i].scannerLoc.y - solvedScanners[j].scannerLoc.y) +
          abs(solvedScanners[i].scannerLoc.z - solvedScanners[j].scannerLoc.z)
          maxdist = max(md, maxdist)
        }
      }
    }
    print("Pt 2: Longest Manhattan distance: \(maxdist)")
  }

  func register(source: inout Scanner, target: inout Scanner) -> Bool {  // Returns array of rotated/translated coordinates
                                                                         // consider orientation, then translation
    for idx in 0..<24 {
      var _coords = source.coords
      for i in 0..<_coords.count {
        _coords[i] = getRot(_coords[i], index: idx)
      }
      source.coordsCorrected = _coords
      if translate(source: &source, target: &target) {
        return true // Success
      }
    }

    return false
  }

  func translate(source: inout Scanner, target: inout Scanner) -> Bool {

    // build sets of x coordinates for source and target
    let setinx: Set = Set(source.coordsCorrected.map{$0.x})
    let setintx: Set = Set(target.coords.map{$0.x})

    // determine range
    let xmin = setintx.min()! - (setinx.max()! - setinx.min()!)
    let xmax = setintx.max()! + (setinx.max()! - setinx.min()!)

    var xhits:[Int: Int] = [:]
    for xdelta in stride(from: xmax, to: xmin, by: -1) {
      let commonx = setintx.intersection(setinx.map{$0+xdelta})
      if commonx.count > 10 {
        xhits[xdelta] = commonx.count
      }
    }
    if !xhits.isEmpty {
      let max = xhits.max { a, b in a.value < b.value }!
      let xdelta = max.key

      // now do y
      let setiny: Set = Set(source.coordsCorrected.map{$0.y})
      let setinty: Set = Set(target.coords.map{$0.y})

      let ymin = setinty.min()! - (setiny.max()! - setiny.min()!)
      let ymax = setinty.max()! + (setiny.max()! - setiny.min()!)

      var yhits:[Int: Int] = [:]
      for ydelta in ymin...ymax {
        let commony = setinty.intersection(setiny.map{$0+ydelta})
        if commony.count > 10 {
          yhits[ydelta] = commony.count
        }
      }
      if !yhits.isEmpty {
        let max = yhits.max { a, b in a.value < b.value }!
        let ydelta = max.key

        // now do z
        let setinz: Set = Set(source.coordsCorrected.map{$0.z})
        let setintz: Set = Set(target.coords.map{$0.z})

        let zmin = setintz.min()! - (setinz.max()! - setinz.min()!)
        let zmax = setintz.max()! + (setinz.max()! - setinz.min()!)

        var zhits:[Int: Int] = [:]
        for zdelta in zmin...zmax {
          let commonz = setintz.intersection(setinz.map{$0+zdelta})
          if commonz.count > 10 {
            zhits[zdelta] = commonz.count
          }
        }
        if !zhits.isEmpty {
          let max = zhits.max { a, b in a.value < b.value }!
          let zdelta = max.key

          for idx in 0..<source.coordsCorrected.count {
            let item = source.coordsCorrected[idx]
            let newloc = Point(item.x + xdelta, item.y + ydelta, item.z + zdelta)

            if !target.coords.contains(newloc) {
              target.coords.append(newloc)
            }
          }
          source.scannerLoc = Point(xdelta, ydelta, zdelta)
          return true
        }
      }
    }
    return false
  }

  class Scanner: CustomStringConvertible {
    let id: Int
    var coords: [Point]
    var coordsCorrected: [Point]
    var scannerLoc: Point = Point()

    init (_ id: Int, _ coords: [Point] = []) {
      self.id = id
      self.coords = coords
      self.coordsCorrected = coords
    }

    var description: String {
      return "<Scanner \(id):\n\(coords)\n\(coordsCorrected)\n\(scannerLoc)>"
    }
  }

  struct Point: Hashable, Equatable, CustomStringConvertible {
    let x: Int
    let y: Int
    let z: Int
    init(_ x: Int=0, _ y: Int=0, _ z: Int=0){
      self.x = x
      self.y = y
      self.z = z
    }

    var description: String {
      return "\(x),\(y),\(z)"
    }
  }

  func getRot(_ v: Point, index: Int) -> Point {
    var _v: Point = Point()
    switch(index) {
      // rotate around x axis
    case 0: _v = Point(v.x, v.y, v.z)
    case 1: _v = Point(v.x, v.z, -v.y)
    case 2: _v = Point(v.x, -v.y, -v.z)
    case 3: _v = Point(v.x, -v.z, v.y)
      // rotate around y axis
    case 4: _v = Point(-v.y, v.x, v.z)
    case 5: _v = Point(-v.z, v.x, -v.y)
    case 6: _v = Point(v.y, v.x, -v.z)
    case 7: _v = Point(v.z, v.x, v.y)
      // rotate around z axis
    case 8: _v = Point(-v.z, v.y, v.x)
    case 9: _v = Point(v.y, v.z, v.x)
    case 10: _v = Point(v.z, -v.y, v.x)
    case 11: _v = Point(-v.y, -v.z, v.x)
      // rotate around -x axis
    case 12: _v = Point(-v.x, v.y, -v.z)
    case 13: _v = Point(-v.x, v.z, v.y)
    case 14: _v = Point(-v.x, -v.y, v.z)
    case 15: _v = Point(-v.x, -v.z, -v.y)
      // rotate around -y axis
    case 16: _v = Point(v.y, -v.x, v.z)
    case 17: _v = Point(-v.z, -v.x, v.y)
    case 18: _v = Point(-v.y, -v.x, -v.z)
    case 19: _v = Point(v.z, -v.x, -v.y)
      // rotate around -z axis
    case 20: _v = Point(v.z, v.y, -v.x)
    case 21: _v = Point(v.y, -v.z, -v.x)
    case 22: _v = Point(-v.z, -v.y, -v.x)
    case 23: _v = Point(-v.y, v.z, -v.x)
    default: break
    }
    return _v
  }
}

