//
//  BucksSwiftUITests.swift
//  BucksSwiftUITests
//
//  Created by Claudia Danciu on 07/07/2023.
//

import XCTest
import SwiftUI
@testable import BucksSwiftUI

final class BucksSwiftUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTabNavigation() throws {
        // Given
        var selectedTab: Tabs = .homeTab

        let tabBarView = TabBarView(selectedTab: Binding(
            get: { selectedTab },
            set: { selectedTab = $0 }
        ))

        // When
        selectedTab = .profileTab

        // Then
        XCTAssertEqual(selectedTab, .profileTab, "Selected tab should be set to profileTab")
    }

}
