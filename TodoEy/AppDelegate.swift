//
//  AppDelegate.swift
//  TodoEy
//
//  Created by Anthony Ruiz on 6/1/18.
//  Copyright © 2018 Jakaboy. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

   var window: UIWindow?


   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      //print(Realm.Configuration.defaultConfiguration.fileURL)
      do {
         _ = try Realm()
      } catch {
         print("Error initialising new Realm, \(error)")
      }
      return true
   }

}

