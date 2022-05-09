//
//  NewCatchViewController.swift
//  FishingPoints
//
//  Created by Roman Torry on 9.05.22.
//

import UIKit

class NewCatchViewController: UITableViewController {

    var newCatch: Catch!

    
    @IBOutlet weak var fishKind: UITextField!
    @IBOutlet weak var fishSize: UITextField!
    @IBOutlet weak var bait: UITextField!
    @IBOutlet weak var time: UITextField!
    @IBOutlet weak var coordinates: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func saveNewCatch () {
        newCatch = Catch(fishKind: fishKind.text!, fishSize: fishSize.text, bait: bait.text, time: time.text, temperature: nil, pressure: nil, location: coordinates.text)
    }
    
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
}

extension NewCatchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
