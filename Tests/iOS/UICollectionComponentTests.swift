//
//  UICollectionComponentTests.swift
//  TinyComponentTests
//
//  Created by Roy Hsu on 02/03/2018.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - UICollectionComponentTests

import XCTest

@testable import TinyComponent

internal final class UICollectionComponentTests: XCTestCase {

    internal final func testInitialize() {

        let layout = UICollectionViewFlowLayout()

        let collectionComponent = UICollectionComponent(layout: layout)

        XCTAssertEqual(
            collectionComponent.contentMode,
            .automatic(estimatedSize: .zero)
        )

        XCTAssertEqual(
            collectionComponent.collectionView,
            collectionComponent.view
        )

        XCTAssert(collectionComponent.collectionViewLayout === layout)

        XCTAssertEqual(
            collectionComponent.view.frame,
            .zero
        )

        XCTAssertEqual(
            collectionComponent.view.backgroundColor,
            .clear
        )

        XCTAssertEqual(
            collectionComponent.numberOfSections,
            0
        )

    }

    internal final func testRenderWithContentModeFixed() {

        let collectionComponent = UICollectionComponent(
            contentMode: .fixed(
                size: CGSize(
                    width: 500.0,
                    height: 500.0
                )
            ),
            layout: UICollectionViewFlowLayout()
        )

        collectionComponent.render()

        XCTAssertEqual(
            collectionComponent.view.frame.size,
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

        let collectionComponent = UICollectionComponent(
            contentMode: .automatic(
                estimatedSize: CGSize(
                    width: 500.0,
                    height: 50.0
                )
            ),
            layout: UICollectionViewFlowLayout()
        )

        collectionComponent.setItemComponents(
            [
                redComponent,
                labelComponent
            ]
        )

        collectionComponent.render()

        let expectedLabelSize = label.sizeThatFits(
            CGSize(
                width: 50.0,
                height: 50.0
            )
        )

        XCTAssertEqual(
            collectionComponent.view.frame.size.width,
            500.0,
            accuracy: .greatestFiniteMagnitude
        )

        XCTAssertEqual(
            collectionComponent.view.frame.size.height,
            100.0 + expectedLabelSize.height,
            accuracy: .greatestFiniteMagnitude
        )

        let firstItemComponent = collectionComponent.itemComponent(
            at: IndexPath(
                row: 0,
                section: 0
            )
        )

        XCTAssertEqual(
            firstItemComponent.contentMode,
            .fixed(
                size: CGSize(
                    width: 100.0,
                    height: 100.0
                )
            )
        )

        XCTAssertEqual(
            firstItemComponent.view.frame.size,
            CGSize(
                width: 100.0,
                height: 100.0
            )
        )

        let secondItemComponent = collectionComponent.itemComponent(
            at: IndexPath(
                row: 1,
                section: 0
            )
        )

        XCTAssertEqual(
            secondItemComponent.contentMode,
            .automatic(
                estimatedSize: CGSize(
                    width: 50.0,
                    height: 50.0
                )
            )
        )

        XCTAssertEqual(
            secondItemComponent.view.frame.size,
            CGSize(
                width: 50.0,
                height: expectedLabelSize.height
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

        let collectionComponent = UIListComponent(
            contentMode: .automatic(
                estimatedSize: CGSize(
                    width: 500.0,
                    height: 50.0
                )
            )
        )

        collectionComponent.setItemComponents(
            [ redComponent ]
        )

        collectionComponent.render()

        XCTAssertEqual(
            collectionComponent.itemComponentCache.count,
            1
        )

        let firstItemIndexPath = IndexPath(
            item: 0,
            section: 0
        )

        XCTAssert(
            collectionComponent.itemComponentCache[firstItemIndexPath]
            === redComponent
        )

        let blueComponent = colorComponentFactory(.blue)

        collectionComponent.setItemComponents(
            [ blueComponent ]
        )

        collectionComponent.render()

        XCTAssertEqual(
            collectionComponent.itemComponentCache.count,
            1
        )

        XCTAssert(
            collectionComponent.itemComponentCache[firstItemIndexPath]
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

        let collectionComponent = UIListComponent(
            contentMode: .automatic(
                estimatedSize: CGSize(
                    width: 500.0,
                    height: 50.0
                )
            )
        )

        collectionComponent.setItemComponents(
            [ squareComponent ]
        )

        collectionComponent.render()

        let firstComponent = collectionComponent.itemComponent(
            at: IndexPath(
                item: 0,
                section: 0
            )
        )

        XCTAssert(firstComponent === squareComponent)

    }

}
