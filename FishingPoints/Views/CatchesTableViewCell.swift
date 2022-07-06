//
//  CatchesTableViewCell.swift
//  FishingPoints
//
//  Created by Roman Torry on 14.04.22.
//

import UIKit

class CatchesTableViewCell: UITableViewCell {

    @IBOutlet weak var numberOfCell: UILabel!
    @IBOutlet weak var fishKindTF: UITextField!
    @IBOutlet weak var fishSizeTF: UITextField!
    @IBOutlet weak var baitTF: UITextField!
    @IBOutlet weak var catchTimeTF: UITextField!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var weatherConditionImage: UIImageView!
    @IBOutlet weak var locationTF: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
