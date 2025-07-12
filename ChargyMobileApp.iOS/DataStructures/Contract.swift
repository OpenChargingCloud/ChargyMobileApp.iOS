//
//  Contract.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 08.07.25.
//

import Foundation

class Contract: Identifiable, JSONSerializable {
    
    public private(set) var id:            String
    public private(set) var context:       String?
    public private(set) var description:   I18NString?
    public private(set) var type:          String?
    public private(set) var username:      String?
    public private(set) var email:         String?
 
    init(
        id:           String,
        context:      String?       = nil,
        description:  I18NString?   = nil,
        type:         String?       = nil,
        username:     String?       = nil,
        email:        String?       = nil
    ) {
        self.id           = id
        self.context      = context
        self.description  = description
        self.type         = type
        self.username     = username
        self.email        = email
    }

    
    static func parse(from data:      [String: Any],
                      value:          inout Contract?,
                      errorResponse:  inout String?) -> Bool {
        
        var id: String?
        if !data.parseMandatoryString("id", value: &id, errorResponse: &errorResponse) {
            return false
        }
        
        var context: String?
        if data.parseOptionalString("context", value: &context, errorResponse: &errorResponse) {
            if (!(errorResponse == nil)) {
                return false
            }
        }
        
        var description: I18NString?
        if data.parseOptionalI18NString("description", value: &description, errorResponse: &errorResponse) {
            if (!(errorResponse == nil)) {
                return false
            }
        }

        var type: String?
        if data.parseOptionalString("type", value: &type, errorResponse: &errorResponse) {
            if (!(errorResponse == nil)) {
                return false
            }
        }

        var username: String?
        if data.parseOptionalString("username", value: &username, errorResponse: &errorResponse) {
            if (!(errorResponse == nil)) {
                return false
            }
        }

        var email: String?
        if data.parseOptionalString("email", value: &email, errorResponse: &errorResponse) {
            if (!(errorResponse == nil)) {
                return false
            }
        }

        
        value = Contract(
                    id:           id!,
                    context:      context,
                    description:  description,
                    type:         type,
                    username:     username,
                    email:        email
                )
        
        return true
        
    }
    
    func toJSON() -> [String: Any] {

        var dict: [String: Any] = [
            "id": id
        ]

        if let context = context {
            dict["context"] = context
        }

        if let description = description {
            dict["description"] = description.toJSON()
        }

        if let type = type {
            dict["type"] = type
        }

        if let username = username {
            dict["username"] = username
        }

        if let email = email {
            dict["email"] = email
        }

        return dict

    }

}
