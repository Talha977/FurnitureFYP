//  FurnitureApp
//
//  Copyright © 2020 Talha Asif. All rights reserved.
//


import Foundation
import UIKit

class FurnitureModel: NSObject {
    
    static var shared = FurnitureModel()
    
    var myURL = String()
    var Images = [UIImage(named:"furn1"),UIImage(named:"furn2"),UIImage(named:"furn3"),UIImage(named:"furn4"),UIImage(named:"furn5"),UIImage(named:"furn6"),UIImage(named:"furn7")]
    
    var Names = ["Table","Chair","Bed","Flower","Plastic Chair","Sofas","Teapot"]
    
    var selectedIndex = Int()
    
}

let jsonStr = """
[
{
   "abv":"0.05",
   "ibu":"",
   "id":1436,
   "name":"Pub Beer",
   "style":"American Pale Lager",
   "ounces":12.0
},
{
   "abv":"0.06",
   "ibu":"",
   "id":2265,
   "name":"Devils Cup",
   "style":"American Pale Ale (APA)",
   "ounces":12.0
}
]
"""

