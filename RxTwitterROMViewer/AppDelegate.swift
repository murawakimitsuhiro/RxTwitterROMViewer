//
//  AppDelegate.swift
//  RxTwitterROMViewer
//
//  Created by 村脇光洋 on 2019/06/19.
//  Copyright © 2019 murawaki. All rights reserved.
//

import UIKit

import TwitterKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        TWTRTwitter.sharedInstance().start(withConsumerKey: "0sZ5C9fiDcgnrEtkFNd4941gD", consumerSecret: "I8x8GA1ESAW2cvDqE7lFJ6smmxQ0xBPgqy4dlJGBGdRbBPLbHm")
        
        let authUseCase = AuthUseCase(twitterAuthRepository: TwitterNetwork())
        if authUseCase.hasLoginUser() {
            let timelineVC = TimelineViewController()
            let navC = UINavigationController(navigationBarClass: TwitterNavigationBar.self, toolbarClass: UIToolbar.self)
            navC.setViewControllers([timelineVC], animated: false)
            initWindow(rootViewController: navC)
        } else {
            let loginVC = LoginViewController()
            initWindow(rootViewController: loginVC)
        }
        
        return true
    }
    
    private func initWindow(rootViewController: UIViewController) {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = rootViewController
    }
  
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return TWTRTwitter.sharedInstance().application(app, open: url, options: options)
    }

    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {}

    func applicationWillTerminate(_ application: UIApplication) {}
}

