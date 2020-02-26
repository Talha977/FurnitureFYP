 //  FurnitureApp
 //
 //  Copyright © 2020 Talha Asif. All rights reserved.
 //


import Foundation
import Intents

 extension NSUserActivity {
     
     public static let orderBeerActivityType = "com.sid.IntentKit.orderBeer"
     
     public static var orderBeerActivity: NSUserActivity {
         let userActivity = NSUserActivity(activityType: NSUserActivity.orderBeerActivityType)
         
        userActivity.title = "Order Furniture"
        userActivity.persistentIdentifier = NSUserActivityPersistentIdentifier(NSUserActivity.orderBeerActivityType)
         userActivity.isEligibleForPrediction = true
         userActivity.suggestedInvocationPhrase = "Order Furniture"
         
         return userActivity
     }
 }
