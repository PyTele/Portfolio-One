//
//  CloudError.swift
//  zts portfolio
//
//  Created by Hubert Leszkiewicz on 29/11/2021.
//

import CloudKit
import Foundation

struct CloudError: Identifiable, ExpressibleByStringInterpolation {
    var id: String { message }
    var message: String
    
    init(stringLiteral value: String) {
        self.message = value
    }
}
