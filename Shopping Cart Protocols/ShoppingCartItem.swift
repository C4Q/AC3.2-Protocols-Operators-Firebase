//
//  ShoppingCartItem.swift
//  Shopping Cart Protocols
//
//  Created by Louis Tur on 1/30/17.
//  Copyright © 2017 AccessCode. All rights reserved.
//

import Foundation
import UIKit

// Remember:
// |- Equatable
// |-- Hashable
// |-- Comparable
//
// (Meaning: Hashable and Comparable inherit from Equatable)
struct ShoppingCartItem: CustomStringConvertible, Hashable, Comparable {
  let price: Double
  let name: String
  let sku: Int
  let quantity: Int
  
  // Implementing CustomStringConvertible
  // https://developer.apple.com/reference/swift/CustomStringConvertible#
  var description: String {
    return String(format: "%@ $%0.2f", name, price)
  }
  
  // Implementing Hashable
  // https://developer.apple.com/reference/swift/hashable#
  var hashValue: Int {
    return sku.hashValue ^ price.hashValue
  }
  
  // Implementing Comparable 
  // https://developer.apple.com/reference/swift/comparable#
  static func ==(lhs: ShoppingCartItem, rhs: ShoppingCartItem) -> Bool {
//    print("Comparing \(lhs)  \(rhs)")
    return lhs.sku == rhs.sku
  }
  
  static func >(lhs: ShoppingCartItem, rhs: ShoppingCartItem) -> Bool {
    return lhs.price > rhs.price
  }
  
  static func >=(lhs: ShoppingCartItem, rhs: ShoppingCartItem) -> Bool {
    return lhs.price >= rhs.price
  }
  
  static func <(lhs: ShoppingCartItem, rhs: ShoppingCartItem) -> Bool {
    return lhs.price < rhs.price
  }
  
  static func <=(lhs: ShoppingCartItem, rhs: ShoppingCartItem) -> Bool {
    return lhs.price <= rhs.price
  }
  
}


// Custom operators
// https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/AdvancedOperators.html#//apple_ref/doc/uid/TP40014097-CH27-ID28
// Scroll to bottom of the doc link to see info on custom operators

// Nutshell:
// There are three (well, four) types of operators:
// - Prefix: are placed before the operand
// - Infix: are placed between two operands
// - Postfix: are placed after the operands

// There are also two other major properties of operators:
// - Associativity: This value determines whether, when presented with two operators with equal precedence, if the operation on the
//    left or right should be evaluated first
// - Precedence: This relates to PEMDAS and order of operations, or how much priority does this operator get when near other operators?
infix operator *^
func *^(lhs: ShoppingCartItem, rhs: ShoppingCartItem) {
  print("We have \(lhs) & \(rhs)")
}

postfix operator ^*^
postfix func ^*^(x: ShoppingCartItem) {
  print("MEEEEEOOOOOOOOWW \(x)")
}

postfix func ^*^(x: Double) {
  print("MEEEEEOOOOOOOOWW \(x)")
}

infix operator ><
func ><(lhs: CGFloat, rhs: CGFloat) -> CGPoint {
  return CGPoint(x: lhs, y: rhs)
}

// this apparently is allowed to be defined, but not actually called. hmm 🤔
infix operator *
public func *(lhs: CGFloat, rhs: Float) -> Float {
  return Float(lhs) * rhs 
}




// --- Below are just some "helper" classes that are used to interact with ShoppingCartItem -- //
// --- There's nothing particularly special about them as related to the lesson             -- //
enum CartSort {
  case ascending, descending
}
class ShoppingCart {
  
  var cartItems: [ShoppingCartItem] = []
  var fullCartItems: [ShoppingCartItem : Int] = [:]
  
  func addToCart(item: ShoppingCartItem, quantity: Int) {
    self.cartItems.append(item)
    self.fullCartItems[item] = (fullCartItems[item] ?? 0) + quantity
  }
  
  func quantityForItem(item: ShoppingCartItem) -> Int? {
    return fullCartItems[item]
  }
  
  func sortedCart(_ type: CartSort) -> [ShoppingCartItem] {
    switch type {
      
    case .ascending:
      print("Ascending")
      return self.cartItems.sorted(by: <)
      
    case .descending:
      print("Descending")
      return self.cartItems.sorted(by: >)
    }
  }
}

class ShoppingSession {
  var shoppingCart = ShoppingCart()
  
  static let shared: ShoppingSession = ShoppingSession()
  private init() { }
  
  
  
}
