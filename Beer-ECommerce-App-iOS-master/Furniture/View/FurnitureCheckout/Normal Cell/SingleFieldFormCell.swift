//  FurnitureApp
//
//  Copyright © 2020 Talha Asif. All rights reserved.
//

import UIKit

class SingleFieldFormCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var nameTf: UITextField!
    
    
    
    var formData:[String] = []{
        didSet{
            if formData.count>0{
                lblName.text = formData[0]
//                nameTf.placeholder = formData[0]
                nameTf.addLine(color: #colorLiteral(red: 0.9176470588, green: 0.6745098039, blue: 0.1843137255, alpha: 1), width: 0.3)
            }
        }
    }
}
