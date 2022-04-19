//
//  NoteModel.swift
//  FishingPoints
//
//  Created by Roman Torry on 14.04.22.
//

import Foundation
import FirebaseDatabase

struct Note {
    
    var fishingDate: String
    var fishingPlace: String?
    var catchesCount: Int?
    var catches: [Catch]
    var notes: String?
    
    let ref: DatabaseReference?
    
    init(fishingDate: String, fishingPlace: String?, catchesCount: Int?, catches: [Catch], notes: String?) {
        self.fishingDate = fishingDate
        self.fishingPlace = fishingPlace
        self.catchesCount = catchesCount
        self.catches = catches
        self.notes = notes
        self.ref = nil
    }
    
    init (snapShot: DataSnapshot) {
        let snapShotValue = snapShot.value as! [String: AnyObject]
        
        fishingDate = snapShotValue["fishingDate"] as! String
        fishingPlace = snapShotValue["fishingPlace"] as? String
        catchesCount = snapShotValue["catchesCount"] as? Int
        catches = snapShotValue["catches"] as! [Catch]
        notes = snapShotValue["notes"] as? String
        ref = snapShot.ref
        
    }
    
}
