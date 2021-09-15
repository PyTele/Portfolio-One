//
//  DataController.swift
//  zts portfolio
//
//  Created by Hubert Leszkiewicz on 24/05/2021.
//

import CoreData
import SwiftUI

/// An environment created specifically to preform intensive, consistent or background data management tasks;
/// i.e. User award statuses and save data solutions.
class DataController: ObservableObject {
    /// This is the secure CloudKit storage location, used for user added materials along with encrypted user data.
    let container: NSPersistentCloudKitContainer

    /// Initialises  a data controller, either in memory ( for testing and previewing )
    ///  or from permanent storage ( for public Alpha/Beta/Release ).
    ///
    ///  This defaults to permanents storage when available.
    /// - Parameter inMemory: Whether to store this data in temporary or permanent storage
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Main")

// For testing and previewing purposes, we create a temporary,
// in-memory database by writing to /dev/null so the data is
// destroyed after the app is finishes running.
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
        }
    }

    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        let viewContext = dataController.container.viewContext

        do {
            try dataController.createSampleData()
        } catch {
            fatalError("Fatal error creating preview: \(error.localizedDescription)")
        }

        return dataController
    }()

    
    /// Used to add sample data for testing and debugging purposes.
    /// - Throws: An NSError sent from calling save() on the NSManagedObjectContext.
    func createSampleData() throws {
        let viewContext = container.viewContext

        for projectCounter in 1...5 {
            let project = Project(context: viewContext)
            project.title = "Project \(projectCounter)"
            project.items = []
            project.creationDate = Date()
            project.closed = Bool.random()

            for itemCounter in 1...10 {
                let item = Item(context: viewContext)
                item.title = "Item \(itemCounter)"
                item.creationDate = Date()
                item.complete = Bool.random()
                item.project = project
                item.priority = Int16.random(in: 1...3)
            }
        }

        try viewContext.save()

    }

    /// Saves our Core Data context iff there are any changes. This silently ignores
    /// any errors caused by saving, but this should be fine because our attributes
    /// are optional.
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }

    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
    }

    func deleteAll() {
        let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = Item.fetchRequest()
        let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
        _ = try? container.viewContext.execute(batchDeleteRequest1)

        let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = Project.fetchRequest()
        let batchDeleteRequest2 = NSBatchDeleteRequest(fetchRequest: fetchRequest2)
        _ = try? container.viewContext.execute(batchDeleteRequest2)

    }

    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }

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
