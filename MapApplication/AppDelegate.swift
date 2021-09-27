//
//  AppDelegate.swift
//  MapApplication
//
//  Created by Akbar on 27/09/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        initApplication()
        return true
    }

    private func initApplication() {
        let vc = MainViewController()
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
    }


}

