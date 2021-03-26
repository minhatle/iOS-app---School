// Fullname : Minh Nhat Le              StudentID: 164029175
//  DetailsCell.swift
//  MinhLe_MyORDER
//
//  Created by Minh Le on 2021-02-09.
//

import UIKit

class DetailsCell: UITableViewCell {

    @IBOutlet var orderCoffeeType : UILabel!
    @IBOutlet var orderCoffeeSize : UILabel!
    @IBOutlet var orderQuantity : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
