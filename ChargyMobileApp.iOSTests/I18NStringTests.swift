//
//  I18NStringTests.swift
//  ChargyMobileApp.iOSTests
//
//  Created by Achim Friedland on 08.07.25.
//

import Foundation
import Testing

@testable import ChargyMobileApp_iOS

struct I18NStringTests {

    @Test func Init_Test01() async throws {
        
        let i18n = I18NString(values: ["en": "Hello world!", "de": "Hallo Welt!"])

        #expect(i18n["en"] == "Hello world!")
        #expect(i18n["de"] == "Hallo Welt!")
        #expect(i18n["fr"] == nil)

    }

    @Test func Deserializer_Test01() async throws {
        
        let json = """
        {
            "en": "Hello world!",
            "de": "Hallo Welt!"
        }
        """.data(using: .utf8)!

        let i18n = try JSONDecoder().decode(I18NString.self, from: json)

        #expect(i18n["en"] == "Hello world!")
        #expect(i18n["de"] == "Hallo Welt!")
        #expect(i18n["fr"] == nil)

    }
    
    @Test func Deserializer_Test02() async throws {
        
        let json = "{}".data(using: .utf8)!
        let i18n = try JSONDecoder().decode(I18NString.self, from: json)

        #expect(i18n["en"] == nil)

    }

    @Test func Serializer_Test01() async throws {
        
        var i18n = I18NString()
            i18n.add("en", "Hello world!")
            i18n.add("de", "Hallo Welt!")

        let jsonData   = try JSONEncoder().encode(i18n)
        let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: String]

        #expect(jsonObject?["en"] == "Hello world!")
        #expect(jsonObject?["de"] == "Hallo Welt!")
        #expect(jsonObject?["fr"] == nil)
        
    }
    
    @Test func Serializer_Test02() async throws {
        
        var i18n = I18NString()
            i18n["en"] = "Hello world!"
            i18n["de"] = "Hallo Welt!"

        let jsonData   = try JSONEncoder().encode(i18n)
        let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: String]

        #expect(jsonObject?["en"] == "Hello world!")
        #expect(jsonObject?["de"] == "Hallo Welt!")
        #expect(jsonObject?["fr"] == nil)
        
    }
    
    @Test func Serializer_Test03() async throws {
        
        let i18n        = I18NString()
        let jsonData    = try JSONEncoder().encode(i18n)

        let jsonString  = String(data: jsonData, encoding: .utf8)
        
        #expect(jsonString == "{}")
        
    }
    
    @Test func Remove_Test01() async throws {
        
        var i18n = I18NString()
            i18n["en"] = "Hello world!"
            i18n["de"] = "Hallo Welt!"
        
        i18n.remove("de")

        let jsonData   = try JSONEncoder().encode(i18n)
        let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: String]

        #expect(jsonObject?["en"] == "Hello world!")
        #expect(jsonObject?["de"] == nil)
        #expect(jsonObject?["fr"] == nil)
        
    }
    
}
