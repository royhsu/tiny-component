//
//  UICarouselComponentTests.swift
//  TinyComponentTests
//
//  Created by Roy Hsu on 2018/6/27.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - UICarouselComponentTests

import XCTest

@testable import TinyComponent

internal final class UICarouselComponentTests: XCTestCase {
    
    internal final func testInitialize() {
        
        let carouselComponent = UICarouselComponent()
        
        XCTAssertEqual(
            carouselComponent.contentMode,
            .automatic(estimatedSize: .zero)
        )
        
        XCTAssertEqual(
            carouselComponent.view.frame,
            .zero
        )
        
        XCTAssertEqual(
            carouselComponent.view.backgroundColor,
            .clear
        )
        
        XCTAssertEqual(
            carouselComponent.numberOfSections,
            1
        )
        
    }
    
    internal final func testRenderWithContentModeAutomatic() {
        
        let text = "Maecenas."
        
        let label = UILabel()
        
        label.numberOfLines = 1
        
        label.text = text
        
        let labelComponent = UIItemComponent(itemView: label)
        
        let carouselComponent = UICarouselComponent(
            contentMode: .automatic(
                estimatedSize: CGSize(
                    width: 500.0,
                    height: 100.0
                )
            )
        )
        
        let expectedLabelSize = text.size(
            withAttributes: [ .font: label.font ]
        )
        
        labelComponent.contentMode = .automatic(estimatedSize: expectedLabelSize)
        
        carouselComponent.setItemComponents(
            [ labelComponent ]
        )
        
        carouselComponent.render()
        
        XCTAssertEqual(
            carouselComponent.preferredContentSize.width,
            500.0,
            accuracy: .greatestFiniteMagnitude
        )
        
        XCTAssertEqual(
            carouselComponent.preferredContentSize.height,
            100.0,
            accuracy: .greatestFiniteMagnitude
        )
        
        XCTAssertEqual(
            carouselComponent.preferredContentSize,
            carouselComponent.view.frame.size
        )
        
        let firstItemComponent = carouselComponent.itemComponent(
            at: IndexPath(
                row: 0,
                section: 0
            )
        )
        
        XCTAssertEqual(
            firstItemComponent.contentMode,
            .automatic(
                estimatedSize: CGSize(
                    width: expectedLabelSize.width,
                    height: 100.0
                )
            )
        )
        
        XCTAssertEqual(
            firstItemComponent.preferredContentSize.width,
            expectedLabelSize.width,
            accuracy: .greatestFiniteMagnitude
        )
        
        XCTAssertEqual(
            firstItemComponent.preferredContentSize.height,
            100.0,
            accuracy: .greatestFiniteMagnitude
        )
        
    }
    
}
