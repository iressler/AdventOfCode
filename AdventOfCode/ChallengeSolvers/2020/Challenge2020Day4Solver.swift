//
//  Challenge2020Day4Solver.swift
//  AdventOfCode
//
//  Created by Isaac Ressler on 12/6/21.
//

import Foundation

struct Challenge2020Day4Solver: ChallengeSolver {
  struct Passport: CustomStringConvertible {
    enum Field: String, CaseIterable {
      private enum HairColor: String {
        case amb
        case blu
        case brn
        case gry
        case grn
        case hzl
        case oth
      }
      case byr //(Birth Year)
      case iyr //(Issue Year)
      case eyr //(Expiration Year)
      case hgt //(Height)
      case hcl //(Hair Color)
      case ecl //(Eye Color)
      case pid //(Passport ID)
      case cid //(Country ID)

      private func isYear(_ yearString: String, in range: ClosedRange<Int>) -> Bool {
        if let year = Int(yearString), range.contains(year) {
          return true
        } else {
          return false
        }
      }

      private static let hairColorRegex: NSRegularExpression = {
        return try! NSRegularExpression(pattern: "^#[a-z0-9]{6}$", options: [])
      }()

      func valueIsValid(_ value: String) -> Bool {
        switch self {
        case .byr:
          return isYear(value, in: 1920...2002)
        case .iyr:
          return isYear(value, in: 2010...2020)
        case .eyr:
          return isYear(value, in: 2020...2030)
        case .hgt:
          guard let height = Int(value.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) else {
            return false
          }
          let range: ClosedRange<Int>
          if value.hasSuffix("cm") {
            range = 150...193
          } else if value.hasSuffix("in") {
            range = 59...76
          } else {
            return false
          }
          return range.contains(height)
        case .hcl:
          return Self.hairColorRegex.numberOfMatches(in: value, options: [], range: NSMakeRange(0, value.count)) == 1
        case .ecl:
          return HairColor(rawValue: value) != nil
        case .pid:
          return value.count == 9 && Int(value) != nil
        case .cid:
          return true
        }
      }
    }

    let fields: [Field: String]

    init(fields: [Field: String]) {
      self.fields = fields
    }

    init?(fields: [String: String]) {
      var convertedFields = [Field: String]()

      for (key, value) in fields {
        guard let field = Field(rawValue: key) else {
          return nil
        }
        convertedFields[field] = value
      }
      self.init(fields: convertedFields)
    }

    func isValid(validateFields: Bool = false) -> Bool {
//      printDivider()
      var allFields = Field.allCases
      allFields.removeAll(where: { $0 == .cid })

      for (field, value) in fields {
//        print("Validating \(field.rawValue) with \(value)")
        if !validateFields || field.valueIsValid(value) {
          allFields.removeAll(where: { $0 == field })
//          print("valid")
//        } else {
//          print("invalid")
        }
      }

      return allFields.isEmpty
    }

    var description: String {
      return "\nPassport<\n\t\(fields.map({ "\($0): \($1)" }).joined(separator: "\n\t"))\n>"
    }
  }

  static let defaultValue = """
ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
byr:1937 iyr:2017 cid:147 hgt:183cm

iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
hcl:#cfa07d byr:1929

hcl:#ae17e1 iyr:2013
eyr:2024
ecl:brn pid:760753108 byr:1931
hgt:179cm

hcl:#cfa07d eyr:2025 pid:166559648
iyr:2011 ecl:brn hgt:59in
"""

  static let invalidPassportValues = """
eyr:1972 cid:100
hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926

iyr:2019
hcl:#602927 eyr:1967 hgt:170cm
ecl:grn pid:012533040 byr:1946

hcl:dab227 iyr:2012
ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277

hgt:59cm ecl:zzz
eyr:2038 hcl:74454a iyr:2023
pid:3556412378 byr:2007
"""

  static let validPassportValues = """
pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
hcl:#623a2f

eyr:2029 ecl:blu cid:129 byr:1989
iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm

hcl:#888785
hgt:164cm byr:2001 iyr:2015 cid:88
pid:545766238 ecl:hzl
eyr:2022

iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719
"""

  static func solution(number challengeNumber: ChallengeNumber, for input: String) -> String {
    let chosenInput: String
    if input == "valid" {
      print("Using valid test passports")
      chosenInput = validPassportValues
    } else if input == "invalid" {
      print("Using invalid test passports")
      chosenInput = invalidPassportValues
    } else {
      chosenInput = input
    }
    let lines = components(from: chosenInput, separators: .whitespacesAndNewlines, dropEmpty: false)

    var passports = [Passport]()

//    print("Converting to passports: \(lines)")
    var passportFields = [String: String]()
    for line in lines {
      if line.isEmpty {
        passports.append(Passport(fields: passportFields)!)
        passportFields.removeAll()
      } else {
        let components = components(from: line, separators: .whitespaces.union(CharacterSet(charactersIn: ":")), dropEmpty: true)
        for i in stride(from: 0, to: components.count, by: 2) {
          passportFields[components[i]] = components[i+1]
        }
      }
    }

    switch challengeNumber {
    case .one:
      return getAnswer1(given: passports)
    case .two:
      return getAnswer2(given: passports)
    }
  }

  static private func getAnswer1(given passports: [Passport]) -> String {
//    print("Testing \(passports.count) passports.")
    return "\(passports.filter({ $0.isValid() }).count)"
  }

  static private func getAnswer2(given passports: [Passport]) -> String {
    return "\(passports.filter({ $0.isValid(validateFields: true) }).count)"
  }
}
