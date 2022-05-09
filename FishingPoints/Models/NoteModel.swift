//
//  NoteModel.swift
//  FishingPoints
//
//  Created by Roman Torry on 14.04.22.
//

import Foundation
import FirebaseDatabase

struct Note {
    
    var fishingDate: String?
    var fishingPlace: String?
    var catchesCount: Int?
    var catches: [Catch]?
    var notesAboutTrip: String?
    
    let ref: DatabaseReference?
    
    init(fishingDate: String?, fishingPlace: String?, catchesCount: Int?, catches: [Catch]?, notesAboutTrip: String?) {
        self.fishingDate = fishingDate
        self.fishingPlace = fishingPlace
        self.catchesCount = catchesCount
        self.catches = nil//catches
        self.notesAboutTrip = notesAboutTrip
        self.ref = nil
    }
    
    init (snapShot: DataSnapshot) {
        let snapShotValue = snapShot.value as! [String: AnyObject]
        
        fishingDate = snapShotValue["fishingDate"] as? String
        fishingPlace = snapShotValue["fishingPlace"] as? String
        catchesCount = snapShotValue["catchesCount"] as? Int
        catches = snapShotValue["catches"] as? [Catch]
        notesAboutTrip = snapShotValue["notesAboutTrip"] as? String
        ref = snapShot.ref
        
    }
    
    func convertToDictionary () -> Any {
        return ["fishingDate": self.fishingDate as Any, "fishingPlace": self.fishingPlace as Any, "catchesCount": self.catchesCount as Any, "catches": catches as Any, "notesAboutTrip": self.notesAboutTrip as Any]
    }
    
}
