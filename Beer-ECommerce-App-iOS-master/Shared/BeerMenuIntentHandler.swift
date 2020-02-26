//  FurnitureApp
//
//  Copyright © 2020 Talha Asif. All rights reserved.
//


import Foundation
import Intents



public class BeerMenuIntentHandler: NSObject, ShowBeerMenuIntentHandling{
    public func handle(intent: ShowBeerMenuIntent, completion: @escaping (ShowBeerMenuIntentResponse) -> Void) {
        completion(ShowBeerMenuIntentResponse(code: .success, userActivity: nil))
    }
}

