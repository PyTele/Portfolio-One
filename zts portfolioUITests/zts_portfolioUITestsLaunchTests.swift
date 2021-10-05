//
//  zts_portfolioUITestsLaunchTests.swift
//  zts portfolioUITests
//
//  Created by Hubert Leszkiewicz on 05/10/2021.
//

import XCTest

class zts_portfolioUITestsLaunchTests: XCTestCase { // swiftlint:disable:this type_name

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
