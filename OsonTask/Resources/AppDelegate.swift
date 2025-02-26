//
//  AppDelegate.swift
//  OsonTask
//
//  Created by Abdulloh Murodilloyev on 26/02/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setupMainWindow()
        return true
    }
    
    private func setupMainWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.overrideUserInterfaceStyle = .light
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
    }
}

