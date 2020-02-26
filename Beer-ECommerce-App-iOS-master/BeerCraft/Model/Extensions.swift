//
//  Extensions.swift
//  BeerCraft
//
//  Created by Mnet on 02/07/1441 AH.
//  Copyright © 1441 Siddhant Mishra. All rights reserved.
//

import Foundation
import UIKit

class CurvedButton:UIButton{
    
      required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 10
    }
}

