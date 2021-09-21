//
//  zts_portfolioTests.swift
//  zts portfolioTests
//
//  Created by Hubert Leszkiewicz on 21/09/2021.
//

import CoreData
import XCTest
@testable import zts_portfolio

class BaseTestCase: XCTestCase {
    var dataController: DataController!
    var managedObjectContext: NSManagedObjectContext!

    override func setUpWithError() throws {
        dataController = DataController(inMemory: true)
        managedObjectContext = dataController.container.viewContext
    }
}
