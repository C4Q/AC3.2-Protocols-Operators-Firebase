//
//  AppDelegate.swift
//  Shopping Cart Protocols
//
//  Created by Louis Tur on 1/30/17.
//  Copyright © 2017 AccessCode. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    FIRApp.configure()
    
    let navVC = UINavigationController(rootViewController: ViewController())
    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.window?.rootViewController = navVC
    self.window?.makeKeyAndVisible()
    
    let glasses = ShoppingCartItem(price: 53.70, name: "Sabrina's Glasses", sku: 90000000091, quantity: 1)
    
    let shoppingSession = ShoppingSession.shared
    //    shoppingSession.shoppingCart.addToCart(item: glasses, quantity: 1)
    //    shoppingSession.shoppingCart.addToCart(item: glasses, quantity: 1)
    
    let otherGlasses = ShoppingCartItem(price: 53.70, name: "Louis's Glasses", sku: 9000000023, quantity: 1)
    
    (glasses *^ otherGlasses)
    glasses^*^
    
    //    if glasses != otherGlasses {
    //      print("Glasses are not the same")
    //    }
    
    //    print("Found: \(shoppingSession.shoppingCart.quantityForItem(item: glasses))")
    //    print("Found: \(shoppingSession.shoppingCart.quantityForItem(item: otherGlasses))")
    
    let thirtyTwoIntA: Int32 = 20
    let thirtyTwoIntB: Int32 = 20
    
    let sixtyFourIntA: Int64 = 25
    let sixtyFourIntB: Int64 = 25
    
    //    print(thirtyTwoIntA * thirtyTwoIntB)
    //    print(sixtyFourIntA * sixtyFourIntB)
    
    let a: CGFloat = 6.0
    let b: Float = 7.0
    let c: Double = 8.0
    
    c^*^
    //    print(a * b)
    let newPoint = 3.0 >< 4.0
    
    let fullString = ["these", "are", "strings"].reduce("", +)
    
    
    //    func +(lhs: String, rhs: String) -> String
    //    (String, String) -> String
    let stringClosure = { (a: String, b: String) in
      return a + b
    }
    
    func doSomethingWithAStringClosure(closure: (String, String) -> String) {
      print(closure("Hi ", "There"))
    }
    
    doSomethingWithAStringClosure(closure: stringClosure)
    
    
    return true
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    do {
      try FIRAuth.auth()?.signOut()
    }
    catch {
      print("Error attempting to log out: \(error)")
    }
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  
  
}

