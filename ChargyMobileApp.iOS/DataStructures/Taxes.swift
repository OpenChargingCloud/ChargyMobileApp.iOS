//
//  Taxes.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 10.07.25.
//

import Foundation

class Taxes: Identifiable, JSONSerializable {
    
    var id:            String
    var context:       String?
    var description:   I18NString?
    var percentage:    Decimal

    init(
        id: String,
        context: String? = nil,
        description: I18NString? = nil,
        percentage: Decimal
    ) {
        self.id          = id
        self.context     = context
        self.description = description
        self.percentage  = percentage
    }

    func toJSON() -> [String: Any] {
        var dict: [String: Any] = [
            "id": id,
            "percentage": NSDecimalNumber(decimal: percentage)
        ]
        if let context = context {
            dict["context"] = context
        }
        if let description = description {
            dict["description"] = description.toJSON()
        }
        return dict
    }

    static func parse(
        from data: JSON,
        value: inout Taxes?,
        errorResponse: inout String?
    ) -> Bool {
        // id (mandatory)
        var idValue: String?
        guard data.parseMandatoryString("id", value: &idValue, errorResponse: &errorResponse),
              let id = idValue else {
            return false
        }
        // context (optional)
        let contextValue = data["context"] as? String
        // description (optional I18NString)
        var descValue: I18NString?
        guard data.parseOptionalI18NString("description", value: &descValue, errorResponse: &errorResponse) else {
            return false
        }
        // percentage (mandatory Double -> Decimal)
        var percDouble: Double?
        guard data.parseMandatoryDouble("percentage", value: &percDouble, errorResponse: &errorResponse),
              let pd = percDouble else {
            return false
        }
        let percentageValue = Decimal(pd)
        // instantiate
        value = Taxes(
            id: id,
            context: contextValue,
            description: descValue,
            percentage: percentageValue
        )
        errorResponse = nil
        return true
    }

}
