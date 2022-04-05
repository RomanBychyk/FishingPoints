//
//  PointsViewController.swift
//  FishingPoints
//
//  Created by Roman Torry on 28.03.22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class PointsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var points = [Point]()
    
    var user: Users!
    var ref: DatabaseReference!
    //var points = Array<Point>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let currentUser = Auth.auth().currentUser else { return }
        user = Users(user: currentUser)
        ref = Database.database(url: "https://fishingpoints-e0f7c-default-rtdb.firebaseio.com/") .reference(withPath: "users").child(user.uid).child("points")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ref.observe(.value) { [weak self] snapshot in
            //создаk массив для хранения задач, чтобы каждый раз проходя по циклу не дублировались записи
            var _points = Array<Point>()
            for item in snapshot.children {
                let point = Point(snapshot: item as! DataSnapshot)
                _points.append(point)
            }
            self?.points = _points
            self?.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return points.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pointCell") as! PointTableViewCell
        
        let point = points[indexPath.row]
        
        cell.nameLabel.text = point.name
       // cell.typeLabel.text = point.typeOfPond
        cell.coordinateLabel.text = point.coordinates
        
        
        //cell.imageOfPoint.image = UIImage(data: point.imageOfPoint!)
        

        cell.imageOfPoint.layer.cornerRadius = cell.imageOfPoint.frame.size.height / 2
        cell.imageOfPoint.clipsToBounds = true
        
        return cell
    }
    
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    @IBAction func signOutAction(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
        } catch {
            print (error.localizedDescription)
        }
        dismiss(animated: true)
    }
    
    @IBAction func unwindSegue (_ segue: UIStoryboardSegue) {
        
        guard let newPointVC = segue.source as? NewPointViewController else { return }
        newPointVC.saveNewPoint()
        let newPoint = newPointVC.newPoint!
        let pointRef = ref?.child(newPoint.name)
        //и теперь по этой ссылке помещаем нашу новую точку
        pointRef?.setValue(newPoint.convertToDictionary())
        points.append(newPointVC.newPoint!)

        tableView.reloadData()
    }
}
