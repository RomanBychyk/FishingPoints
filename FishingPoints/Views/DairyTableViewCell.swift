//
//  DairyTableViewCell.swift
//  FishingPoints
//
//  Created by Roman Torry on 13.04.22.
//

import UIKit

class DairyTableViewCell: UITableViewCell {

    @IBOutlet weak var dateOfTheFishing: UILabel!
    @IBOutlet weak var placeOfTheFishing: UILabel!
    @IBOutlet weak var catchesCount: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
