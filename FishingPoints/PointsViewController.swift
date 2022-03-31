//
//  PointsViewController.swift
//  FishingPoints
//
//  Created by Roman Torry on 28.03.22.
//

import UIKit

class PointsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var points = [Point(name: "Backwater", coordinate: "Pripyat", typeOfPond: "River", imageOfPoint: nil)]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return points.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pointCell") as! PointTableViewCell
        
        let point = points[indexPath.row]
        
        cell.nameLabel.text = point.name
        cell.typeLabel.text = point.typeOfPond
        cell.coordinateLabel.text = point.coordinate
        cell.imageOfPoint.image = point.imageOfPoint
        
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

    @IBAction func unwindSegue (_ segue: UIStoryboardSegue) {
        
        guard let newPointVC = segue.source as? NewPointViewController else { return }
        
        newPointVC.saveNewPoint()
        points.append(newPointVC.newPoint!)
        tableView.reloadData()
    }
}
