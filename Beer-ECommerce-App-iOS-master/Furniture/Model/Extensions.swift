//  FurnitureApp
//
//  Copyright © 2020 Talha Asif. All rights reserved.
//


import Foundation
import UIKit

class CurvedButton:UIButton{
    
      required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 10
    }
}

