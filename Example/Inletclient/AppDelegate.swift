//
//  AppDelegate.swift
//  Inletclient
//
//  Created by localparty on 12/21/2018.
//  Copyright (c) 2018 localparty. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func debugBundle(){
        enum Endpoint {
            case endpoint
            var localResource: String {
                return "discovery-consent"
            }
            var localResourceType: String {
                return "json"
            }
            var path: String {
                return "faux-api"
            }
        }
        let endpoint = Endpoint.endpoint
        let localDataDirectory = "chris"
        // first we try to find the resource in the main bundle
        let resource = endpoint.localResource
        let resourceType = endpoint.localResourceType
        let bundle = Bundle.main
        let resourceDirectory = URL(string: localDataDirectory)!
            .appendingPathComponent(endpoint.path, isDirectory: true)
            .path
        let bundleResourcePath = bundle.path(
            forResource: resource,
            ofType: resourceType,
            inDirectory: resourceDirectory
        )
        // if the previous path was nil it means that the bundle couldnt' find the resource
        let bundleResourcePathFileURL = URL(fileURLWithPath: bundleResourcePath!)
        print("\(bundleResourcePathFileURL)")
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //debugBundle()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

