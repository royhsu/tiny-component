//
//  UICollectionViewBridge.swift
//  TinyComponent
//
//  Created by Roy Hsu on 18/03/2018.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - UICollectionViewBridge

import UIKit

internal final class UICollectionViewBridge: NSObject {

    private final unowned let collectionView: UICollectionView

    private final let cellIdentifier = "UICollectionViewCell"

    internal init(collectionView: UICollectionView) {

        self.numberOfSections = 0

        self.numberOfItemsProvider = { _ in 0 }

        self.sizeForItemProvider = { _, _ in .zero }

        self.collectionView = collectionView

        super.init()

        setUpCollectionView(collectionView)

    }

    // MARK: Set Up

    fileprivate final func setUpCollectionView(_ collectionView: UICollectionView) {

        collectionView.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: cellIdentifier
        )

        collectionView.dataSource = self

        collectionView.delegate = self

    }

    internal final var numberOfSections: Int

    internal typealias NumberOfItemsProvider = (_ section: Int) -> Int

    internal final var numberOfItemsProvider: NumberOfItemsProvider

    internal typealias ConfigureCellHandler = (UICollectionViewCell, IndexPath) -> Void

    internal final var configureCellHandler: ConfigureCellHandler?

    internal typealias SizeForItemProvider = (UICollectionViewLayout, IndexPath) -> CGSize

    internal final var sizeForItemProvider: SizeForItemProvider

}

// MARK: - UICollectionViewDataSource

extension UICollectionViewBridge: UICollectionViewDataSource {

    internal final func numberOfSections(in collectionView: UICollectionView) -> Int { return numberOfSections }

    internal final func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    )
    -> Int { return numberOfItemsProvider(section) }

    internal final func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    )
    -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellIdentifier,
            for: indexPath
        )

        cell.contentView.subviews.forEach { $0.removeFromSuperview() }

        configureCellHandler?(
            cell,
            indexPath
        )

        return cell

    }

}

// MARK: - UICollectionViewDelegateFlowLayout

extension UICollectionViewBridge: UICollectionViewDelegateFlowLayout {

    internal final func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    )
    -> CGSize {

        return sizeForItemProvider(
            collectionViewLayout,
            indexPath
        )

    }

}
