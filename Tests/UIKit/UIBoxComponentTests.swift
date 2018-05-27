//
//  UIBoxComponentTests.swift
//  TinyComponentTests
//
//  Created by Roy Hsu on 2018/4/23.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - UIBoxComponentTests

import XCTest

@testable import TinyComponent

internal final class UIBoxComponentTests: XCTestCase {

    internal final func testInitialize() {

        let redView = UIView()

        redView.backgroundColor = .red

        let redComponent = UIItemComponent(itemView: redView)

        let boxComponent = UIBoxComponent(contentComponent: redComponent)

        XCTAssertEqual(
            boxComponent.contentMode,
            .automatic(estimatedSize: .zero)
        )

        let containerView = boxComponent.containerView

        let contentView = boxComponent.contentView

        XCTAssert(boxComponent.view === containerView)

        XCTAssert(containerView !== contentView)

        XCTAssert(contentView === redComponent.view)

    }

    internal final func testRenderWithContentModeFixed() {

        let redView = UIView()

        redView.backgroundColor = .red

        let redComponent = UIItemComponent(itemView: redView)

        let boxComponent = UIBoxComponent(
            contentMode: .fixed(
                size: CGSize(
                    width: 50.0,
                    height: 10.0
                )
            ),
            contentComponent: redComponent
        )

        boxComponent.paddingInsets = UIEdgeInsets(
            top: 1.0,
            left: 2.0,
            bottom: 3.0,
            right: 4.0
        )

        boxComponent.render()

        let containerView = boxComponent.containerView

        let contentView = boxComponent.contentView

        XCTAssertEqual(
            containerView.frame.width,
            50.0,
            accuracy: .greatestFiniteMagnitude
        )

        XCTAssertEqual(
            containerView.frame.height,
            50.0,
            accuracy: .greatestFiniteMagnitude
        )

        XCTAssertEqual(
            contentView.frame.minX,
            2.0,
            accuracy: .greatestFiniteMagnitude
        )

        XCTAssertEqual(
            contentView.frame.minY,
            1.0,
            accuracy: .greatestFiniteMagnitude
        )

        XCTAssertEqual(
            contentView.frame.width,
            containerView.frame.width - 2.0 - 4.0,
            accuracy: .greatestFiniteMagnitude
        )

        XCTAssertEqual(
            contentView.frame.height,
            containerView.frame.height - 1.0 - 3.0,
            accuracy: .greatestFiniteMagnitude
        )

        XCTAssertEqual(
            boxComponent.contentComponent.contentMode,
            .automatic(
                estimatedSize: CGSize(
                    width: containerView.frame.width - 2.0 - 4.0,
                    height: containerView.frame.height - 1.0 - 3.0
                )
            )
        )

        XCTAssertEqual(
            containerView.backgroundColor,
            contentView.backgroundColor
        )

        XCTAssertEqual(
            containerView.backgroundColor,
            .red
        )

    }

    internal final func testRenderWithContentModeAutomatic() {

        let label = UILabel()

        label.numberOfLines = 0

        label.text = "Maecenas faucibus mollis interdum. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus. Curabitur blandit tempus porttitor. Vestibulum id ligula porta felis euismod semper."

        let labelComponent = UIItemComponent(itemView: label)

        let boxComponent = UIBoxComponent(
            contentMode: .automatic(
                estimatedSize: CGSize(
                    width: 50.0,
                    height: 10.0
                )
            ),
            contentComponent: labelComponent
        )

        boxComponent.paddingInsets = UIEdgeInsets(
            top: 1.0,
            left: 2.0,
            bottom: 3.0,
            right: 4.0
        )

        boxComponent.render()

        let containerView = boxComponent.containerView

        let contentView = boxComponent.contentView

        let expectedLabelSize = label.sizeThatFits(
            CGSize(
                width: 50.0 - 2.0 - 4.0,
                height: 10.0
            )
        )

        XCTAssertEqual(
            containerView.frame.width,
            50.0,
            accuracy: .greatestFiniteMagnitude
        )

        XCTAssertEqual(
            containerView.frame.height,
            expectedLabelSize.height + 1.0 + 3.0,
            accuracy: .greatestFiniteMagnitude
        )

        XCTAssertEqual(
            contentView.frame.width,
            50.0 - 2.0 - 4.0,
            accuracy: .greatestFiniteMagnitude
        )

        XCTAssertEqual(
            contentView.frame.height,
            expectedLabelSize.height,
            accuracy: .greatestFiniteMagnitude
        )

    }

}
