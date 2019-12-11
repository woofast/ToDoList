//
//  AppDelegate.swift
//  Todoey
//
//  Created by Hufait on 11/11/19.
//  Copyright © 2019 Hufait. All rights reserved.
//

import UIKit
import RealmSwift



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
        
///     print(Realm.Configuration.defaultConfiguration.fileURL )
        
        
        do {
            _ = try Realm()
            
//            try realm.write {
//                realm.add(data)
//            }
            
        } catch {
            print("Error initializing New Realm, \(error)")
        }
        
        

        
        return true
    }


    
    
}





