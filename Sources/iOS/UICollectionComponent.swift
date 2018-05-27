//
//  UICollectionComponent.swift
//  TinyComponent
//
//  Created by Roy Hsu on 18/03/2018.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - UICollectionComponent

import UIKit

/// The default implementation of collection layout component.
///
/// The collection component needs a dedicated layout to render the item components.
/// The collection component overrides the content mode for each item component to fit the size calculated by the layout during the rendering.
///
/// Please make sure to give a non-zero size for the list to properly render its content.
internal final class UICollectionComponent: CollectionComponent {

    internal final let collectionView: UICollectionView

    internal final let collectionViewLayout: UICollectionViewLayout

    fileprivate final let bridge: UICollectionViewBridge

    fileprivate final let collectionViewWidthConstraint: NSLayoutConstraint

    fileprivate final let collectionViewHeightConstraint: NSLayoutConstraint

    // DO NOT get an item component from the map directly, please use itemComponent(at:) instead.
    internal final var itemComponentCache: [IndexPath: Component]

    internal final func sizeForItem(at indexPath: IndexPath) -> CGSize {

        return bridge.sizeForItemProvider(
            collectionViewLayout,
            indexPath
        )

    }

    /// - Parameters:
    ///   - contentMode: The default mode is .automatic with zero value of estimated size. This will prevent the list rendering with empty content. Please make sure to give a non-zero size for the list to properly render its content.
    ///   - layout: The collection view layout.
    internal init(
        contentMode: ComponentContentMode = .automatic(estimatedSize: .zero),
        layout: UICollectionViewLayout
    ) {

        self.contentMode = contentMode

        self.collectionViewLayout = layout

        self.collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: collectionViewLayout
        )

        self.bridge = UICollectionViewBridge(collectionView: collectionView)

        self.collectionViewWidthConstraint = collectionView.heightAnchor.constraint(equalToConstant: collectionView.bounds.width)

        self.collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: collectionView.bounds.height)

        self.itemComponentCache = [:]

        self.prepare()

    }

    // MARK: Set Up

    fileprivate final func prepare() {

        prepareLayout()

        collectionView.backgroundColor = .clear

        collectionView.clipsToBounds = false

        bridge.configureCellHandler = { [unowned self] cell, indexPath in

            let component = self.itemComponent(at: indexPath)

            cell.contentView.frame.size = component.preferredContentSize

            cell.frame.size = cell.contentView.frame.size

            cell.contentView.wrapSubview(component.view)

        }

        bridge.sizeForItemProvider = { [unowned self] layout, indexPath in

            let component = self.itemComponent(at: indexPath)

            component.render()

            return component.preferredContentSize

        }

    }

    fileprivate final func prepareLayout() {

        collectionViewWidthConstraint.priority = .defaultHigh

        collectionViewHeightConstraint.priority = .defaultHigh

        let initialSize: CGSize

        switch contentMode {

        case let .fixed(size): initialSize = size

        case let .automatic(estimatedSize): initialSize = estimatedSize

        }

        collectionView.frame.size = initialSize

    }

    // MARK: CollectionComponent

    internal final var numberOfSections: Int {

        get { return bridge.numberOfSections }

        set { bridge.numberOfSections = newValue }

    }

    internal final func numberOfItemComponents(inSection section: Int) -> Int { return bridge.numberOfItemsProvider(section) }

    internal final func setNumberOfItemComponents(provider: @escaping NumberOfItemComponentsProvider) {

        bridge.numberOfItemsProvider = { [unowned self] section in

            return provider(
                self,
                section
            )

        }

    }

    internal final func itemComponent(at indexPath: IndexPath) -> Component {

        if let provider = itemComponentCache[indexPath] { return provider }
        else {

            guard
                let provider = itemComponentProvider
            else { fatalError("Please make sure to set the provider with setItemComponent(provider:) firstly.") }

            let itemComponent = provider(
                self,
                indexPath
            )

            itemComponentCache[indexPath] = itemComponent

            return itemComponent

        }

    }

    private final var itemComponentProvider: ItemComponentProvider?

    internal final func setItemComponent(provider: @escaping ItemComponentProvider) { itemComponentProvider = provider }

    // MARK: Component

    internal final var contentMode: ComponentContentMode

    internal final func render() {

        itemComponentCache = [:]

        renderLayout()

    }

    fileprivate final func renderLayout() {

        let collectionViewConstraints = [
            collectionViewWidthConstraint,
            collectionViewHeightConstraint
        ]

        NSLayoutConstraint.deactivate(collectionViewConstraints)

        collectionViewLayout.invalidateLayout()

        switch contentMode {

        case let .fixed(size):

            collectionView.frame.size = size

            collectionView.reloadData()

        case let .automatic(estimatedSize):

            collectionView.frame.size = estimatedSize

            collectionView.reloadData()

            /// Reference: https://stackoverflow.com/questions/22861804/uicollectionview-cellforitematindexpath-is-nil
            collectionView.layoutIfNeeded()

            collectionView.frame.size.height = collectionViewLayout.collectionViewContentSize.height

        }

        collectionViewWidthConstraint.constant = collectionView.frame.width

        collectionViewHeightConstraint.constant = collectionView.frame.height

        NSLayoutConstraint.activate(collectionViewConstraints)

    }

    // MARK: ViewRenderable

    internal final var view: View { return collectionView }

    internal final var preferredContentSize: CGSize { return collectionView.bounds.size }

}
