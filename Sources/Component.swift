//
//  Component.swift
//  TinyComponent
//
//  Created by Roy Hsu on 2018/5/25.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - Component

public protocol Component: class, ViewRenderable {

    /// The parent component may override the content mode of its child components.
    var contentMode: ComponentContentMode { get set }

    /// A component should render at least once for showing its content as same as the content changed.
    /// The rendering should only happen on the main thread.
    func render()

}
