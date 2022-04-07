//
//  PointModel.swift
//  FishingPoints
//
//  Created by Roman Torry on 28.03.22.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth


struct Point {
    
    var name: String
    var coordinates: String?
    //var typeOfPond: String?
    var imageOfPoint: String?
    //var description: String?
    var rating: Double

    
    let userID: String
    let ref: DatabaseReference?

    
    init (name: String, rating: Double, userID: String, coordinates: String?, imageOfPoint: String?) {
        self.name = name
        self.coordinates = coordinates
        //self.typeOfPond = typeOfPond
        self.rating = rating
        self.imageOfPoint = imageOfPoint
        self.userID = userID
        //self.description = description
        self.ref = nil
    }
    
    init (snapshot: DataSnapshot) {
        let snapShotValue = snapshot.value as! [String: AnyObject]
        name = snapShotValue["name"] as! String
//        typeOfPond = snapShotValue["typeOfPond"] as? String
//        rating = snapShotValue["rating"] as! Double
//        imageOfPoint = snapShotValue["imageOfPoint"] as? Data
//        description = snapShotValue["description"] as? String
        rating = snapShotValue ["rating"] as! Double
        imageOfPoint = snapShotValue["photo"] as? String
        coordinates = snapShotValue ["coordinates"] as? String
        userID = snapShotValue["userID"] as! String
        ref = snapshot.ref
    }
    
    func convertToDictionary () -> Any {

        return ["name": self.name, "coordinates": self.coordinates as Any, "userID": self.userID, "photo": self.imageOfPoint as Any, "rating": self.rating] //, description": self.description, "imageOfPoint": self.imageOfPoint!, "rating": self.rating, "typeOfPond": self.typeOfPond]
    }
}
