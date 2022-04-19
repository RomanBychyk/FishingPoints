//
//  NewNoteViewController.swift
//  FishingPoints
//
//  Created by Roman Torry on 13.04.22.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseDatabase

class NewNoteViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var fishingPlaceTF: UITextField!
    @IBOutlet weak var catchesTableView: UITableView!
    @IBOutlet weak var notesTextView: UITextView!
    
    //catches outlets
    
    var catches = [Catch]()
    var currentNote: Note?
    var dateStr = ""
    
    
    var newCatch: Catch?
    var newNote: Note!
    var user: Users!
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.addTarget(self, action: #selector(dateChanged), for: .editingChanged)
        dateStr = DateFormatter().string(from: datePicker.date)

    }
    
    func saveNote () {
        
        let dateString = DateFormatter().string(from: datePicker.date)
        print(dateString)
        newNote = Note(fishingDate: dateStr, fishingPlace: fishingPlaceTF.text, catchesCount: catches.count, catches: catches, notes: notesTextView.text)
        
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addCatchAction(_ sender: Any) {

    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension NewNoteViewController: UIPickerViewDelegate {
    
    @objc func dateChanged(sender : UIDatePicker){
            let dateFormater = DateFormatter()
            let strDate = dateFormater.string(from: (datePicker?.date)!)
        self.view.endEditing(true)
        }
}

extension NewNoteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return catches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "catchCell") as! CatchesTableViewCell
        
        return cell
    }
}
