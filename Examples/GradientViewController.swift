//
//  GradientViewController.swift
//  Examples
//
//  Created by Roy Hsu on 2018/5/26.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - GradientViewController

import TinyComponent
import UIKit

public final class GradientViewController: UIViewController {

    public final let listComponnt = UIListComponent()

    public final override func loadView() { view = listComponnt.view }

    public final override func viewDidLoad() {

        super.viewDidLoad()

        let gridComponent = UIGridComponent(
            contentMode: .fixed(
                size: CGSize(
                    width: 300.0,
                    height: 300.0
                )
            )
        )

        gridComponent.grid = Grid(
            columns: 2,
            rows: 3
        )

        gridComponent.scrollDirection = .horizontal

        gridComponent.setItemComponents(
            DynamicGradient
                .utralVoilet
                .colorPalette(amount: 12)
                .map(makeComponent)
        )

        let carouselComponent = UICarouselComponent(
            contentMode: .fixed(
                size: CGSize(
                    width: 100.0,
                    height: 100.0
                )
            )
        )

        carouselComponent.setItemComponents(
            DynamicGradient
                .mojito
                .colorPalette(amount: 10)
                .map(makeComponent)
        )

        listComponnt.headerComponent = gridComponent

        listComponnt.setItemComponents(
            DynamicGradient
                .kyoto
                .colorPalette(amount: 5)
                .map(makeComponent)
        )

        listComponnt.footerComponent = carouselComponent

    }

    public final override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)

        listComponnt.contentMode = .fixed(size: view.bounds.size)

        listComponnt.render()

    }

    internal final func makeComponent(with color: DynamicColor) -> Component {

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

}
