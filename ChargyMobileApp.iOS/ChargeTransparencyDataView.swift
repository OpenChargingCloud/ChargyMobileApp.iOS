//
//  ChargeTransparencyDataView.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 07.07.25.
//

import SwiftUI
import Foundation

struct ChargeTransparencyDataView: View {
    
    @ObservedObject var viewModel: ChargeTransparencyDataViewModel

    init(viewModel: ChargeTransparencyDataViewModel = ChargeTransparencyDataViewModel()) {
        self.viewModel = viewModel
    }
  
    static let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "EE, d. MMMM yyyy"
            return formatter
        }()
    
    static let weekdayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "de_DE")
        f.dateFormat = "EE"
        return f
    }()
    
    static let timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "de_DE")
        f.dateFormat = "HH:mm:ss"
        return f
    }()
    
    var body: some View {
        NavigationView {
            VStack {
                                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                }
                
                if let ctrDescription = viewModel.description?.first() {
                    Text(ctrDescription)
                       .font(.headline)
                       .fontWeight(.bold)
                       .frame(maxWidth: .infinity, alignment: .center)
                       .padding(.vertical, 8)
                }

                if let ctrContract = viewModel.ctr?.contracts?.first {
                    Text(ctrContract.id)
                       .font(.headline)
                       .frame(maxWidth: .infinity, alignment: .center)
                       .padding(.vertical, 8)
                }

                List(viewModel.sessions) {
                    session in
                    
                    NavigationLink {
                        ChargingSessionView(session: session)
                    }
                    
                    label: {
                        VStack(alignment: .leading, spacing: 4) {
                            
                            Text(Self.dateFormatter.string(from: session.begin))

                            Text(session.formattedTimeRange)
                            
                            if let evseId = session.evseId {
                                Text("EVSE Id: \(evseId)")
                            }
                            else if let stationId = session.chargingStationId {
                                Text("Station Id: \(stationId)")
                            }

                            if let energy = session.energy {
                                Text(String(format: "Energie: %.2f kWh", energy))
                            }
                            
                            if let signatures = session.signatures {
                                ForEach(signatures.indices, id: \.self) { i in
                                    let sig = signatures[i]
                                    Text("Signature \(i+1):")
                                    if let pub = sig.publicKey { Text("  PublicKey: \(pub)") }
                                    if let s = sig.signature { Text("  Signature: \(s)") }
                                }
                            }
                            
//                            if let validation = session.validation {
//                                Text("Validation: \(validation.rawValue)")
//                            }
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(0)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.secondarySystemGroupedBackground))
                        )
                        .overlay(
                            Group {
                                if session.validation == .valid {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                } else if session.validation == .invalid {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                } else {
                                    Image(systemName: "questionmark.circle.fill")
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding(8),
                            alignment: .topTrailing
                        )
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 12)
//                                .stroke(Color(.separator), lineWidth: 0.5)
//                        )
                        .padding(.vertical, 6)
                        .listRowBackground(Color.clear)
                    }
                    .padding(0)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .padding(0)

            }
//            .navigationTitle("Sessions")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//              ToolbarItem(placement: .navigationBarLeading) {
//                // occupy the same width as a back button
//                Color.clear.frame(width: 44)
//              }
//            }
        }
    }
}


extension ChargeTransparencyDataViewModel {
    static var preview: ChargeTransparencyDataViewModel {
        
        let vm  = ChargeTransparencyDataViewModel()
        let iso = ISO8601DateFormatter()

        vm.description = I18NString(
                             language: "en",
                             value:    "Sessions of June 2025"
                         )

        vm.sessions = [
            
            ChargingSession(
                id:          "18a7a7f5-1a72-414b-97d1-8b18ffeb9c60",
                begin:       iso.date(from: "2024-06-30T19:00:00Z")!,
                evseId:      "DE*GEF*E12345678*1",
                energy:      23.52,
                signatures:  [
                                 Signature(
                                     publicKey:  "00112233",
                                     signature:  "abc"
                                 )
                             ],
                validation:  ValidationState.invalid
            ),
        
            ChargingSession(
                id:          "ae6efcec-1290-4c1a-9dfd-cf3d1431f49b",
                begin:       iso.date(from: "2025-06-12T19:23:03Z")!,
                end:         iso.date(from: "2025-06-12T21:42:07Z"),
                evseId:      "DE*GEF*E12345678*2",
                energy:      35.2
            ),
        
            ChargingSession(
                id:          "0fcece6e-6898-8768-3598-31f49bcf3d14",
                begin:       iso.date(from: "2025-06-08T19:23:55Z")!,
                end:         iso.date(from: "2025-06-10T14:48:03Z"),
                evseId:      "DE*GEF*E12345678*3",
                energy:      29.62
            )
            
        ]
        
        return vm

    }
}

#Preview {
    ChargeTransparencyDataView(viewModel: .preview)
}
