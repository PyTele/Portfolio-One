//
//  Error-CloudKitMessages.swift
//  zts portfolio
//
//  Created by Hubert Leszkiewicz on 29/11/2021.
//

import CloudKit
import Foundation

extension Error {
    func getCloudKitError() -> CloudError {
        guard let error = self as? CKError else {
            return "An unknown error occurred: \(self.localizedDescription)"
        }
        
        switch error.code {
        case .badContainer, .badDatabase, .invalidArguments:
            return "A fatal error occurred: \(self.localizedDescription)"
            
        case .networkFailure, .networkUnavailable, .serverResponseLost, .serviceUnavailable:
            return "There was a problem communicating with iCloud; please check your network connection and try again later."
            
        case .notAuthenticated:
            return "There was a problem with your iCloud account; please check that you are logged in to iCloud."
            
        case .requestRateLimited:
            return "Woah, slow down with the requests, iCloud needs a moment to catch up. Please wait and try again."
            
        case .quotaExceeded:
            return "You've exceeded the iCloud quota limit; clear up some space to send this project and then try again."
            
        default:
            return "An unknown error occurred: \(self.localizedDescription)"
        }
    }
}
