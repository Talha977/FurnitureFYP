//
//  BeerDataModel.swift
//  BeerCraft
//
//  Created by Siddhant Mishra on 27/07/19.
//  Copyright © 2019 Siddhant Mishra. All rights reserved.
//

import Foundation
import ObjectMapper

typealias Beers = BeerData


//class FurnitureModel


//struct Furniture {
//
//      public var id:Int = (Int.random(in: 0..<1000))
//       public var name:String?
//       public var style:String?
//       public var ounces:Double?
//       public var cost:String = String(Int.random(in: 200..<1000))
//
//
//}



struct BeerData: Mappable {
    public var id:Int = 0
    public var abv:String?
    public var ibu:String?
    public var name:String?
    public var style:String?
    public var ounces:Double?
    public var cost:String = String(Int.random(in: 200..<1000))
    public var ImageIndex = Int.random(in: 0..<7)
    

    
    init?(map: Map) {
        
    }
    
    init?() {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        abv <- map["abv"]
        ibu <- map["ibu"]
        name <- map["name"]
        style <- map["style"]
        ounces <- map["ounces"]
    }
    
    
}


//
//static var shared = FurnitureModel()
//
//var FurnitureArray = [BeerData]()
//
//    let furniture1 = Furniture(id: 0, name: "Table", style: "Classical", ounces: 40       , cost: "0")
//    let furniture2 = Furniture(id: 0, name: "Chair", style: "Classical", ounces: 40       , cost: "0")
//    let furniture3 = Furniture(id: 0, name: "Bed ", style: "Classical", ounces: 40       , cost: "0")
//    let furniture4 = Furniture(id: 0, name: "Dining Table", style: "Classical", ounces: 40       , cost: "0")
//    let furniture5 = Furniture(id: 0, name: "Dining Table", style: "Classical", ounces: 40       , cost: "0")
//    let furniture7 = Furniture(id: 0, name: "Bed", style: "Classical", ounces: 40       , cost: "0")
//    let furniture8 = Furniture(id: 0, name: "Chair", style: "Classical", ounces: 40       , cost: "0")
//    let furniture9 = Furniture(id: 0, name: "Chair", style: "Classical", ounces: 40       , cost: "0")
//    let furniture10 = Furniture(id: 0, name: "Music Table ", style: "Classical", ounces: 40       , cost: "0")
//    let furniture11 = Furniture(id: 0, name: "Table 1", style: "Classical", ounces: 40       , cost: "0")
//    let furniture12 = Furniture(id: 0, name: "Table 1", style: "Classical", ounces: 40       , cost: "0")
//    let furniture13 = Furniture(id: 0, name: "Table 1", style: "Classical", ounces: 40       , cost: "0")
//    let furniture14 = Furniture(id: 0, name: "Table 1", style: "Classical", ounces: 40       , cost: "0")
//    let furniture15 = Furniture(id: 0, name: "Table 1", style: "Classical", ounces: 40       , cost: "0")
//    let furniture16 = Furniture(id: 0, name: "Table 1", style: "Classical", ounces: 40       , cost: "0")
//    let furniture17 = Furniture(id: 0, name: "Table 1", style: "Classical", ounces: 40       , cost: "0")
//    let furniture18 = Furniture(id: 0, name: "Table 1", style: "Classical", ounces: 40       , cost: "0")
//    let furniture19 = Furniture(id: 0, name: "Table 1", style: "Classical", ounces: 40       , cost: "0")
//    let furniture20 = Furniture(id: 0, name: "Table 1", style: "Classical", ounces: 40       , cost: "0")
//    let furniture21 = Furniture(id: 0, name: "Table 1", style: "Classical", ounces: 40       , cost: "0")
//    let furniture22 = Furniture(id: 0, name: "Table 1", style: "Classical", ounces: 40       , cost: "0")
//    let furniture23 = Furniture(id: 0, name: "Table 1", style: "Classical", ounces: 40       , cost: "0")
//    let furniture24 = Furniture(id: 0, name: "Table 1", style: "Classical", ounces: 40       , cost: "0")
//    let furniture25 = Furniture(id: 0, name: "Table 1", style: "Classical", ounces: 40       , cost: "0")
//    let furniture26 = Furniture(id: 0, name: "Table 1", style: "Classical", ounces: 40       , cost: "0")
//    let furniture27 = Furniture(id: 0, name: "Table 1", style: "Classical", ounces: 40       , cost: "0")
//    let furniture28 = Furniture(id: 0, name: "Table 1", style: "Classical", ounces: 40       , cost: "0")
//    let furniture29 = Furniture(id: 0, name: "Table 1", style: "Classical", ounces: 40       , cost: "0")
//    let furniture30 = Furniture(id: 0, name: "Table 1", style: "Classical", ounces: 40       , cost: "0")
//    let furniture31 = Furniture(id: 0, name: "Table 1", style: "Classical", ounces: 40       , cost: "0")
//    let furniture32 = Furniture(id: 0, name: "Table 1", style: "Classical", ounces: 40       , cost: "0")
//    let furniture33 = Furniture(id: 0, name: "Table 1", style: "Classical", ounces: 40       , cost: "0")
//    let furniture34 = Furniture(id: 0, name: "Table 1", style: "Classical", ounces: 40       , cost: "0")
//    let furniture35 = Furniture(id: 0, name: "Table 1", style: "Classical", ounces: 40       , cost: "0")
//
//
//
//
//
//}
