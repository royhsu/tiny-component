//
//  UIImage+UIColor.swift
//  TinyComponent iOS
//
//  Created by Roy Hsu on 2018/6/19.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - UIColor

import UIKit

internal extension UIImage {

    internal static func image(
        color: UIColor,
        size: CGSize
    )
    -> UIImage? {

        UIGraphicsBeginImageContext(size)

        let context = UIGraphicsGetCurrentContext()!

        context.setFillColor(color.cgColor)

        context.fill(
            CGRect(
                origin: .zero,
                size: size
            )
        )

        let image = UIGraphicsGetImageFromCurrentImageContext()!

        UIGraphicsEndImageContext()

        return image

    }

}
