//
//  ListComponent.swift
//  TinyComponent
//
//  Created by Roy Hsu on 23/03/2018.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - ListComponent

/// Grouping a collection of item components with the list layout.
public protocol ListComponent: CollectionComponent {

    var headerComponent: Component? { get set }

    var footerComponent: Component? { get set }

}
