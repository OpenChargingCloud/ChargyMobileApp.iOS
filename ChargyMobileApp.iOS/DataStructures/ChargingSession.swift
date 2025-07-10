//
//  ChargingSession.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 07.07.25.
//

import Foundation

class ChargingSession: Identifiable, Codable {
        
    public private(set) var id:                         String
    public private(set) var context:                    String?
    public private(set) var begin:                      Date
    public private(set) var end:                        Date?

    public private(set) var energy:                     Double?
    public private(set) var meterValues:                [MeterValue]?

    public private(set) var signatures:                 [Signature]?
                        var validation:                 ValidationState?

    public private(set) var chargeTransparencyRecord:   ChargeTransparencyRecord?
                        var originalCTR:                String?

    
    init(
        id:                        String,
        begin:                     Date,
        context:                   String?                     = nil,
        end:                       Date?                       = nil,
        energy:                    Double?                     = nil,
        meterValues:               [MeterValue]?               = nil,
        signatures:                [Signature]?                = nil,
        validation:                ValidationState?            = nil,
        chargeTransparencyRecord:  ChargeTransparencyRecord?   = nil,
        originalCTR:               String?                     = nil
    ) {
        self.originalCTR               = originalCTR
        self.id                        = id
        self.context                   = context
        self.begin                     = begin
        self.end                       = end
        self.energy                    = energy
        self.meterValues               = meterValues
        self.signatures                = signatures
        self.validation                = validation
        self.chargeTransparencyRecord  = chargeTransparencyRecord
    }
    
}
