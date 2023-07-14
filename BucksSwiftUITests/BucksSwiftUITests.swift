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

    func testTabNavigation() throws {
        // Given
        var selectedTab: Tabs = .homeTab

        // When
        selectedTab = .profileTab

        // Then
        XCTAssertEqual(selectedTab, .profileTab, "Selected tab should be set to profileTab")
    }

}
