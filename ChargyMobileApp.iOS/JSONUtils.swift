//
//  JSONUtils.swift
//  ChargyMobileApp.iOS
//
//  Common JSON parsing helpers.
//

import Foundation

public typealias JSON = [String: Any]

public final class JSONUtils
{

  /// Produces a canonical “signable” JSON blob by stripping out `signatures` and
  /// emitting the leanest serialization (no pretty-print, no sorted-keys).
  public static func canonicalJSONForSignature(from json: Data) -> Data? {
      guard var jsonObj = (try? JSONSerialization.jsonObject(with: json, options: []))
                        as? [String: Any] else {
          return nil
      }
      jsonObj.removeValue(forKey: "signatures")
      return try? JSONSerialization.data(withJSONObject: jsonObj, options: .sortedKeys)
  }

}

extension JSON
{

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
        guard let rawAny = self[key] else {
            errorResponse = "Missing '\(key)' field!"
            return false
        }
        guard let v = rawAny as? String else {
            errorResponse = "Invalid '\(key)' field: expected String"
            return false
        }
        value = v
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
        guard let rawAny = self[key] else {
            errorResponse = "Missing '\(key)' I18NString field!"
            return false
        }
        guard let dict = rawAny as? [String: String] else {
            errorResponse = "Invalid '\(key)' I18NString field: expected object of string values"
            return false
        }
        value = I18NString(values: dict)
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
        _ key:               String,
        value:         inout Date?,
        errorResponse: inout String?
    ) -> Bool {
        guard let rawAny = self[key] else {
            errorResponse = "Missing '\(key)' Date field!"
            return false
        }
        guard let raw = rawAny as? String else {
            errorResponse = "Invalid '\(key)' Date field: expected String"
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
        _ key:               String,
        value:         inout Date?,
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
    
    
    /// Attempts to extract a non-optional Double for the given key from this dictionary.
    /// - Parameters:
    ///   - key: The JSON key to look up.
    ///   - value: An inout Double? into which the extracted value is written on success.
    ///   - errorResponse: An inout String? into which an error message is written on failure.
    /// - Returns: True if the key exists and is a Double; false otherwise.
    func parseMandatoryDouble(
        _ key: String,
        value: inout Double?,
        errorResponse: inout String?
    ) -> Bool {
        // Check presence of the key
        guard let rawAny = self[key] else {
            errorResponse = "Missing '\(key)' Double field!"
            return false
        }
        // Check type of the value
        guard let num = rawAny as? Double else {
            errorResponse = "Invalid '\(key)' field: expected Double"
            return false
        }
        value = num
        errorResponse = nil
        return true
    }

    /// Attempts to extract an optional Double for the given key from this dictionary.
    /// - Parameters:
    ///   - key: The JSON key to look up.
    ///   - value: An inout Double? into which the extracted value is written on success.
    ///   - errorResponse: An inout String? into which an error message is written on failure.
    /// - Returns: False if the key is absent; true if the key exists but the Double is invalid.
    func parseOptionalDouble(
        _ key:               String,
        value:         inout Double?,
        errorResponse: inout String?
    ) -> Bool {
        guard let rawAny = self[key] else {
            return false
        }
        guard let num = rawAny as? Double else {
            errorResponse = "Invalid '\(key)' field: expected Double"
            return true
        }
        value = num
        errorResponse = nil
        return true
    }

    /// Parses a JSON array under `key` into a typed array using the provided parser.
    /// - Parameters:
    ///   - key: The JSON key whose value should be an array of objects.
    ///   - result: An inout array to receive the parsed elements.
    ///   - errorResponse: An inout String? to receive an error message on failure.
    ///   - parser: A function that takes a JSON object, an inout T?, and an inout String?, returning true on successful parse.
    /// - Returns: True if the array exists and all elements parse successfully; false otherwise.
    func parseMandatoryArray<T>(
        _    key:            String,
        into result:   inout [T],
        errorResponse: inout String?,
        using parser: (_ json: JSON, _ element: inout T?, _ errorResponse: inout String?) -> Bool
    ) -> Bool {
        // Ensure the key maps to an array
        guard let rawArray = self[key] as? [Any] else {
            errorResponse = "Missing array for key '\(key)'"
            return false
        }
        var parsedArray: [T] = []
        for (index, item) in rawArray.enumerated() {
            guard let dict = item as? JSON else {
                errorResponse = "Invalid JSON object at array index \(index)"
                return false
            }
            var parsedElement: T?
            var elementError: String?
            guard parser(dict, &parsedElement, &elementError) else {
                errorResponse = "Error parsing element at index \(index): \(elementError ?? "unknown error")"
                return false
            }
            if let element = parsedElement {
                parsedArray.append(element)
            }
        }
        result = parsedArray
        errorResponse = nil
        return true
    }

    /// Parses an optional JSON array under `key` into a typed array using the provided parser.
    /// - Parameters:
    ///   - key: The JSON key whose value may be an array of objects.
    ///   - result: An inout array to receive the parsed elements (empty if key is missing).
    ///   - errorResponse: An inout String? to receive an error message on failure.
    ///   - parser: A function that takes a JSON object, an inout T?, and an inout String?, returning true on successful parse.
    /// - Returns: True if the key is absent or all elements parse successfully; false otherwise.
    func parseOptionalArray<T>(
        _ key: String,
        into result: inout [T]?,
        errorResponse: inout String?,
        using parser: (_ json: JSON, _ element: inout T?, _ errorResponse: inout String?) -> Bool
    ) -> Bool {
        // If key is missing, treat as empty array
        guard let rawAny = self[key] else {
            result = []
            errorResponse = nil
            return true
        }
        // Ensure the value is an array
        guard let rawArray = rawAny as? [Any] else {
            errorResponse = "Invalid array for key '\(key)'"
            return false
        }
        var parsedArray: [T] = []
        for (index, item) in rawArray.enumerated() {
            guard let dict = item as? JSON else {
                errorResponse = "Invalid JSON object at array index \(index)"
                return false
            }
            var parsedElement: T?
            var elementError: String?
            guard parser(dict, &parsedElement, &elementError) else {
                errorResponse = "Error parsing element at index \(index): \(elementError ?? "unknown error")"
                return false
            }
            if let element = parsedElement {
                parsedArray.append(element)
            }
        }
        result = parsedArray
        errorResponse = nil
        return true
    }

    
    /// Attempts to parse an optional JSON object under `key` using the provided parser.
    /// - Parameters:
    ///   - key: The JSON key whose value may be a nested object.
    ///   - value: An inout T? to receive the parsed result if the key exists.
    ///   - errorResponse: An inout String? to receive an error message on failure.
    ///   - parser: A function that takes the nested JSON, an inout T?, and an inout String?, returning true on successful parse.
    /// - Returns: False if the key is missing; false (with errorResponse) if the value is not an object; otherwise the parser’s return value.
    func parseOptionalJSON<T>(
        _ key: String,
        value: inout T?,
        errorResponse: inout String?,
        using parser: (_ json: JSON, _ element: inout T?, _ errorResponse: inout String?) -> Bool
    ) -> Bool {
        // If key is missing, nothing to parse
        guard let rawAny = self[key] else {
            return false
        }
        // Must be a JSON dictionary
        guard let dict = rawAny as? JSON else {
            errorResponse = "Invalid JSON object for key '\(key)'"
            return false
        }
        // Delegate parsing to the provided parser
        return parser(dict, &value, &errorResponse)
    }
}
