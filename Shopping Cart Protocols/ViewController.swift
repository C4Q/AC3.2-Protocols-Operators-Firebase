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
  
  /*
    ____________________________________
   |                                    |
   |            Firebase!               |
   |____________________________________|
    
    🔥 + 🛢 - ( 🤖 )
 
   The overall idea of working with firebase is that there are references (to databases) and observers on those references
   
   - Reference: Essentially points to the URL of your database; this can be the root, or any of its child nodes
   - Observing: An observer well, observes changes to a database. Which changes that are observed are determined when you
                Instantiate an observer

   If you're unsure, just dump() a FIRDatabaseReference to know what the URL youre working with; it will always begin like:
   
                                      https://{unique-db-id}.firebase.com/
   
   
   "Building" on an existing reference just means that you're adding addtion path components to the base URL. So having
   something like: 
   
                  let rootDatabaseReference: FIRDatabaseReference = FIRDatabase.database().reference()
                  // evaluates to --> https://{unique-db-id}.firebase.com/
   
                  let topLevelDatabaseReference: FIRDatabaseReference = rootDatabaseReference.child("users")
                  // evaluates to --> https://{unique-db-id}.firebase.com/users
   
                  let specificUserReference: FIRDatabaseReference = topLevelDatabaseReference.child("4231235") // pretend this is a userID
                  // evaluates to --> https://{unique-db-id}.firebase.com/users/4231235
   
   
   Adding observers allows you to run a closure when a specific event happens to the database reference you're currently observing. 
   Something like:
   
                  rootDatabaseReference.observe(.childAdded, with: { (snapshot: FIRDataSnapshot) in
                    // code can be added here to do stuff
                  })
   
   In the above example, we create an observer that "listens/observes" a .childAdded event (which is caused by adding a new child
   node to that point in the database). 
   
   
   Now, what is a FIRDataSnapshot? It's a "snapshot" of your database at that node at that present moment in time (think like
   literally a photo snapshot, on like a piece of photo paper... film? whatever.) The FIRDataSnapshot has a number of properties
   to inspect the database at that point, I encourage you to look at the documentation for full details:
   
   https://firebase.google.com/docs/reference/ios/firebasedatabase/api/reference/Classes/FIRDataSnapshot
   
   */

  let databaseReference = FIRDatabase.database().reference().child("shoppingCartItems")
  var databaseObserver: FIRDatabaseHandle?
  var signInUser: FIRUser?
  
  
  // this was an early decision in trying to store the keys for the shoppingCartItems in our database we wanted to remove
  // we quickly moved away from this though when we realized that we could just work with the FIRDataSnapshot directly
  var keysToRemove: [String] = [] {
    didSet {
      dump(keysToRemove) // this dump was done to observe the effects of our code, in that we were interested in seeing the contents of this array
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    
    setupViewHierarchy()
    configureConstraints()
    
    //    loginAnonymously() // testing logging in
    setObserver()
    
    queryForOutdatedRecords()
    //    testAddingAnItem() // we used this function to test adding an entry to our database
  }
  
  func queryForOutdatedRecords() {
    // "outdated" refers to missing the key "addedBy"
    
    // first we add an observer on databaseReference which will look for changes at this particular node
    // but also, it will fire when the app runs in order to return all of the children at that node
    let _ = databaseReference.observe(.childAdded, with: { (snapshot) in
      
      // Q: How did I know to go through the snapshot's children?
      // A: print() statements, lots of them. I'm not familiar with firebase so I take the process one step at a time.
      //    - I printed out to console first snapshot to see what it looked like
      //    - At that point i just typed out snapshot. and checked out what the autofill gave me
      //    - I went through a few that seemed relevant, ultimately picking snapshot.children since I know i need to look through
      //      all of the nodes in my database
      //    - When i saw snapshot.children could be enumerated over, i added the for-in loop.
      //    - In that loop I printed out each child object.
      //    - That printing showed me that the child object was of type FIRDataSnapshot, so at that point i did the force 
      //      typecase as! [FIRDataSnapshot]
      //    - From that point, i checked the properties that I could access on each child
      //    - I noticed that the structure at that point resembled json/dictionary so I attempted to typecase to [String : Anyobject]
      //    - When I saw that worked, I specifically checked for known keys, like value["price"] to see if I got a return 
      //      value
      //    - When that worked, I checked specifically for "addedBy" key
      // 
      //    And that's the story of development
      for child in snapshot.children.allObjects as! [FIRDataSnapshot] {
        if let value = child.value as? [String : AnyObject] {
         
          // we create a reference here to this item's node
          // the childRef essentially evaluates to 
          //
          //      https://{unique-db-id}.firebase.com/shoppingCartItems/{shoppingItemId}
          //
          let childRef = self.databaseReference.child(child.key)
          
          if value["addedBy"] == nil {
            print("found an instance where added by doesn't exist")
            //            self.keysToRemove.append(child.key) // this ended up being unnecessary
            
            childRef.removeValue() // lastly, we call this on the reference of interest to actually perform the removal
          }
          
          // We can update records by either changing existing values for a given key, 
          // or by adding an entirely new key-value pair
//          let updatedValue = [ "price" : 1.09 ]
//          childRef.updateChildValues(updatedValue)
          
//          childRef.updateChildValues([ "rating" : "M (AO)" ])
          
          // We can also desctructively act on a database record by calling .setValue
          // this results in the entry's value being completely overwritten by the new value.
          
          // p.s. Uncomment the line below with caution. It causes an infinite loop. 
          //      Why? well, we (destructively) change the value for the database entry, but because
          //      this update is considered a ".childAdded" event, it triggers this observer to run again.
          // childRef.setValue([ "availability" : "Not in stock" ])
        }
      }
      
      
      
    })
    
  }
  
  private func loginAnonymously() {
    
    // This is pretty self explanatory. Just make sure you enable anonymous login/users in your database's console
    // see: https://firebase.google.com/docs/reference/ios/firebaseauth/api/reference/Classes/FIRAuth
    FIRAuth.auth()?.signInAnonymously(completion: { (user: FIRUser?, error: Error?) in
      
      if error != nil {
        print("Error attempting to log in anonymously: \(error!)")
      }
      
      if user != nil {
        print("Signed in anonymously!")
        self.signInUser = user
        
        // We have this line here to only add a test item if the user is able to anonymously authenticate
        print("About to Save an item")
        self.testAddingAnItem()
      }
      
    })
    
  }
  
  private func setObserver() {
    databaseObserver = databaseReference.observe(.childAdded, with: { (snapshot: FIRDataSnapshot) in
//      dump(snapshot)
    })
  }
  
  // This is an example of adding a new item
  func testAddingAnItem() {
    // 1. Get the instance of the item
    let newItem = ShoppingCartItem(price: 28.00, name: "Epic Romance Novel, 2017: by Gabe feat. Tom", sku: 100000031, quantity: 3)
    
    // 2. Get a reference to where we want to place the new item. In this case we use .childByAutoId() to autogenerate a 
    //    unique key for this new record
    let newItemRef = databaseReference.childByAutoId()
    let newItemDetails: [String : AnyObject] = [
      "price" : newItem.price as AnyObject,
      "name" : newItem.name as AnyObject,
      "sku" : newItem.sku as AnyObject,
      "quantity" : newItem.quantity as AnyObject,
      "addedBy" : (self.signInUser?.uid ?? "Not Signed In/Semi Anon") as AnyObject
    ]
    
    // 3. .setValue accepts Any? so you can pass in any struct you like. This part really depends on how your database is being
    //    structured.
    newItemRef.setValue(newItemDetails)
  }
  
  private func configureConstraints() {
    
  }
  
  private func setupViewHierarchy() {
    
  }
  
  
}

