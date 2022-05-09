//
//  DairyViewController.swift
//  FishingPoints
//
//  Created by Roman Torry on 28.03.22.
//

import UIKit
import FirebaseDatabase
import FirebaseCore
import FirebaseAuth

class DairyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var user: Users!
    var ref: DatabaseReference!
    var notes = Array<Note>()

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //так же как и в поинтс
        guard let currentUser = Auth.auth().currentUser else { return }
        user = Users(user: currentUser)
        ref = Database.database(url: "https://fishingpoints-e0f7c-default-rtdb.firebaseio.com/") .reference(withPath: "users").child(user.uid).child("dairy")

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ref.observe(.value) { [weak self] snapshot in
            //создал массив для хранения задач, чтобы каждый раз проходя по циклу не дублировались записи
            var _notes = Array<Note>()
            for item in snapshot.children {
                let note = Note(snapShot: item as! DataSnapshot)
                _notes.append(note)
            }
            self?.notes = _notes
            self?.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dairyCell") as! DairyTableViewCell
        let note = notes[indexPath.row]
        
        cell.dateOfTheFishing.text = note.fishingDate
        cell.placeOfTheFishing.text = note.fishingPlace
        //cell.catchesCount.text = String(note.catchesCount)
        
        return cell
    }

    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        guard let newNoteVC = segue.source as? NewNoteViewController else { return }
        
        newNoteVC.saveNote()
        
        let newNote = newNoteVC.newNote!
        let noteRef = ref?.child(newNote.fishingDate!)
        //и теперь по этой ссылке помещаем нашу новую запись в дневник
        noteRef?.setValue(newNote.convertToDictionary())
        
        //notes.append(newNoteVC.newNote!)
        notes.append(newNoteVC.newNote!)
        tableView.reloadData()
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
