//
//  AppDelegate.swift
//  Examples
//
//  Created by Roy Hsu on 2018/5/26.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - AppDelegate

import UIKit

@UIApplicationMain
public final class AppDelegate: UIResponder {

    public final let window = UIWindow(frame: UIScreen.main.bounds)

}

// MARK: - UIApplicationDelegate

extension AppDelegate: UIApplicationDelegate {

    public final func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
    )
    -> Bool {

        window.rootViewController = UINavigationController(
            rootViewController: GradientViewController()
        )

        window.makeKeyAndVisible()

        return true

    }

}
