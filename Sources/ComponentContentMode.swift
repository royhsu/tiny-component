//
//  ComponentContentMode.swift
//  TinyComponent
//
//  Created by Roy Hsu on 2018/5/25.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - ComponentContentMode

import CoreGraphics

public enum ComponentContentMode {

    case fixed(size: CGSize)

    case automatic(estimatedSize: CGSize)

}

// MARK: - Equatable

extension ComponentContentMode: Equatable {

    public static func == (
        lhs: ComponentContentMode,
        rhs: ComponentContentMode
    )
    -> Bool {

        switch (lhs, rhs) {

        case let (
            .fixed(lhsSize),
            .fixed(rhsSize)
        ): return lhsSize == rhsSize

        case let (
            .automatic(lhsSize),
            .automatic(rhsSize)
        ): return lhsSize == rhsSize

        default: return false

        }

    }

}
