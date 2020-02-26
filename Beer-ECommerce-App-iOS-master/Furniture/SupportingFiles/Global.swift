//  FurnitureApp
//
//  Copyright © 2020 Talha Asif. All rights reserved.
//

import Foundation

class Global {
    private init() { }
    static let sharedInstance = Global()
    var cart = [FurnitCart]()
}
