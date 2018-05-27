//
//  UITableViewBridge.swift
//  TinyComponent
//
//  Created by Roy Hsu on 18/03/2018.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - UITableViewBridge

import UIKit

internal final class UITableViewBridge: NSObject {

    private final unowned let tableView: UITableView

    internal init(tableView: UITableView) {

        self.numberOfSections = 0

        self.numberOfRowsProvider = { _ in 0 }

        self.heightForRowProvider = { _ in 0.0 }

        self.tableView = tableView

        super.init()

        setUpTableView(tableView)

    }

    // MARK: Set Up

    private final func setUpTableView(_ tableView: UITableView) {

        tableView.separatorStyle = .none

        tableView.dataSource = self

        tableView.delegate = self

    }

    internal final var numberOfSections: Int

    internal typealias NumberOfRowsProvider = (_ section: Int) -> Int

    internal final var numberOfRowsProvider: NumberOfRowsProvider

    internal typealias HeightForRowProvider = (IndexPath) -> CGFloat

    internal final var heightForRowProvider: HeightForRowProvider

    internal typealias ConfigureCellHandler = (UITableViewCell, IndexPath) -> Void

    internal final var configureCellHandler: ConfigureCellHandler?

}

// MARK: - UITableViewDataSource

extension UITableViewBridge: UITableViewDataSource {

    internal final func numberOfSections(in tableView: UITableView) -> Int { return numberOfSections }

    internal final func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    )
    -> Int { return numberOfRowsProvider(section) }

    internal final func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    )
    -> UITableViewCell {

        // NOTE: DONNOT use reusable cells because they contain the incorrect height information while dequeued.
        let cell = UITableViewCell(
            style: .default,
            reuseIdentifier: nil
        )

        cell.selectionStyle = .none

        cell.backgroundColor = .clear

        configureCellHandler?(
            cell,
            indexPath
        )

        return cell

    }

}

// MARK: - UITableViewDelegate

extension UITableViewBridge: UITableViewDelegate {

    internal final func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    )
    -> CGFloat { return heightForRowProvider(indexPath) }

}
