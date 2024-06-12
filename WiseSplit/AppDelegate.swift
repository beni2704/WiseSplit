//
//  AppDelegate.swift
//  WiseSplit
//
//  Created by beni garcia on 11/03/24.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController: UINavigationController?
        if Auth.auth().currentUser != nil {
            navigationController = UINavigationController(rootViewController: TabBarController())
        } else {
            navigationController = UINavigationController(rootViewController: LoginViewController())
        }
        window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        
        let theme = UserDefaults.standard.string(forKey: "Theme") ?? "light"
        
        window?.backgroundColor = Colors.backgroundColorCustom
        if theme == "dark" {
            window?.overrideUserInterfaceStyle = .dark
        } else {
            window?.overrideUserInterfaceStyle = .light
        }
        
        return true
    }
}

