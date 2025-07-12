//
//  Address.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 08.07.25.
//

import Foundation

class Address {
    
    var context:       String
    var city:          String
    var Street:        String?
    var houseNumber:   String?
    var floorLevel:    String?
    var postalCode:    String?
    var country:       String? // Code?
    var comment:       I18NString?
    

    init(
        context: String,
        city: String,
        street: String? = nil,
        houseNumber: String? = nil,
        floorLevel: String? = nil,
        postalCode: String? = nil,
        country: String? = nil,
        comment: I18NString? = nil
    ) {
        self.context     = context
        self.city        = city
        self.Street      = street
        self.houseNumber = houseNumber
        self.floorLevel  = floorLevel
        self.postalCode  = postalCode
        self.country     = country
        self.comment     = comment
    }


    static func parse(
        from data: [String: Any],
        value: inout Address?,
        errorResponse: inout String?
    ) -> Bool {
        // context (mandatory)
        var ctx: String?
        guard data.parseMandatoryString("context", value: &ctx, errorResponse: &errorResponse),
              let context = ctx else {
            return false
        }
        // city (mandatory)
        var cty: String?
        guard data.parseMandatoryString("city", value: &cty, errorResponse: &errorResponse),
              let city = cty else {
            return false
        }
        // optional fields
        let street      = data["street"]      as? String
        let houseNumber = data["houseNumber"] as? String
        let floorLevel  = data["floorLevel"]  as? String
        let postalCode  = data["postalCode"]  as? String
        let country     = data["country"]     as? String
        // comment (optional I18NString)
        var commentValue: I18NString?
        guard data.parseOptionalI18NString("comment", value: &commentValue, errorResponse: &errorResponse) else {
            return false
        }
        // initialize
        value = Address(
            context: context,
            city: city,
            street: street,
            houseNumber: houseNumber,
            floorLevel: floorLevel,
            postalCode: postalCode,
            country: country,
            comment: commentValue
        )
        errorResponse = nil
        return true
    }
    
    func toJSON() -> [String: Any] {
        var dict: [String: Any] = [
            "context": context,
            "city": city
        ]
        if let street = Street {
            dict["street"] = street
        }
        if let houseNumber = houseNumber {
            dict["houseNumber"] = houseNumber
        }
        if let floorLevel = floorLevel {
            dict["floorLevel"] = floorLevel
        }
        if let postalCode = postalCode {
            dict["postalCode"] = postalCode
        }
        if let country = country {
            dict["country"] = country
        }
        if let comment = comment {
            dict["comment"] = comment.toJSON()
        }
        return dict
    }

}
