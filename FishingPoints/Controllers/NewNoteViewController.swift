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
    @IBOutlet weak var dateLabel: UILabel!
        
    var catches = [Catch]()
    var currentNote: Note?
    var dateStr = ""
    
    
    var newCatch: Catch?
    var newNote: Note!
    var user: Users!
    var ref: DatabaseReference!
    
    let networkWeatherManager = NetworkWeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      guard let currentUser = Auth.auth().currentUser else { return }
        user = Users(user: currentUser)
        
        datePicker.addTarget(self, action: #selector(dateChanged), for: .editingChanged)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MM yyyy"
        dateStr = dateFormatter.string(from: datePicker.date)
        dateLabel.text = dateStr
        
        self.notesTextView.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        dateLabel.isHidden = true

        setupEditScreen()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if currentNote != nil {
            ref = Database.database(url: "https://fishingpoints-e0f7c-default-rtdb.firebaseio.com/").reference(withPath: "users").child(user.uid).child("dairy").child(dateLabel.text!).child("catches")
            ref.observe(.value) { [weak self] snapshot in
                //создал массив для хранения поимок, чтобы каждый раз проходя по циклу не дублировались записи
                var _catches = Array<Catch>()
                for item in snapshot.children {
                    let fishCatch = Catch(snapShot: item as! DataSnapshot)
                    _catches.append(fishCatch)
                }
                self?.catches = _catches
                self?.catchesTableView.reloadData()
            }
        }
      
    }
    
    
    func saveNote () {
        newNote = Note(fishingDate: /*dateLabel.text!*/dateStr, fishingPlace: fishingPlaceTF.text, catchesCount: catches.count, catches: catches, notesAboutTrip: notesTextView.text)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func unwindSegue (_ segue: UIStoryboardSegue) {
        
        guard let newCatchVC = segue.source as? NewCatchViewController else { return }
        
        newCatchVC.saveNewCatch()
        catches.append(newCatchVC.newCatch!)
        catchesTableView.reloadData()
        
    }
    @IBAction func datePickerChanged(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MM yyyy"

        dateStr = dateFormatter.string(from: datePicker.date)
        print(dateStr)
        
    }
    
    
    @objc func tapDone(sender: Any) {
            self.view.endEditing(true)
    }
}



extension NewNoteViewController: UIPickerViewDelegate {
    
    @objc func dateChanged(sender : UIDatePicker){
        self.view.endEditing(true)
    }
}

extension NewNoteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "catchCell") as! CatchesTableViewCell
        
        let fishCatch = catches[indexPath.row]
        
        cell.fishKindTF.text = fishCatch.fishKind
        cell.fishSizeTF.text = fishCatch.fishSize
        cell.baitTF.text = fishCatch.bait
        cell.catchTimeTF.text = fishCatch.time
        cell.numberOfCell.text = "\(catches.index(after: indexPath.row))"
        
        cell.locationTF.text = fishCatch.location
        let coordinatesArr = cell.locationTF.text?.components(separatedBy: ", ")
        
        guard let unixTime = convertDateString(withDate: dateStr, and: cell.catchTimeTF.text)?.timeIntervalSince1970.rounded() else { return cell }
        
        networkWeatherManager.fetchWeather(forTime: Int(unixTime), byCoordinates:  (coordinatesArr?.first)!, and: (coordinatesArr?.last)!){ certainWeather in
            DispatchQueue.main.async {
                cell.pressureLabel.text = certainWeather.presStr
                cell.temperatureLabel.text = certainWeather.tempStr
                cell.wheatherConditionLabel.text = certainWeather.conditionCodeString
            }
        }
        return cell
    }

}

extension NewNoteViewController: UITextFieldDelegate, UITextViewDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension UITextView {
    
    func addDoneButton(title: String, target: Any, selector: Selector) {
        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)
        toolBar.setItems([flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar
    }
}


//work with time
extension NewNoteViewController {
    private func convertDateString (withDate dateStr: String?, and timeStr: String?) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "dd MM yyyy 'at' hh:mm"
        let string = dateStr! + " at " + timeStr!
        guard let finalDate = dateFormatter.date(from: string) else { return nil }
        //print(finalDate)
        return finalDate
    }
}

//work with editing screen
extension NewNoteViewController {
    
    private func setupEditScreen(){
        if currentNote != nil {
            setupNavigationBar()
            datePicker.removeFromSuperview()
            //datePicker.isHidden = true
            dateLabel.isHidden = false
            dateLabel.text = currentNote?.fishingDate
            fishingPlaceTF.text = currentNote?.fishingPlace
            notesTextView.text = currentNote?.notesAboutTrip

        }
    }
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = nil
        guard let date = currentNote?.fishingDate, let place = currentNote?.fishingPlace else { return }
        navigationItem.title = date + " " + place
    }
}

