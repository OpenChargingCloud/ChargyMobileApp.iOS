//
//  StartView.swift
//  ChargyMobileApp.iOS
//
//  Created by Achim Friedland on 07.07.25.
//

import SwiftUI

struct StartView: View {
    
    @StateObject private var viewModel = ChargeTransparencyDataViewModel()
    @State private var navigate = false
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Button("Transparenzdaten einfügen") {
                    viewModel.pasteFromClipboard()
                    navigate = true
                }
                .padding()
                
            }
            .navigationDestination(isPresented: $navigate) {
                ChargeTransparencyDataView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    ChargeTransparencyDataView()
}
