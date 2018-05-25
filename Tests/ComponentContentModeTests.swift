//
//  ComponentContentModeTests.swift
//  TinyComponentTests
//
//  Created by Roy Hsu on 2018/5/25.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - ComponentContentModeTests

import XCTest

@testable import TinyComponent

internal final class ComponentContentModeTests: XCTestCase {

    internal final func testEqualModes() {

        XCTAssertEqual(
            ComponentContentMode.fixed(
                size: CGSize(
                    width: 50.0,
                    height: 50.0
                )
            ),
            ComponentContentMode.fixed(
                size: CGSize(
                    width: 50.0,
                    height: 50.0
                )
            )
        )

        XCTAssertEqual(
            ComponentContentMode.automatic(
                estimatedSize: CGSize(
                    width: 50.0,
                    height: 50.0
                )
            ),
            ComponentContentMode.automatic(
                estimatedSize: CGSize(
                    width: 50.0,
                    height: 50.0
                )
            )
        )

    }

    internal final func testUnequalModes() {

        XCTAssertNotEqual(
            ComponentContentMode.fixed(
                size: CGSize(
                    width: 50.0,
                    height: 50.0
                )
            ),
            ComponentContentMode.automatic(
                estimatedSize: CGSize(
                    width: 50.0,
                    height: 50.0
                )
            )
        )

    }

}
