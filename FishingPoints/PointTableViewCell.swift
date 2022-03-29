//
//  PointTableViewCell.swift
//  FishingPoints
//
//  Created by Roman Torry on 28.03.22.
//

import UIKit

class PointTableViewCell: UITableViewCell {

    @IBOutlet weak var imageOfPoint: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var coordinateLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
