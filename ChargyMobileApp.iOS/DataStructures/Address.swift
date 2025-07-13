//
//  Address.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 08.07.25.
//

import Foundation

class Address {
    
    var city:          String
    var postalCode:    String
    var country:       String // Code?
    var Street:        String?
    var houseNumber:   String?
    var floorLevel:    String?
    var comment:       I18NString?
    var context:       String?

    init(
        city: String,
        postalCode: String,
        country: String,
        street: String? = nil,
        houseNumber: String? = nil,
        floorLevel: String? = nil,
        comment: I18NString? = nil,
        context: String? = nil
    ) {
        self.city        = city
        self.postalCode  = postalCode
        self.country     = country
        self.Street      = street
        self.houseNumber = houseNumber
        self.floorLevel  = floorLevel
        self.comment     = comment
        self.context     = context
    }


    static func parse(
        from data:      [String: Any],
        value:          inout Address?,
        errorResponse:  inout String?
    ) -> Bool {

        var city: String?
        guard data.parseMandatoryString("city", value: &city, errorResponse: &errorResponse) else {
            return false
        }

        var postalCode: String?
        guard data.parseMandatoryString("postalCode", value: &postalCode, errorResponse: &errorResponse) else {
            return false
        }

        var country: String?
        guard data.parseMandatoryString("country", value: &country, errorResponse: &errorResponse) else {
            return false
        }
        
        let street      = data["street"]      as? String
        let houseNumber = data["houseNumber"] as? String
        let floorLevel  = data["floorLevel"]  as? String
        let context     = data["@context"]    as? String

        var commentValue: I18NString?
        if data.parseOptionalI18NString("comment", value: &commentValue, errorResponse: &errorResponse) {
            if (errorResponse != nil)
            {
                return false
            }
        }

        value = Address(
            city: city!,
            postalCode: postalCode!,
            country: country!,
            street: street,
            houseNumber: houseNumber,
            floorLevel: floorLevel,
            comment: commentValue,
            context: context
        )
        
        errorResponse = nil
        return true
        
    }
    
    func toJSON() -> [String: Any] {
        
        var json: [String: Any] = [
            "city": city,
            "postalCode": postalCode,
            "country": country
        ]
        if let street = Street {
            json["street"] = street
        }
        if let houseNumber = houseNumber {
            json["houseNumber"] = houseNumber
        }
        if let floorLevel = floorLevel {
            json["floorLevel"] = floorLevel
        }
        if let comment = comment {
            json["comment"] = comment.toJSON()
        }
        if let context = context {
            json["@context"] = context
        }
        
        return json
        
    }

}
