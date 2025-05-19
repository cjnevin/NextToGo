//
//  JSONValueTests.swift
//  Core
//
//  Created by Chris Nevin on 18/5/2025.
//

import CasePaths
@testable import Core
import Foundation
import Testing

@Suite("JSONValue decoding tests")
struct JSONValueTests {
    let decoder = JSONDecoder()

    @Test
    func stringDecoding() throws {
        // GIVEN
        let data = Data("\"Hello World\"".utf8)
        // WHEN
        let string = try decoder.decode(JSONValue.self, from: data)[case: \.string]
        // THEN
        #expect(string == "Hello World")
    }

    @Test
    func integerDecoding() throws {
        // GIVEN
        let data = Data("100".utf8)
        // WHEN
        let int = try decoder.decode(JSONValue.self, from: data)[case: \.integer]
        // THEN
        #expect(int == 100)
    }

    @Test
    func booleanDecoding() throws {
        // GIVEN
        let data = Data("true".utf8)
        // WHEN
        let boolean = try decoder.decode(JSONValue.self, from: data)[case: \.boolean]
        // THEN
        #expect(boolean == true)
    }

    @Test
    func doubleDecoding() throws {
        // GIVEN
        let data = Data("100.20".utf8)
        // WHEN
        let double = try decoder.decode(JSONValue.self, from: data)[case: \.double]
        // THEN
        #expect(double == 100.2)
    }

    @Test
    func dateDecoding() throws {
        // GIVEN
        decoder.dateDecodingStrategy = .iso8601
        let data = Data("\"2025-05-18T13:33:00Z\"".utf8)
        // WHEN
        let date = try decoder.decode(JSONValue.self, from: data)[case: \.date]
        // THEN
        #expect(date?.timeIntervalSinceReferenceDate == 769267980)
    }

    @Test
    func arrayDecoding() throws {
        // GIVEN
        let data = Data("[1, 2, 3]".utf8)
        // WHEN
        let array = try decoder.decode([JSONValue].self, from: data)
        // THEN
        #expect(array[0][case: \.integer] == 1)
        #expect(array[1][case: \.integer] == 2)
        #expect(array[2][case: \.integer] == 3)
    }

    @Test
    func dictionaryDecoding() throws {
        // GIVEN
        let data = Data("{\"key\": \"value\"}".utf8)
        // WHEN
        let dictionary = try decoder.decode([String: JSONValue].self, from: data)
        let value = dictionary["key"]![case: \.string]
        // THEN
        #expect(value == "value")
    }

    @Test
    func nullDecoding() throws {
        // GIVEN
        let data = Data("null".utf8)
        // WHEN
        let value: Void? = try decoder.decode(JSONValue.self, from: data)[case: \.null]
        // THEN
        #expect(value.unsafelyUnwrapped == ())
    }
}
