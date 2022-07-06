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
        cell.catchesCount.text = String(describing: note.catchesCount!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let note = notes[indexPath.row]
            note.ref?.removeValue()
        }
    }

    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        guard let newNoteVC = segue.source as? NewNoteViewController else { return }
        
        newNoteVC.saveNote()
        
        let newNote = newNoteVC.newNote!
        let noteRef = ref?.child(newNote.fishingDate!)
        //и теперь по этой ссылке помещаем нашу новую запись в дневник
        noteRef?.setValue(newNote.convertToDictionary())
        var i = 0
        for fishCatch in newNoteVC.catches {
            var newCatch = fishCatch
            i += 1
            newCatch.temperature = newNoteVC.currTemp
            newCatch.pressure = newNoteVC.currPress
            let catchRef = noteRef?.child("catches").child("\(i)")
            catchRef?.setValue(newCatch.convertToDictionary())
        }
        
        notes.append(newNoteVC.newNote!)
        tableView.reloadData()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showNoteDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let note = notes[indexPath.row]
            let newNoteVC = segue.destination as! NewNoteViewController
            newNoteVC.currentNote = note
            
    
        }
        
    }
    
}
