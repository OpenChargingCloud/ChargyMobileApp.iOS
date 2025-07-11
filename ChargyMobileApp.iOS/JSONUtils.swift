//
//  JSONUtils.swift
//  ChargyMobileApp.iOS
//
//  Common JSON parsing helpers.
//

import Foundation
//
//enum JSONUtils {
//
//    /// Attempts to extract a non-optional String for the given key.
//    /// - Parameters:
//    ///   - key: The JSON key to look up.
//    ///   - data: The JSON dictionary.
//    ///   - value: An inout String? into which the extracted value is written on success.
//    ///   - errorResponse: An inout String? into which an error message is written on failure.
//    /// - Returns: True if the key exists and is a String; false otherwise.
//    static func parseMandatoryString(
//        _    key:            String,
//        from data:           [String: Any],
//        value:         inout String?,
//        errorResponse: inout String?
//    ) -> Bool {
//
//        guard let v = data[key] as? String else {
//            errorResponse = "Missing or invalid '\(key)' field!"
//            return false
//        }
//
//        value         = v
//        errorResponse = nil
//
//        return true
//
//    }
//
//
//
//
extension Dictionary where Key == String, Value == Any {

    
    /// Attempts to extract a non-optional String for the given key from this dictionary.
    /// - Parameters:
    ///   - key: The JSON key to look up.
    ///   - value: An inout String? into which the extracted value is written on success.
    ///   - errorResponse: An inout String? into which an error message is written on failure.
    /// - Returns: True if the key exists and is a String; false otherwise.
    func parseMandatoryString(
        _ key:               String,
        value:         inout String?,
        errorResponse: inout String?
    ) -> Bool {
        guard let v = self[key] as? String else {
            errorResponse = "Missing or invalid '\(key)' field!"
            return false
        }
        value         = v
        errorResponse = nil
        return true
    }
    
    /// Attempts to extract a String for the given key from this dictionary.
    /// - Parameters:
    ///   - key: The JSON key to look up.
    ///   - value: An inout String? into which the extracted value is written on success.
    ///   - errorResponse: An inout String? into which an error message is written on failure.
    /// - Returns: False if the key is absent; true if the key exists but the String is invalid.
    func parseOptionalString(
        _ key:               String,
        value:         inout String?,
        errorResponse: inout String?
    ) -> Bool {
        guard let raw = self[key] else {
            return false
        }
        guard let v = raw as? String else {
            errorResponse = "Invalid '\(key)' field!"
            return true
        }
        value         = v
        errorResponse = nil
        return true
    }
    
    /// Attempts to extract an I18NString for the given key from this dictionary.
    /// - Parameters:
    ///   - key: The JSON key to look up.
    ///   - value: An inout I18NString? into which the extracted value is written on success.
    ///   - errorResponse: An inout String? into which an error message is written on failure.
    /// - Returns: True if the key exists and can be converted to I18NString; false otherwise.
    func parseMandatoryI18NString(
        _ key:               String,
        value:         inout I18NString?,
        errorResponse: inout String?
    ) -> Bool {
        guard let dict = self[key] as? [String: String] else {
            errorResponse = "Missing or invalid '\(key)' I18NString field!"
            return false
        }
        value         = I18NString(values: dict)
        errorResponse = nil
        return true
    }
    
    /// Attempts to extract an I18NString for the given key from this dictionary.
    /// - Parameters:
    ///   - key: The JSON key to look up.
    ///   - value: An inout I18NString? into which the extracted value is written on success.
    ///   - errorResponse: An inout String? into which an error message is written on failure.
    /// - Returns: False if the key is absent; true if the key exists but the I18NString is invalid.
    func parseOptionalI18NString(
        _ key:               String,
        value:         inout I18NString?,
        errorResponse: inout String?
    ) -> Bool {
        guard let raw = self[key] else {
            return false
        }
        // Key exists: attempt to parse
        guard let dict = raw as? [String: String] else {
            errorResponse = "Invalid '\(key)' I18NString field!"
            return true
        }
        value = I18NString(values: dict)
        errorResponse = nil
        return true
    }

    /// Attempts to extract a Date for the given key in ISO8601 format from this dictionary.
    /// - Parameters:
    ///   - key: The JSON key to look up.
    ///   - value: An inout Date? into which the extracted date is written on success.
    ///   - errorResponse: An inout String? into which an error message is written on failure.
    /// - Returns: True if the key exists and a valid ISO8601 date string; false otherwise.
    func parseMandatoryDate(
        _ key: String,
        value: inout Date?,
        errorResponse: inout String?
    ) -> Bool {
        guard let raw = self[key] as? String else {
            errorResponse = "Missing or invalid '\(key)' Date field!"
            return false
        }
        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: raw) else {
            errorResponse = "Invalid date format for '\(key)' field!"
            return false
        }
        value = date
        errorResponse = nil
        return true
    }

    /// Attempts to extract an optional Date for the given key in ISO8601 format from this dictionary.
    /// - Parameters:
    ///   - key: The JSON key to look up.
    ///   - value: An inout Date? into which the extracted date is written on success.
    ///   - errorResponse: An inout String? into which an error message is written on failure.
    /// - Returns: False if the key is absent; true if the key exists but the date is invalid.
    func parseOptionalDate(
        _ key: String,
        value: inout Date?,
        errorResponse: inout String?
    ) -> Bool {
        guard let rawAny = self[key] else {
            return false
        }
        guard let raw = rawAny as? String else {
            errorResponse = "Invalid '\(key)' Date field!"
            return true
        }
        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: raw) else {
            errorResponse = "Invalid date format for '\(key)' field!"
            return true
        }
        value = date
        errorResponse = nil
        return true
    }
    
    
}
