//
//  GeoLocation.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 08.07.25.
//

import Foundation

class GeoLocation: JSONSerializable {
    
    var lat:  Double
    var lng:  Double

    init(lat: Double, lng: Double) {
        self.lat = lat
        self.lng = lng
    }


    static func parse(
        from data: [String: Any],
        value: inout GeoLocation?,
        errorResponse: inout String?
    ) -> Bool {
        // lat (mandatory)
        var latValue: Double?
        guard data.parseMandatoryDouble("lat", value: &latValue, errorResponse: &errorResponse),
              let lat = latValue else {
            return false
        }
        // lng (mandatory)
        var lngValue: Double?
        guard data.parseMandatoryDouble("lng", value: &lngValue, errorResponse: &errorResponse),
              let lng = lngValue else {
            return false
        }
        value = GeoLocation(lat: lat, lng: lng)
        errorResponse = nil
        return true
    }
    
    func toJSON() -> [String: Any] {
        return [
            "lat": lat,
            "lng": lng
        ]
    }

}
