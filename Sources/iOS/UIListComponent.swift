//
//  UIListComponent.swift
//  TinyComponent
//
//  Created by Roy Hsu on 23/03/2018.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - UIListComponent

import UIKit

/// The default implementation of list layout component.
///
/// The list component uses the specified width in the content mode to calculate the rect of each associated components including item, header and footer components.
/// Please note that the list component will override the associated size of content mode of child components to make the width fitting its boundary during the rendering. But the height of child components will remain the same.
public final class UIListComponent: ListComponent {

    internal final let tableView: UITableView

    fileprivate final let bridge: UITableViewBridge

    fileprivate final let tableViewWidthConstraint: NSLayoutConstraint

    fileprivate final let tableViewHeightConstraint: NSLayoutConstraint

    // Note: DO NOT get an item component from the map directly, please use itemComponent(at:) instead.
    internal final var itemComponentCache: [IndexPath: Component]

    /// - Parameters:
    ///   - contentMode: The default mode is .automatic with zero value of estimated size. This will prevent the list rendering with empty content. Please make sure to give a non-zero size for the list to properly render its content.
    public init(
        contentMode: ComponentContentMode = .automatic(estimatedSize: .zero)
    ) {

        self.contentMode = contentMode

        self.tableView = UITableView(
            frame: .zero,
            style: .plain
        )

        self.bridge = UITableViewBridge(tableView: tableView)

        self.tableViewWidthConstraint = tableView.heightAnchor.constraint(equalToConstant: tableView.bounds.height)

        self.tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: tableView.bounds.height)

        self.itemComponentCache = [:]

        self.prepare()

    }

    // MARK: Set Up

    fileprivate final func prepare() {

        prepareLayout()

        tableView.backgroundColor = .clear

        tableView.clipsToBounds = false

        tableView.estimatedRowHeight = 0.0

        bridge.configureCellHandler = { [unowned self] cell, indexPath in

            let component = self.itemComponent(at: indexPath)

            cell.contentView.frame.size = component.preferredContentSize

            cell.frame.size = cell.contentView.frame.size

            cell.contentView.wrapSubview(component.view)

        }

        bridge.heightForRowProvider = { [unowned self] indexPath in

            let initialSize: CGSize

            switch self.contentMode {

            case let .fixed(size): initialSize = size

            case let .automatic(estimatedSize): initialSize = estimatedSize

            }

            let itemComponent = self.itemComponent(at: indexPath)

            switch itemComponent.contentMode {

            case let .fixed(size):

                itemComponent.contentMode = .fixed(
                    size: CGSize(
                        width: initialSize.width,
                        height: size.height
                    )
                )

            case let .automatic(estimatedSize):

                itemComponent.contentMode = .automatic(
                    estimatedSize: CGSize(
                        width: initialSize.width,
                        height: estimatedSize.height
                    )
                )

            }

            itemComponent.render()

            return itemComponent.preferredContentSize.height

        }

    }

    fileprivate final func prepareLayout() {

        tableViewWidthConstraint.priority = .defaultHigh

        tableViewHeightConstraint.priority = .defaultHigh

        let initialSize: CGSize

        switch contentMode {

        case let .fixed(size): initialSize = size

        case let .automatic(estimatedSize): initialSize = estimatedSize

        }

        tableView.frame.size = initialSize

    }

    // MARK: ListComponent

    public final var headerComponent: Component?

    public final var footerComponent: Component?

    // MARK: CollectionComponent

    public final var numberOfSections: Int {

        get { return bridge.numberOfSections }

        set { bridge.numberOfSections = newValue }

    }

    public final func numberOfItemComponents(inSection section: Int) -> Int { return bridge.numberOfRowsProvider(section) }

    public final func setNumberOfItemComponents(provider: @escaping NumberOfItemComponentsProvider) {

        bridge.numberOfRowsProvider = { [unowned self] section in

            return provider(
                self,
                section
            )

        }

    }

    public final func itemComponent(at indexPath: IndexPath) -> Component {

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

    public final func setItemComponent(provider: @escaping ItemComponentProvider) { itemComponentProvider = provider }

    // MARK: Component

    public final var contentMode: ComponentContentMode

    public final func render() {

        itemComponentCache = [:]

        renderLayout()

    }

    fileprivate final func renderLayout() {

        let tableViewConstraints = [
            tableViewWidthConstraint,
            tableViewHeightConstraint
        ]

        NSLayoutConstraint.deactivate(tableViewConstraints)

        tableView.estimatedRowHeight = 0.0

        switch contentMode {

        case let .fixed(size):

            tableView.frame.size = size

            renderHeaderComponent(size: size)

            renderFooterComponent(size: size)

            tableView.tableHeaderView = headerComponent?.view

            tableView.tableFooterView = footerComponent?.view

            tableView.reloadData()

        case let .automatic(estimatedSize):

            tableView.frame.size = estimatedSize

            renderHeaderComponent(size: estimatedSize)

            renderFooterComponent(size: estimatedSize)

            tableView.tableHeaderView = headerComponent?.view

            tableView.tableFooterView = footerComponent?.view

            tableView.reloadData()

            tableView.layoutIfNeeded()

            tableView.frame.size = tableView.contentSize

        }

        tableViewWidthConstraint.constant = tableView.frame.width

        tableViewHeightConstraint.constant = tableView.frame.height

        NSLayoutConstraint.activate(tableViewConstraints)

    }

    fileprivate final func renderHeaderComponent(size: CGSize) {

        guard
            let component = headerComponent
        else { return }

        let height: CGFloat

        switch component.contentMode {

        case let .fixed(size): height = size.height

        case let .automatic(estimatedSize): height = estimatedSize.height

        }

        component.contentMode = .automatic(
            estimatedSize: CGSize(
                width: size.width,
                height: height
            )
        )

        component.render()

    }

    fileprivate final func renderFooterComponent(size: CGSize) {

        guard
            let component = footerComponent
        else { return }

        let height: CGFloat

        switch component.contentMode {

        case let .fixed(size): height = size.height

        case let .automatic(estimatedSize): height = estimatedSize.height

        }

        component.contentMode = .automatic(
            estimatedSize: CGSize(
                width: size.width,
                height: height
            )
        )

        component.render()

    }

    // MARK: ViewRenderable

    public final var view: View { return tableView }

    public final var preferredContentSize: CGSize { return tableView.bounds.size }

}
