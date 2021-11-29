//
//  ChatMessage.swift
//  zts portfolio
//
//  Created by Hubert Leszkiewicz on 23/11/2021.
//

import CloudKit
import Foundation

struct ChatMessage: Identifiable {
    let id: String // swiftlint:disable:this identifier_name
    let from: String
    let text: String
    let date: Date
}

extension ChatMessage {
    init(from record: CKRecord) {
        id = record.recordID.recordName
        from = record["from"] as? String ?? "No Author"
        text = record["text"] as? String ?? "No Text"
        date = record.creationDate ?? Date()
    }
}
