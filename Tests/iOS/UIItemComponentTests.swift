//
//  UIItemComponentTests.swift
//  TinyComponentTests
//
//  Created by Roy Hsu on 16/02/2018.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - UIItemComponentTests

import XCTest

@testable import TinyComponent

internal final class UIItemComponentTests: XCTestCase {

    internal final func testInitialize() {

        let redView = UIView()

        redView.backgroundColor = .red

        let redComponent = UIItemComponent(itemView: redView)

        XCTAssertEqual(
            redComponent.contentMode,
            .automatic(estimatedSize: .zero)
        )

        XCTAssertNotEqual(
            redComponent.itemView,
            redComponent.view
        )

        XCTAssertEqual(
            redComponent.view.frame,
            .zero
        )

        XCTAssertEqual(
            redComponent.view.frame,
            redComponent.itemView.frame
        )

        XCTAssertEqual(
            redComponent.itemView.backgroundColor,
            .red
        )

        XCTAssertEqual(
            redComponent.view.backgroundColor,
            redComponent.itemView.backgroundColor
        )

    }

    internal final func testRender() {

        let redView = UIView()

        redView.backgroundColor = .red

        let redComponent = UIItemComponent(itemView: redView)

        // Expect to change back to red after rendering.
        redComponent.view.backgroundColor = .blue

        redComponent.render()

        // After rendering.
        XCTAssertEqual(
            redComponent.view.frame,
            .zero
        )

        XCTAssertEqual(
            redComponent.view.frame,
            redComponent.itemView.frame
        )

        XCTAssertEqual(
            redComponent.itemView.backgroundColor,
            .red
        )

        XCTAssertEqual(
            redComponent.view.backgroundColor,
            redComponent.itemView.backgroundColor
        )

    }

    internal final func testRenderLayoutForNonIntrinsicContentWithContentModeFixed() {

        let redView = UIView()

        redView.backgroundColor = .red

        let redComponent = UIItemComponent(
            contentMode: .fixed(
                size: CGSize(
                    width: 100.0,
                    height: 50.0
                )
            ),
            itemView: redView
        )

        redComponent.render()

        XCTAssertEqual(
            redComponent.itemView.frame.size,
            CGSize(
                width: 100.0,
                height: 50.0
            )
        )

        XCTAssertEqual(
            redComponent.view.bounds,
            redComponent.itemView.frame
        )

    }

    internal final func testRenderLayoutForNonIntrinsicContentWithContentModeAutomatic() {

        let redView = UIView()

        redView.backgroundColor = .red

        let redComponent = UIItemComponent(
            contentMode: .automatic(
                estimatedSize: CGSize(
                    width: 100.0,
                    height: 50.0
                )
            ),
            itemView: redView
        )

        redComponent.render()

        XCTAssertEqual(
            redComponent.itemView.frame.size,
            CGSize(
                width: 100.0,
                height: 50.0
            )
        )

        XCTAssertEqual(
            redComponent.view.bounds,
            redComponent.itemView.frame
        )

    }

    internal final func testRenderLayoutForIntrinsicContentWithContentModeFixed() {

        let label = UILabel()

        label.numberOfLines = 0

        label.text = "Maecenas faucibus mollis interdum. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus. Curabitur blandit tempus porttitor. Vestibulum id ligula porta felis euismod semper."

        let labelComponent = UIItemComponent(
            contentMode: .fixed(
                size: CGSize(
                    width: 50.0,
                    height: 50.0
                )
            ),
            itemView: label
        )

        labelComponent.render()

        XCTAssertEqual(
            labelComponent.view.frame.size,
            CGSize(
                width: 50.0,
                height: 50.0
            )
        )

        XCTAssertNotEqual(
            labelComponent.view.frame.size,
            label.sizeThatFits(
                CGSize(
                    width: 50.0,
                    height: 50.0
                )
            )
        )

    }

    internal final func testRenderLayoutForIntrinsicContentWithContentModeAutomatic() {

        let label = UILabel()

        label.numberOfLines = 0

        label.text = "Maecenas faucibus mollis interdum. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus. Curabitur blandit tempus porttitor. Vestibulum id ligula porta felis euismod semper."

        let labelComponent = UIItemComponent(
            contentMode: .automatic(
                estimatedSize: CGSize(
                    width: 50.0,
                    height: 50.0
                )
            ),
            itemView: label
        )

        labelComponent.render()

        XCTAssertEqual(
            labelComponent.view.frame.size,
            label.sizeThatFits(
                CGSize(
                    width: 50.0,
                    height: 50.0
                )
            )
        )

        XCTAssertNotEqual(
            labelComponent.view.frame.size,
            CGSize(
                width: 50.0,
                height: 50.0
            )
        )

    }

}
