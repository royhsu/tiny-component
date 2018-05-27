//
//  UICollectionView+SafeAreaRect.swift
//  TinyComponent
//
//  Created by Roy Hsu on 2018/4/10.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - Safe Area Rect

import UIKit

public extension UICollectionView {

    public final var safeAreaRect: CGRect {

        // swiftlint:disable identifier_name
        let x = contentInset.left + safeAreaInsets.left

        let y = contentInset.top + safeAreaInsets.top
        // swiftlint:enable identifier_name

        var width = bounds.width
            - x
            - contentInset.right
            - safeAreaInsets.right

        if width < 0.0 { width = 0.0 }

        var height = bounds.height
            - y
            - contentInset.bottom
            - safeAreaInsets.bottom

        if height < 0.0 { height = 0.0 }

        return CGRect(
            x: x,
            y: y,
            width: width,
            height: height
        )

    }

}
