//
//  GradientViewController.swift
//  Examples
//
//  Created by Roy Hsu on 2018/5/26.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - GradientViewController

import TinyComponent

public final class GradientViewController: UIViewController {

    public final let collectionComponent: CollectionComponent = {
        
//        return UIListComponent()
        
        return UICollectionComponent(
            layout: UICollectionViewFlowLayout()
        )
        
    }()

    public final override func loadView() { view = collectionComponent.view }

    public final override func viewDidLoad() {

        super.viewDidLoad()

        let colors = [
            UIColor(
                red: 0.45,
                green: 0.15,
                blue: 0.3,
                alpha: 1.0
            ),
            UIColor(
                red: 0.58,
                green: 0.2,
                blue: 0.34,
                alpha: 1.0
            ),
            UIColor(
                red: 0.65,
                green: 0.23,
                blue: 0.36,
                alpha: 1.0
            ),
            UIColor(
                red: 0.73,
                green: 0.25,
                blue: 0.38,
                alpha: 1.0
            ),
            UIColor(
                red: 0.79,
                green: 0.28,
                blue: 0.4,
                alpha: 1.0
            ),
            UIColor(
                red: 0.8,
                green: 0.35,
                blue: 0.48,
                alpha: 1.0
            ),
            UIColor(
                red: 0.82,
                green: 0.45,
                blue: 0.57,
                alpha: 1.0
            ),
            UIColor(
                red: 0.86,
                green: 0.6,
                blue: 0.69,
                alpha: 1.0
            )
        ]

        let itemComponents = colors.map { color -> Component in

            let view = UIView()

            view.backgroundColor = color

            let itemComponent = UIItemComponent(
                contentMode: .fixed(
                    size: CGSize(
                        width: 100.0,
                        height: 100.0
                    )
                ),
                itemView: view
            )

            return itemComponent

        }

        collectionComponent.setItemComponents(itemComponents)

    }

    public final override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)

        collectionComponent.contentMode = .fixed(size: view.bounds.size)

        collectionComponent.render()

    }

}
