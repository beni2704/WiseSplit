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
        // Override point for customization after application launch.
        FirebaseApp.configure()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .black
        let navigationController: UINavigationController?
        if Auth.auth().currentUser != nil {
            navigationController = UINavigationController(rootViewController: HomeViewController())
        } else {
            navigationController = UINavigationController(rootViewController: LoginViewController())
        }
        window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        return true
    }
}

