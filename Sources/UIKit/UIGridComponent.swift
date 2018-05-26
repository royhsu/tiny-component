//
//  UIGridComponent.swift
//  TinyKit
//
//  Created by Roy Hsu on 2018/4/10.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - UIGridComponent

/// The default implementation of grid layout component.
///
/// The grid component uses the specified columns and rows to calculate the rect for each item component.
/// Please note that the grid component will override the content mode of item components.
///
/// ---------------------------> Column
/// |
/// |  |----------|----------|
/// |  |  Spacing |  Spacing |
/// |  | |------| | |------| |
/// |  | | Item | | | Item | |
/// |  | |------| | |------| |
/// |  |          |          |
/// |  |----------|----------|
/// |  |  Spacing |  Spacing |
/// |  | |------| | |------| |
/// |  | | Item | | | Item | |
/// |  | |------| | |------| |
/// |  |          |          |
/// |  |----------|----------|
/// |
/// v
/// Row
public final class UIGridComponent: CollectionComponent {
    
    /// The base component.
    private final let collectionComponent: UICollectionComponent
    
    private final let collectionViewFlowLayout: UICollectionViewFlowLayout
    
    public final var grid: Grid
    
    public final var interitemSpacing: CGFloat {
        
        get { return collectionViewFlowLayout.minimumInteritemSpacing }
        
        set { collectionViewFlowLayout.minimumInteritemSpacing = newValue }
        
    }
    
    public final var lineSpacing: CGFloat {
        
        get { return collectionViewFlowLayout.minimumLineSpacing }
        
        set { collectionViewFlowLayout.minimumLineSpacing = newValue }
        
    }
    
    public final var scrollDirection: ScrollDirection {
        
        get {
            
            switch collectionViewFlowLayout.scrollDirection {
                
            case .vertical: return .vertical
                
            case .horizontal: return .horizontal
            
            }
            
        }
        
        set {
            
            switch newValue {
                
            case .vertical: collectionViewFlowLayout.scrollDirection = .vertical
                
            case .horizontal: collectionViewFlowLayout.scrollDirection = .horizontal
                
            }
            
        }
        
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
        
        self.grid = Grid(
            columns: 1,
            rows: 1
        )
        
        self.prepare()
        
    }
    
    // MARK: Set Up
    
    fileprivate final func prepare() {
        
        collectionViewFlowLayout.minimumInteritemSpacing = 0.0
        
        collectionViewFlowLayout.minimumLineSpacing = 0.0
        
        collectionViewFlowLayout.scrollDirection = .vertical
        
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
        
        collectionComponent.setItemComponent { [unowned self] component, indexPath in
            
            let safeAreaRect = self.collectionComponent.collectionView.safeAreaRect
            
            let columns = self.grid.columns
            
            let rows = self.grid.rows
            
            let interitemSpacing = self.interitemSpacing
            
            let lineSpacing = self.lineSpacing
            
            let itemComponent = provider(
                component,
                indexPath
            )
            
            let gridSize: CGSize
            
            switch self.scrollDirection {
                
            case .vertical:
                
                var spacingOfInteritems = CGFloat(columns - 1) * interitemSpacing
                
                if spacingOfInteritems < 0.0 { spacingOfInteritems = 0.0 }
                
                var spacingOfLines = CGFloat(rows - 1) * lineSpacing
                
                if spacingOfLines < 0.0 { spacingOfLines = 0.0 }
                
                gridSize = CGSize(
                    width: (safeAreaRect.width - spacingOfInteritems) / CGFloat(columns),
                    height: (safeAreaRect.height - spacingOfLines) / CGFloat(rows)
                )
                
            case .horizontal:
                
                var spacingOfInteritems = CGFloat(rows - 1) * interitemSpacing
                
                if spacingOfInteritems < 0.0 { spacingOfInteritems = 0.0 }
                
                var spacingOfLines = CGFloat(columns - 1) * lineSpacing
                
                if spacingOfLines < 0.0 { spacingOfLines = 0.0 }
                
                gridSize = CGSize(
                    width: (safeAreaRect.width - spacingOfLines) / CGFloat(columns),
                    height: (safeAreaRect.height - spacingOfInteritems) / CGFloat(rows)
                )
                
            }
            
            itemComponent.contentMode = .fixed(size: gridSize)
            
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
    
    public final var preferredContentSize: CGSize { return  collectionComponent.preferredContentSize }
    
}

public extension UIGridComponent {
    
    public final var collectionView: UICollectionView { return collectionComponent.collectionView }
    
}
