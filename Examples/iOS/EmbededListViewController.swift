//
//  EmbededListViewController.swift
//  iOS Example
//
//  Created by Roy Hsu on 2018/6/28.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - EmbededListViewController

import UIKit
import TinyComponent

public final class EmbededListViewController: UIViewController {
    
    private final let rootComponent: Component = {
        
        let listComponent = UIListComponent()
        
        listComponent.setItemComponents(
            [ makeContentComponent() ]
        )
        
        return listComponent
        
    }()
    
    public final override func loadView() { view = rootComponent.view }
    
    public final override func viewDidLoad() {
        
        super.viewDidLoad()
        
        rootComponent.view.backgroundColor = .white
        
    }
    
    public final override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        rootComponent.contentMode = .fixed(size: view.bounds.size)
        
        rootComponent.render()
        
    }
    
}

private func makeTextComponent(text: String) -> Component {

    let label = UILabel()
    
    label.numberOfLines = 0
    
    label.text = text

    let itemComponent = UIItemComponent(itemView: label)

    return itemComponent
    
}

private func makeContentComponent() -> Component {
    
    let listComponent = UIListComponent()
    
    listComponent.setItemComponents(
        [
            makeTextComponent(text: "Vivamus sagittis lacus vel augue laoreet rutrum faucibus dolor auctor. Integer posuere erat a ante venenatis dapibus posuere velit aliquet."),
            makeTextComponent(text: "Curabitur blandit tempus porttitor. Donec sed odio dui. Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum.")
        ]
    )
    
    return listComponent
    
}
