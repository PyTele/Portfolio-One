//
//  DataController-Awards.swift
//  zts portfolio
//
//  Created by Hubert Leszkiewicz on 03/11/2021.
//

import Foundation
import CoreData

extension DataController {
    func hasEarned(award: Award) -> Bool {
        switch award.criterion {
        case "items":
//          returns true if they added a certain about of items
            let fetchRequest: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value

        case "complete":
//            returns true if they completed a certain number of items
            let fetchRequest: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
            fetchRequest.predicate = NSPredicate(format: "complete = true")
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value

        default:
//            unknown award criterion; this should never be triggered
//            fatalError("Unknown award criterion \(award.criterion).")
            return false
        }
    }
}
