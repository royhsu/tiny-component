//
//  UICarouselComponent.swift
//  TinyComponent
//
//  Created by Roy Hsu on 03/03/2018.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - UICarouselComponent

/// All items in a carousel component will be stretch out their height to fit the parent.
public final class UICarouselComponent: CollectionComponent {

    /// The base component.
    private final let collectionComponent: UICollectionComponent

    private final let collectionViewFlowLayout: UICollectionViewFlowLayout
    
    public final var interitemSpacing: CGFloat {
        
        get { return collectionViewFlowLayout.minimumLineSpacing }
        
        set { collectionViewFlowLayout.minimumLineSpacing = newValue }
        
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
    
    fileprivate final func prepare() { }

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
        
            let itemComponent = provider(
                self,
                indexPath
            )
            
            return itemComponent
            
        }
        
    }
    
    // MARK: Component

    public final var contentMode: ComponentContentMode {

        get { return collectionComponent.contentMode }

        set { collectionComponent.contentMode = newValue }

    }

    public final func render() { collectionComponent.render() }

    // MARK: ViewRenderable

    public final var view: View { return collectionComponent.view }

    public final var preferredContentSize: CGSize { return collectionComponent.preferredContentSize }

}
