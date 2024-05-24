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
        window?.backgroundColor = .white
        let navigationController: UINavigationController?
        if Auth.auth().currentUser != nil {
            navigationController = UINavigationController(rootViewController: TabBarController())
        } else {
            navigationController = UINavigationController(rootViewController: LoginViewController())
        }
        //        navigationController = UINavigationController(rootViewController: TabBarController())
        window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if let incomingURL = userActivity.webpageURL {
            let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { (dynamicLink, error) in
                if let dynamicLink = dynamicLink, let url = dynamicLink.url {
                    self.handleIncomingLink(url: url)
                }
            }
            return linkHandled
        }
        return false
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
            if let url = dynamicLink.url {
                self.handleIncomingLink(url: url)
            }
            return true
        }
        return false
    }
    
    private func handleIncomingLink(url: URL) {
        UserDefaults.standard.set(url.absoluteString, forKey: "Link")
        
        // Ensure the app's root view controller is the login screen if the user is not logged in
        guard let navigationController = window?.rootViewController as? UINavigationController else {
            return
        }
        
        if let loginViewController = navigationController.viewControllers.first(where: { $0 is LoginViewController }) as? LoginViewController {
            loginViewController.loginVM?.handleSignInLink { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        loginViewController.navigateToHome()
                    case .failure(let error):
                        loginViewController.showErrorMessage(error.localizedDescription)
                    }
                }
            }
        } else {
            let loginViewController = LoginViewController()
            navigationController.setViewControllers([loginViewController], animated: true)
            loginViewController.loginVM?.handleSignInLink { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        loginViewController.navigateToHome()
                    case .failure(let error):
                        loginViewController.showErrorMessage(error.localizedDescription)
                    }
                }
            }
        }
    }
}

