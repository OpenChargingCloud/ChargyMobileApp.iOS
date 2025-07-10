//
//  ChargingStationOperator.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 08.07.25.
//


import Foundation

class ChargingStationOperator: Codable {
    
    var id:                  String
    var context:             String?
    var description:         I18NString?
//    subCSOIds?:                      Array<string>;
    var contact:             Contact?
    var support:             Support?
    var privacyContact:      PrivacyContact?;
    var geoLocation:         GeoLocation;
    var chargingPools:       [ChargingPool]     = []
    var chargingStations:    [ChargingStation]  = []
    var EVSEs:               [EVSE]             = []
    var chargingTariffs:     [ChargingTariff]   = []
    var parkingTariffs:      [ParkingTariff]    = []
    var publicKeys:          [PublicKey]        = []

}
