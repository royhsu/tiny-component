//
//  ViewRenderable.swift
//  TinyComponent
//
//  Created by Roy Hsu on 2018/5/25.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - ViewRenderable

import CoreGraphics

public protocol ViewRenderable {

    var view: View { get }

    var preferredContentSize: CGSize { get }

}
