//
//  SKProduct-LocalisedPrice.swift
//  zts portfolio
//
//  Created by Hubert Leszkiewicz on 20/10/2021.
//

import StoreKit

extension SKProduct {
    var localisedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)!
    }
}
