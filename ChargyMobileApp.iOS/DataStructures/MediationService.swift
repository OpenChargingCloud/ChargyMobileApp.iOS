//
//  MediationService.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 09.07.25.
//


import Foundation

class MediationService: Identifiable, JSONSerializable {
    
    var id:            String
    var context:       String?
    var description:   I18NString?
    var publicKeys:    [PublicKey]  = []

    init(
        id: String,
        context: String? = nil,
        description: I18NString? = nil,
        publicKeys: [PublicKey] = []
    ) {
        self.id          = id
        self.context     = context
        self.description = description
        self.publicKeys  = publicKeys
    }

    func toJSON() -> [String: Any] {
        var dict: [String: Any] = ["id": id]
        if let context = context {
            dict["context"] = context
        }
        if let description = description {
            dict["description"] = description.toJSON()
        }
        if !publicKeys.isEmpty {
            dict["publicKeys"] = publicKeys.map { $0.toJSON() }
        }
        return dict
    }

    static func parse(
        from data: [String: Any],
        value: inout MediationService?,
        errorResponse: inout String?
    ) -> Bool {
        // id (mandatory)
        var idValue: String?
        guard data.parseMandatoryString("id", value: &idValue, errorResponse: &errorResponse),
              let id = idValue else {
            return false
        }
        // context (optional)
        var contextValue: String?
        _ = data.parseOptionalString("context", value: &contextValue, errorResponse: &errorResponse)
        // description (optional I18NString)
        var descValue: I18NString?
        guard data.parseOptionalI18NString("description", value: &descValue, errorResponse: &errorResponse) else {
            return false
        }
        // publicKeys (optional array)
        var keys: [PublicKey]? = []
        guard data.parseOptionalArray(
            "publicKeys",
            into: &keys,
            errorResponse: &errorResponse,
            using: { dict, key, err in
                PublicKey.parse(from: dict, value: &key, errorResponse: &err)
            }
        ) else {
            return false
        }
        // Instantiate
        value = MediationService(
            id: id,
            context: contextValue,
            description: descValue,
            publicKeys: keys ?? []
        )
        errorResponse = nil
        return true
    }
}
