//
//  JSONValue.swift
//  Core
//
//  Created by Chris Nevin on 18/5/2025.
//

import CasePaths
import Foundation

/// Decode any JSON value to be type-safe and Sendable.
@CasePathable
public enum JSONValue: Decodable, CustomStringConvertible, Sendable {
    case string(String)
    case integer(Int)
    case boolean(Bool)
    case double(Double)
    case date(Date)
    case array([JSONValue])
    case dictionary([String: JSONValue])
    case null

    public var description: String {
        switch self {
        case .null:
            return "null"
        case .string(let value):
            return value.isEmpty ? "\"\"" : "\"\(value)\""
        case .integer(let value):
            return String(value)
        case .boolean(let value):
            return String(value)
        case .double(let value):
            return String(value)
        case let .date(value):
            return value.description
        case let .array(values):
            return "[" + values.map(\.description).joined(separator: ", ") + "]"
        case let .dictionary(keyValues):
            var descriptions: [String] = []
            for (key, value) in keyValues {
                descriptions.append("\"\(key)\": \(value.description)")
            }
            return "[\(descriptions.joined(separator: ", "))]"
        }
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let boolean = try? container.decode(Bool.self) {
            self = .boolean(boolean)
        } else if let integer = try? container.decode(Int.self) {
            self = .integer(integer)
        } else if let double = try? container.decode(Double.self) {
            self = .double(double)
        } else if let date = try? container.decode(Date.self) {
            self = .date(date)
        } else if let string = try? container.decode(String.self) {
            self = .string(string)
        } else if let array = try? container.decode([JSONValue].self) {
            self = .array(array)
        } else if let dictionary = try? container.decode([String: JSONValue].self) {
            self = .dictionary(dictionary)
        } else if container.decodeNil() {
            self = .null
        } else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Unsupported JSON value"
                )
            )
        }
    }
}
