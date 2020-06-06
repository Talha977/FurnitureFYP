//
//  BeerListViewCellTableViewCell.swift
//  BeerCraft
//
//  Copyright © 2020 Talha Asif . All rights reserved.
//

import UIKit

class FurnitureViewCellTableViewCell: UITableViewCell {

    @IBOutlet weak var beerImage: UIImageView!
    
    @IBOutlet weak var beerName: UILabel!
    
    @IBOutlet weak var beerStyle: UILabel!
    
    @IBOutlet weak var ABV: UILabel!
    
    @IBOutlet weak var beerPrice: UILabel!
    
    var beerData:Furnitures?{
        didSet{
            if let beerDetails = beerData{
                
                if let name = beerDetails.name{
                    beerName.text = name
                }
                
                if let abv = beerDetails.abv{
                    if abv.count>0{
                        ABV.text = "Weight: \(abv)"
                    } else{
                        ABV.text = "Weight: NA"
                    }
                }
                let currencySymbol = getCurrencySymbol()
                beerPrice.text = "\(currencySymbol) \(beerDetails.cost)"
                
                if let style = beerDetails.style{
                    beerStyle.text = style
                }
                
            }
        }
    }
    
}



