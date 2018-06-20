//
//  ImageListViewController.swift
//  iOS Example
//
//  Created by Roy Hsu on 2018/6/19.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - ImageListViewController

import TinyComponent
import UIKit

public final class ImageListViewController: UIViewController {

    private final let listComponent = UIListComponent()

    private final lazy var imageComponent: Component = {

        let image = UIImage.image(
            color: .red,
            size: CGSize(
                width: 200.0,
                height: 200.0
            )
        )

        let imageView = UIImageView(image: image)

        imageView.contentMode = .scaleAspectFill

        return UIItemComponent(itemView: imageView)

    }()

    public final override func loadView() { view = listComponent.view }

    public final override func viewDidLoad() {

        super.viewDidLoad()

        listComponent.setItemComponents(
            [ imageComponent ]
        )

    }

    public final override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)

        listComponent.contentMode = .fixed(size: view.bounds.size)

        listComponent.render()

    }

}
