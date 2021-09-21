//
//  AssetTest.swift
//  zts portfolioTests
//
//  Created by Hubert Leszkiewicz on 21/09/2021.
//

import XCTest
@testable import zts_portfolio

class AssetTest: XCTestCase {
    func testColorsExist() {
        for color in Project.colors {
            XCTAssertNotNil(UIColor(named: color), "Failed to load color '\(color)' from asset catalog.")
        }
    }

    func testJSONLoadsCorrectly() {
        XCTAssertFalse(Award.allAwards.isEmpty, "Failed to load awards from JSON.")
    }
}
