//
//  ViewController.swift
//  Shopping Cart Protocols
//
//  Created by Louis Tur on 1/30/17.
//  Copyright © 2017 AccessCode. All rights reserved.
//

import UIKit
import SnapKit
import Firebase

class ViewController: UIViewController {
  
  let databaseReference = FIRDatabase.database().reference().child("shoppingCartItems")
  var databaseObserver: FIRDatabaseHandle?
  var signInUser: FIRUser?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    
    setupViewHierarchy()
    configureConstraints()
    
    loginAnonymously()
    setObserver()
    //    testAddingAnItem()
  }
  
  private func loginAnonymously() {
    
    FIRAuth.auth()?.signInAnonymously(completion: { (user: FIRUser?, error: Error?) in
      
      if error != nil {
        print("Error attempting to log in anonymously: \(error!)")
      }
      
      if user != nil {
        print("Signed in anonymously!")
        self.signInUser = user
        
        print("About to Save an item")
        self.testAddingAnItem()
      }
      
    })
    
  }
  
  private func setObserver() {
    databaseObserver = databaseReference.observe(.childAdded, with: { (snapshot: FIRDataSnapshot) in
      dump(snapshot)
    })
  }
  
  func testAddingAnItem() {
    let newItem = ShoppingCartItem(price: 28.00, name: "Epic Romance Novel, 2017: by Gabe feat. Tom", sku: 100000031, quantity: 3)
    
    let newItemRef = databaseReference.childByAutoId()
    let newItemDetails: [String : AnyObject] = [
      "price" : newItem.price as AnyObject,
      "name" : newItem.name as AnyObject,
      "sku" : newItem.sku as AnyObject,
      "quantity" : newItem.quantity as AnyObject,
      "addedBy" : (self.signInUser?.uid ?? "Not Signed In/Semi Anon") as AnyObject
    ]
    newItemRef.setValue(newItemDetails)
  }
  
  private func configureConstraints() {
    
  }
  
  private func setupViewHierarchy() {
    
  }
  
  
}

