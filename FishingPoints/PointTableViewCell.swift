//
//  PointTableViewCell.swift
//  FishingPoints
//
//  Created by Roman Torry on 28.03.22.
//

import UIKit
import Cosmos

class PointTableViewCell: UITableViewCell {

    @IBOutlet weak var imageOfPoint: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var coordinateLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var cosmosView: CosmosView! {
        didSet {
            cosmosView.settings.updateOnTouch = false
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
