//  FurnitureApp
//
//  Copyright © 2020 Talha Asif. All rights reserved.
//


import Foundation
import UIKit

class FurnitureModel: NSObject {
    
    static var shared = FurnitureModel()
    
    var Images = [UIImage(named:"furn1"),UIImage(named:"furn2"),UIImage(named:"furn3"),UIImage(named:"furn4"),UIImage(named:"furn5"),UIImage(named:"furn6"),UIImage(named:"furn7")]
    
    var Names = ["Table","Chair","Bed","Flower","Plastic Chair","Sofas","Teapot"]
    
    var selectedIndex = Int()
    
}
