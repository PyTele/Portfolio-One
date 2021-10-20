//
//  UnlockView.swift
//  zts portfolio
//
//  Created by Hubert Leszkiewicz on 20/10/2021.
//

import StoreKit
import SwiftUI

struct UnlockView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var unlockManager: UnlockManager
    var body: some View {
        VStack {
            switch unlockManager.requestState {
            case .loaded(let product):
                ProductView(product: product)
            case .failed(_):
                Text("Sorry, there was an error loading the storefront. Please try again later.")
            case .loading:
                ProgressView("Loading...")
            case .purchased:
                Text("Thanks you!")
            case .deferred:
                // swiftlint:disable:next line_length
                Text("Thank you! Your request is pending approval, but you can continue to use the app in the meantime.")
            }
        }
        .padding()
        .onReceive(unlockManager.$requestState) { value in
            if case .purchased = value {
                dismiss()
            }
        }
    }

    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}
