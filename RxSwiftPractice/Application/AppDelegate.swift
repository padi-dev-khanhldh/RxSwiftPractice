//
//  AppDelegate.swift
//  RxSwiftPractice
//
//  Created by Admin on 3/28/23.
//

import UIKit
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        configureInitialViewController()
        return true
    }
    
    private func configureInitialViewController() {
        window = UIWindow()
        GIDSignIn.sharedInstance.restorePreviousSignIn { [weak self] user, error in
            var initialViewController: UIViewController
            if error != nil || user == nil {
                let storyboard = UIStoryboard(name: "Login", bundle: nil)
                let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginVC")
                let nav = UINavigationController(rootViewController: loginViewController)
                initialViewController = nav
            } else {
                print("Signed in")
                let storyboard = UIStoryboard(name: "Home", bundle: nil)
                let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeVC")
                let nav = UINavigationController(rootViewController: homeViewController)
                initialViewController = nav
            }
            self?.window?.rootViewController = initialViewController
            self?.window?.makeKeyAndVisible()
        }
    }
    
    func application(
        _ app: UIApplication,
        open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        var handled: Bool
        
        handled = GIDSignIn.sharedInstance.handle(url)
        if handled {
            return true
        }
        
        // Handle other custom URL types.
        
        // If not handled by this app, return false.
        return false
    }
}

