//
//  PointsViewController.swift
//  FishingPoints
//
//  Created by Roman Torry on 28.03.22.
//

import UIKit

class PointsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let points = [Point(name: "Backwater", coordinate: "Pripyat", typeOfPond: "River", imageOfPoint: "")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return points.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pointCell") as! PointTableViewCell
        cell.nameLabel.text = points[indexPath.row].name
        cell.typeLabel.text = points[indexPath.row].typeOfPond
        cell.coordinateLabel.text = points[indexPath.row].coordinate
        
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

}
