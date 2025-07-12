//
//  Manufacturer.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 08.07.25.
//

import Foundation

class Manufacturer: JSONSerializable {

    var context:          String?
    var name:             String
    var description:      I18NString?
    var contact:          Contact?
    var support:          Support?
    var privacyContact:   PrivacyContact?
    var geoLocation:      GeoLocation?
    var publicKeys:       [PublicKey]?

    init(
        name: String,
        context: String? = nil,
        description: I18NString? = nil,
        contact: Contact? = nil,
        support: Support? = nil,
        privacyContact: PrivacyContact? = nil,
        geoLocation: GeoLocation? = nil,
        publicKeys: [PublicKey]? = nil
    ) {
        self.name            = name
        self.context         = context
        self.description     = description
        self.contact         = contact
        self.support         = support
        self.privacyContact  = privacyContact
        self.geoLocation     = geoLocation
        self.publicKeys      = publicKeys
    }
    

    func toJSON() -> [String: Any] {
        var dict: [String: Any] = ["name": name]
        if let context = context {
            dict["context"] = context
        }
        if let description = description {
            dict["description"] = description.toJSON()
        }
        if let contact = contact {
            dict["contact"] = contact.toJSON()
        }
        if let support = support {
            dict["support"] = support.toJSON()
        }
        if let privacyContact = privacyContact {
            dict["privacyContact"] = privacyContact.toJSON()
        }
        if let geo = geoLocation {
            dict["geoLocation"] = geo.toJSON()
        }
        if let keys = publicKeys, !keys.isEmpty {
            dict["publicKeys"] = keys.map { $0.toJSON() }
        }
        return dict
    }

    static func parse(
        from data: [String: Any],
        value: inout Manufacturer?,
        errorResponse: inout String?
    ) -> Bool {
        // name (mandatory)
        var nameValue: String?
        guard data.parseMandatoryString("name", value: &nameValue, errorResponse: &errorResponse),
              let name = nameValue else {
            return false
        }
        // context (optional)
        let contextValue = data["context"] as? String
        // description (optional I18NString)
        var descValue: I18NString?
        guard data.parseOptionalI18NString("description", value: &descValue, errorResponse: &errorResponse) else {
            return false
        }
        // contact (optional object)
        var contactValue: Contact?
        if let raw = data["contact"] as? [String: Any] {
            guard Contact.parse(from: raw, value: &contactValue, errorResponse: &errorResponse) else {
                return false
            }
        }
        // support (optional object)
        var supportValue: Support?
        if let raw = data["support"] as? [String: Any] {
            guard Support.parse(from: raw, value: &supportValue, errorResponse: &errorResponse) else {
                return false
            }
        }
        // privacyContact (optional object)
        var privacyValue: PrivacyContact?
        if let raw = data["privacyContact"] as? [String: Any] {
            guard PrivacyContact.parse(from: raw, value: &privacyValue, errorResponse: &errorResponse) else {
                return false
            }
        }
        // geoLocation (optional object)
        var geoValue: GeoLocation?
        if let raw = data["geoLocation"] as? [String: Any] {
            guard GeoLocation.parse(from: raw, value: &geoValue, errorResponse: &errorResponse) else {
                return false
            }
        }
        // publicKeys (optional array)
        var keys: [PublicKey]? = []
        guard data.parseOptionalArray("publicKeys", into: &keys, errorResponse: &errorResponse,
                                      using: { dict, key, err in
                                          PublicKey.parse(from: dict, value: &key, errorResponse: &err)
                                      }) else {
            return false
        }
        // Instantiate
        value = Manufacturer(
            name: name,
            context: contextValue,
            description: descValue,
            contact: contactValue,
            support: supportValue,
            privacyContact: privacyValue,
            geoLocation: geoValue,
            publicKeys: keys
        )
        errorResponse = nil
        return true
    }

}
