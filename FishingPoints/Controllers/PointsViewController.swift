//
//  PointsViewController.swift
//  FishingPoints
//
//  Created by Roman Torry on 28.03.22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage


class PointsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    private var points = Array<Point>()
    private var searchController = UISearchController(searchResultsController: nil)
    
    private var searchingPoints = Array<Point>()
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isSearching: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    private var user: Users!
    private var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let currentUser = Auth.auth().currentUser else { return }
        user = Users(user: currentUser)
        ref = Database.database(url: "https://fishingpoints-e0f7c-default-rtdb.firebaseio.com/") .reference(withPath: "users").child(user.uid).child("points")
        
        //Setup the search controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        definesPresentationContext = true
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ref.observe(.value) { [weak self] snapshot in
            //создал массив для хранения задач, чтобы каждый раз проходя по циклу не дублировались записи
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
        if isSearching {
            return searchingPoints.count
        }
        return points.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pointCell") as! PointTableViewCell
        
        var point: Point
        if isSearching {
            point = searchingPoints[indexPath.row]
        } else {
            point = points[indexPath.row]
        }
        
        cell.nameLabel.text = point.name
        cell.coordinateLabel.text = point.coordinates
        let decodeData = Data(base64Encoded: point.imageOfPoint!, options: .ignoreUnknownCharacters)!
        let decodedImage = UIImage(data: decodeData)
        cell.imageOfPoint.image = decodedImage
        cell.imageOfPoint.layer.cornerRadius = cell.imageOfPoint.frame.size.height / 2
        cell.imageOfPoint.clipsToBounds = true
        cell.cosmosView.rating = point.rating
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let point = points[indexPath.row]
            point.ref?.removeValue()
        }
    }
   
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            var point: Point
            if isSearching {
                point = searchingPoints[indexPath.row]
            } else {
                point = points[indexPath.row]
            }
            let newPointVC = segue.destination as! NewPointViewController
            newPointVC.currentPoint = point
            
        }
        
    }


    
    
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

extension PointsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        filterContentForSearchString(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchString (_ searchText: String) {
        searchingPoints = points.filter({ point in
            return point.name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
}
