//
//  Challenge2021Day16Solver.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/6/21.
//

import Foundation

struct Challenge2021Day16Solver: ChallengeSolver {
  static let defaultValue1 = "D2FE28"
  static let defaultValue2 = "38006F45291200"
  static let defaultValue3 = "EE00D40C823060"
  static let defaultValue4 = "8A004A801A8002F478"
  static let defaultValue5 = "620080001611562C8802118E34"
  static let defaultValue6 = "C0015000016115A2E0802F182340"
  static let defaultValue = "A0016C880162017C3686B18A3D4780"

  static let defaultValue8 = "C200B40A82"
  static let defaultValue9 = "04005AC33890"
  static let defaultValueA = "880086C3E88112"
  static let defaultValueB = "CE00C43D881120"
  static let defaultValueC = "D8005AC2A8F0"
  static let defaultValueD = "F600BC2D8F"
  static let defaultValueE = "9C005AC2F8F0"
  static let defaultValueF = "9C0141080250320F1802104A08"

  struct Packet {
    enum PacketType {
      case Data
      case Operator(id: Int)

      var name: String {
        switch self {
        case .Data:
          return "data"
        case .Operator(let id):
          return ["sum", "product", "minimum", "maximum", "", "greater than", "less than", "equal to"][id]
        }
      }

      private var requiresExactly2SubPackets: Bool {
        switch self {
        case .Data:
          return false
        case .Operator(let id):
          return id >= 5
        }
      }

      func operatorValue(for subPackets: [Packet]) -> Int {
        guard case .Operator(let id) = self else {
          fatalError("OperatorValue called on data packet type.")
        }
        guard !subPackets.isEmpty else {
          print("Empty sub-packets?")
          return 0
        }

        let values = subPackets.map({ $0.value })

        if requiresExactly2SubPackets && subPackets.count != 2 {
          fatalError("\(name) operator does not have exactly 2 packets.")
        }

        switch id {
        case 0:
          return values.sum()
        case 1:
          return values.reduce(1, { $0 * $1 })
        case 2:
          return values.min()!
        case 3:
          return values.max()!
        case 5:
          return (values[0] > values[1]) ? 1 : 0
        case 6:
          return (values[0] < values[1]) ? 1 : 0
        case 7:
          return (values[0] == values[1]) ? 1 : 0
        default:
          fatalError("Unknown operator id: \(id)")
        }
      }
    }

    let version: Int
    let type: PacketType
    let subPackets: [Packet]
    let value: Int

    private let contents: String

    private var dataCount: Int {
      // 6 for the header info.
      // Don't include any subPacket dataCounts directly because the subPackets data is included in the contents.
      return contents.count + 6
    }

    private init(version: Int, contents: String) {
      self.version = version
      self.type = .Data

      var i = 0
      var valueString = ""
      // i Should never reach this point, but fail-safe.
      while i < contents.count {
        let isLastPacket = contents[unsafe: i] == "0"
        valueString.append(contents[unsafe: i+1..<i+5])
        i += 5

        // Last packet, bail.
        if isLastPacket {
          break
        }
      }

      self.contents = contents[unsafe: 0..<i]
      self.value = Int(valueString, radix: 2)!
      self.subPackets = []
    }

    private init(version: Int, operatorID: Int, contents: String) {
      self.version = version
      self.type = .Operator(id: operatorID)

      let lengthCountBitCount: Int
      let usePacketCount = (contents.first == "1")
      if usePacketCount {
        lengthCountBitCount = 11
      } else {
        lengthCountBitCount = 15
      }

      let finishedCount = Int(contents[unsafe: 1..<(lengthCountBitCount+1)], radix: 2)!

      func shouldContinue(packetCount: Int, bits: Int) -> Bool {
        if usePacketCount {
          return packetCount < finishedCount
        } else {
          return bits < finishedCount
        }
      }

      let subPacketBinary = contents[unsafe: (lengthCountBitCount+1)..<contents.count]
      var subPackets = [Packet]()
      var bitsUsed = 0
      while shouldContinue(packetCount: subPackets.count, bits: bitsUsed) {
        // Provide all of the unused bits to the Packet, which will use the right amount.
        let packet = Packet(binaryCode: subPacketBinary[unsafe: bitsUsed..<subPacketBinary.count])
        subPackets.append(packet)
        bitsUsed += packet.dataCount
      }

      self.contents = contents[unsafe: 0..<(lengthCountBitCount+1+bitsUsed)]

      self.subPackets = subPackets
      self.value = type.operatorValue(for: subPackets)
    }

    private init(binaryCode binary: String) {
      let version = Int(binary[unsafe: 0..<3], radix: 2)!

      let typeID = Int(binary[unsafe: 3..<6], radix: 2)!
      let contents = binary[unsafe: 6..<binary.count]

      if typeID == 4 {
        self.init(version: version, contents: contents)
      } else {
        self.init(version: version, operatorID: typeID, contents: contents)
      }
    }

    init(packetCode: String) {
      self.init(binaryCode: packetCode.toBinary()!)
    }

    var versionSum: Int {
      return version + subPackets.map({ $0.versionSum }).sum()
    }
  }

  static func solution(number challengeNumber: ChallengeNumber, for input: String) -> String {
    let packet = Packet(packetCode: inputComponent(from: input))
    switch challengeNumber {
    case .one:
      return getAnswer1(given: packet)
    case .two:
      return getAnswer2(given: packet)
    }
  }

  static private func getAnswer1(given packet: Packet) -> String {
    return "\(packet.versionSum)"
  }

  static private func getAnswer2(given packet: Packet) -> String {
    return "\(packet.value)"
  }
}
