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
    
    // After you ensure that your GoogleService-Info.plist is added to your project, this line sets up the FIRApp instance
    FIRApp.configure()
    
    // 4 Lines of Code to Success!
    let navVC = UINavigationController(rootViewController: ViewController())
    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.window?.rootViewController = navVC
    self.window?.makeKeyAndVisible()
    
    
    
    // ------ Examples from Monday's lesson on Protocol Conformance ------ //
    let glasses = ShoppingCartItem(price: 53.70, name: "Sabrina's Glasses", sku: 90000000091, quantity: 1)
    
    let shoppingSession = ShoppingSession.shared
    
    // Q: Why are both these lines duplicated? 
    // A: It was to illustrate that the == operator is called when attempting to access a dictionary where a ShoppingCartItem is used as a key
    //    shoppingSession.shoppingCart.addToCart(item: glasses, quantity: 1)
    //    shoppingSession.shoppingCart.addToCart(item: glasses, quantity: 1)
    
    // Q: Why is this line here to create another ShoppingCartItem?
    // A: Further down we try out the Equatable protocol by comparing these two instances of ShoppingCartItem
    let otherGlasses = ShoppingCartItem(price: 53.70, name: "Louis's Glasses", sku: 9000000023, quantity: 1)
    
    // Q: The hell is this infix operator?
    // A: Take a look at ShoppingCartItem.swift for the declarations for the operators (or run the project and see what this does)
    (glasses *^ otherGlasses) // the "winking meow" infix operator
    glasses^*^ // the "meow" postfix operator >^*^<
    
    if glasses != otherGlasses {
      print("Glasses are not the same")
    }
    
    //    print("Found: \(shoppingSession.shoppingCart.quantityForItem(item: glasses))")
    //    print("Found: \(shoppingSession.shoppingCart.quantityForItem(item: otherGlasses))")
    
    
    // ----- Overloaded Operators ------ //
    // The below constants were just to illustrate there are type-specific versions of the * operator
    // See https://developer.apple.com/reference/swift/swift_standard_library_operators for full list
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
    // The commented line below wont work because there is no operator function that offers multiplying a Float and CGFloat
    //    print(a * b)
    
    // This is a custom operator example to just show something a little more practical application of custom operators. 
    // In this case it takes two floats and returns a CGPoint
    let newPoint = 3.0 >< 4.0
    
    // If you look at the function definition for + operator, you'll notice that (one of) the implementation has a function
    // type (String, String) -> String which is a valid closure to use in the .reduce funciton
    let fullString = ["these", "are", "strings"].reduce("", +)
    
    
    
    // ----- Function Types ------ //
    // Below is just an example of passing a closure as a parameter
    // The overall idea to reinforce was that closures have "types"
    
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

