//
//  SKStoreReviewController+Custom.swift
//  healthpoints
//
//  Created by Joe Beaudoin on 9/28/22.
//  Copyright © 2022 Joseph Smith. All rights reserved.
//

import Foundation
import StoreKit

extension SKStoreReviewController {
    public static func requestReviewInCurrentScene() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            DispatchQueue.main.async {
                requestReview(in: scene)
            }
        }
    }
}
