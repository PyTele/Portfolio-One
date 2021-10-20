//
//  ProductView.swift
//  zts portfolio
//
//  Created by Hubert Leszkiewicz on 20/10/2021.
//

import StoreKit
import SwiftUI

struct ProductView: View {
    @EnvironmentObject var unlockManager: UnlockManager
    let product: SKProduct

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Get Unlimited Projects")
                    .font(.headline)
                    .padding(.top, 10)

                Text("You can add three projects for free, or pay \(product.localisedPrice) to add unlimited products!")
                Text("If you already bought the unlock on another device, press Restore Purchases.")

                Button("Buy: \(product.localisedPrice)", action: unlock)
                    .buttonStyle(PurchaseButton())

                Button("Restore Purchases", action: unlockManager.restore)
                    .buttonStyle(PurchaseButton())
            }
        }
    }

    func unlock() {
        unlockManager.buy(product: product)
    }
}
