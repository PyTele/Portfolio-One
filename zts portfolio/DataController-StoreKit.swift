//
//  DataController-StoreKit.swift
//  zts portfolio
//
//  Created by Hubert Leszkiewicz on 08/11/2021.
//

import Foundation
import StoreKit

extension DataController {
    func appLaunched() {
        guard count(for: Project.fetchRequest()) >= 5 else { return }
        let allScenes = UIApplication.shared.connectedScenes
        let scene = allScenes.first { $0.activationState == .foregroundActive }

        if let windowScene = scene as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
}
