//  FurnitureApp
//
//  Copyright © 2020 Talha Asif. All rights reserved.
//


import Foundation
import ObjectMapper


typealias FurnitCart = CartItem

struct CartItem: Mappable {
    public var id:Int = 0
    public var cost:String = "0"
    public var totalCost:String = "0"
    public var qty:String?
    public var style:String?
    public var name:String?
    public var imageIndex:Int!
    
    
    init?(map: Map) {
        
    }
    
    init?() {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        cost <- map["cost"]
        totalCost <- map["total_cost"]
        qty <- map["qty"]
        style <- map["style"]
        name <- map["name"]
    }
}

