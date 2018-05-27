//
//  UICarouselComponent.swift
//  TinyComponent
//
//  Created by Roy Hsu on 03/03/2018.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - UICarouselComponent

import UIKit

/// The default implementation of carousel layout component.
///
/// Please note that the carousel component will override the content mode of item components by stretching the height of them to fit the parent.
public final class UICarouselComponent: CollectionComponent {

    /// The base component.
    private final let collectionComponent: UICollectionComponent

    private final var collectionView: UICollectionView { return collectionComponent.collectionView }

    private final let collectionViewFlowLayout: UICollectionViewFlowLayout

    public final var interitemSpacing: CGFloat {

        get { return collectionViewFlowLayout.minimumLineSpacing }

        set { collectionViewFlowLayout.minimumLineSpacing = newValue }

    }

    public final var showsVerticalScrollIndicator: Bool {

        get { return collectionView.showsVerticalScrollIndicator }

        set { collectionView.showsVerticalScrollIndicator = newValue }

    }

    public final var showsHorizontalScrollIndicator: Bool {

        get { return collectionView.showsHorizontalScrollIndicator }

        set { collectionView.showsHorizontalScrollIndicator = newValue }

    }

    /// - Parameters:
    ///   - contentMode: The default mode is .automatic with zero value of estimated size. This will prevent the list rendering with empty content. Please make sure to give a non-zero size for the list to properly render its content.
    public init(
        contentMode: ComponentContentMode = .automatic(estimatedSize: .zero)
    ) {

        self.collectionViewFlowLayout = UICollectionViewFlowLayout()

        self.collectionComponent = UICollectionComponent(
            contentMode: contentMode,
            layout: collectionViewFlowLayout
        )

        self.prepare()

    }

    // MARK: Set Up

    fileprivate final func prepare() {

        collectionViewFlowLayout.minimumInteritemSpacing = 0.0

        collectionViewFlowLayout.minimumLineSpacing = 0.0

        collectionViewFlowLayout.scrollDirection = .horizontal

        collectionViewFlowLayout.headerReferenceSize = .zero

        collectionViewFlowLayout.footerReferenceSize = .zero

        collectionViewFlowLayout.sectionInset = .zero

    }

    // MARK: CollectionComponent

    public final var numberOfSections: Int {

        get { return collectionComponent.numberOfSections }

        set { collectionComponent.numberOfSections = newValue }

    }

    public final func numberOfItemComponents(inSection section: Int) -> Int { return collectionComponent.numberOfItemComponents(inSection: section) }

    public final func setNumberOfItemComponents(provider: @escaping NumberOfItemComponentsProvider) { collectionComponent.setNumberOfItemComponents(provider: provider) }

    public final func itemComponent(at indexPath: IndexPath) -> Component { return collectionComponent.itemComponent(at: indexPath) }

    public final func setItemComponent(provider: @escaping ItemComponentProvider) {

        collectionComponent.setItemComponent { [unowned self] _, indexPath in

            let safeAreaRect = self.collectionView.safeAreaRect

            let itemComponent = provider(
                self,
                indexPath
            )

            let itemSize: CGSize

            switch itemComponent.contentMode {

            case let .fixed(size):

                itemSize = CGSize(
                    width: size.width,
                    height: safeAreaRect.height
                )

            case let .automatic(estimatedSize):

                itemSize = CGSize(
                    width: estimatedSize.width,
                    height: safeAreaRect.height
                )
            }

            itemComponent.contentMode = .fixed(size: itemSize)

            return itemComponent

        }

    }

    // MARK: Component

    public final var contentMode: ComponentContentMode {

        get { return collectionComponent.contentMode }

        set { collectionComponent.contentMode = newValue }

    }

    public final func render() {

        let initialSize: CGSize

        switch contentMode {

        case let .fixed(size): initialSize = size

        case let .automatic(estimatedSize): initialSize = estimatedSize

        }

        collectionView.frame.size = initialSize

        collectionComponent.render()

    }

    // MARK: ViewRenderable

    public final var view: View { return collectionComponent.view }

    public final var preferredContentSize: CGSize { return collectionComponent.preferredContentSize }

}
