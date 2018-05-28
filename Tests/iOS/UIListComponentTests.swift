//
//  UIListComponentTests.swift
//  TinyComponentTests
//
//  Created by Roy Hsu on 28/01/2018.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - UIListComponentTests

import XCTest

@testable import TinyComponent

// swiftlint:disable type_body_length
internal final class UIListComponentTests: XCTestCase {

    internal final func testInitialize() {

        let listComponent = UIListComponent()

        XCTAssertEqual(
            listComponent.contentMode,
            .automatic(estimatedSize: .zero)
        )

        XCTAssertEqual(
            listComponent.tableView,
            listComponent.view
        )

        XCTAssertEqual(
            listComponent.tableView.style,
            .plain
        )

        XCTAssertEqual(
            listComponent.view.frame,
            .zero
        )

        XCTAssertEqual(
            listComponent.view.backgroundColor,
            .clear
        )

        XCTAssertEqual(
            listComponent.numberOfSections,
            0
        )

        XCTAssertNil(listComponent.headerComponent)

        XCTAssertNil(listComponent.footerComponent)

    }

    internal final func testRenderWithContentModeFixed() {

        let listComponent = UIListComponent(
            contentMode: .fixed(
                size: CGSize(
                    width: 500.0,
                    height: 500.0
                )
            )
        )

        listComponent.render()

        XCTAssertEqual(
            listComponent.view.frame.size,
            CGSize(
                width: 500.0,
                height: 500.0
            )
        )

    }

    internal final func testRenderWithContentModeAutomatic() {

        let redView = UIView()

        redView.backgroundColor = .red

        let redComponent = UIItemComponent(
            contentMode: .fixed(
                size: CGSize(
                    width: 100.0,
                    height: 100.0
                )
            ),
            itemView: redView
        )

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

        let listComponent = UIListComponent(
            contentMode: .automatic(
                estimatedSize: CGSize(
                    width: 500.0,
                    height: 50.0
                )
            )
        )

        listComponent.setItemComponents(
            [
                redComponent,
                labelComponent
            ]
        )

        listComponent.render()

        let expectedLabelSize = label.sizeThatFits(
            CGSize(
                width: 500.0,
                height: 50.0
            )
        )

        XCTAssertEqual(
            listComponent.view.frame.size.width,
            500.0,
            accuracy: .greatestFiniteMagnitude
        )

        XCTAssertEqual(
            listComponent.view.frame.size.height,
            100 + expectedLabelSize.height,
            accuracy: .greatestFiniteMagnitude
        )

        let firstItemComponent = listComponent.itemComponent(
            at: IndexPath(
                row: 0,
                section: 0
            )
        )

        XCTAssertEqual(
            firstItemComponent.contentMode,
            .fixed(
                size: CGSize(
                    width: 500.0,
                    height: 100.0
                )
            )
        )

        XCTAssertEqual(
            firstItemComponent.view.frame.size,
            CGSize(
                width: 500.0,
                height: 100.0
            )
        )

        let secondItemComponent = listComponent.itemComponent(
            at: IndexPath(
                row: 1,
                section: 0
            )
        )

        XCTAssertEqual(
            secondItemComponent.contentMode,
            .automatic(
                estimatedSize: CGSize(
                    width: 500.0,
                    height: 50.0
                )
            )
        )

        XCTAssertEqual(
            secondItemComponent.view.frame.size,
            CGSize(
                width: 500.0,
                height: expectedLabelSize.height
            )
        )

    }

    internal final func testRenderHeaderComponent() {

        let squareComponent = UIItemComponent(
            contentMode: .fixed(
                size: CGSize(
                    width: 100.0,
                    height: 100.0
                )
            ),
            itemView: UIView()
        )

        let listComponent = UIListComponent(
            contentMode: .automatic(
                estimatedSize: CGSize(
                    width: 500.0,
                    height: 50.0
                )
            )
        )

        listComponent.headerComponent = squareComponent

        listComponent.render()

        XCTAssertEqual(
            listComponent.tableView.tableHeaderView,
            squareComponent.view
        )

        XCTAssertEqual(
            listComponent.headerComponent?.view.frame.size,
            CGSize(
                width: 500.0,
                height: 100.0
            )
        )

    }

    internal final func testRenderFooterComponent() {

        let squareComponent = UIItemComponent(
            contentMode: .fixed(
                size: CGSize(
                    width: 100.0,
                    height: 100.0
                )
            ),
            itemView: UIView()
        )

        let listComponent = UIListComponent(
            contentMode: .automatic(
                estimatedSize: CGSize(
                    width: 500.0,
                    height: 50.0
                )
            )
        )

        listComponent.footerComponent = squareComponent

        listComponent.render()

        XCTAssertEqual(
            listComponent.tableView.tableFooterView,
            squareComponent.view
        )

        XCTAssertEqual(
            listComponent.footerComponent?.view.frame.size,
            CGSize(
                width: 500.0,
                height: 100.0
            )
        )

    }

    internal final func testKeepStrongReferencesToItemComponentsWhileRendering() {

        let colorComponentFactory: (UIColor) -> Component = { color in

            let component = UIItemComponent(
                contentMode: .fixed(
                    size: CGSize(
                        width: 100.0,
                        height: 100.0
                    )
                ),
                itemView: UIView()
            )

            component.view.backgroundColor = color

            return component

        }

        let redComponent = colorComponentFactory(.red)

        let listComponent = UIListComponent(
            contentMode: .automatic(
                estimatedSize: CGSize(
                    width: 500.0,
                    height: 50.0
                )
            )
        )

        listComponent.setItemComponents(
            [ redComponent ]
        )

        listComponent.render()

        XCTAssertEqual(
            listComponent.itemComponentCache.count,
            1
        )

        let firstItemIndexPath = IndexPath(
            item: 0,
            section: 0
        )

        XCTAssert(
            listComponent.itemComponentCache[firstItemIndexPath]
            === redComponent
        )

        let blueComponent = colorComponentFactory(.blue)

        listComponent.setItemComponents(
            [ blueComponent ]
        )

        listComponent.render()

        XCTAssertEqual(
            listComponent.itemComponentCache.count,
            1
        )

        XCTAssert(
            listComponent.itemComponentCache[firstItemIndexPath]
            === blueComponent
        )

    }

    internal final func testGetItemComponentByIndexPath() {

        let squareComponent = UIItemComponent(
            contentMode: .fixed(
                size: CGSize(
                    width: 100.0,
                    height: 100.0
                )
            ),
            itemView: UIView()
        )

        let listComponent = UIListComponent(
            contentMode: .automatic(
                estimatedSize: CGSize(
                    width: 500.0,
                    height: 50.0
                )
            )
        )

        listComponent.setItemComponents(
            [ squareComponent ]
        )

        listComponent.render()

        let firstComponent = listComponent.itemComponent(
            at: IndexPath(
                item: 0,
                section: 0
            )
        )

        XCTAssert(firstComponent === squareComponent)

    }

}
// swiftlint:enable type_body_length
