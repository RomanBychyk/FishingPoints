//
//  CatchModel.swift
//  FishingPoints
//
//  Created by Roman Torry on 14.04.22.
//

import Foundation
import FirebaseDatabase

struct Catch {
    
    var fishKind: String
    var fishSize: String?
    var bait: String?
    var time: String?
    var temperature: Double?
    var pressure: Double?
    var location: String?
    var wethCond: String?
    
    let ref: DatabaseReference?
    
    init(fishKind: String, fishSize: String?, bait: String?, time: String?, temperature: Double?, pressure: Double?, location: String?, wethCond: String?) {
        self.fishKind = fishKind
        self.fishSize = fishSize
        self.bait = bait
        self.time = time
        self.temperature = temperature
        self.pressure = pressure
        self.location = location
        self.wethCond = wethCond
        
        ref = nil
    }
    
    init(snapShot: DataSnapshot) {
        let snapShotValue = snapShot.value as! [String: AnyObject]
        
        fishKind = snapShotValue["fishKind"] as! String
        fishSize = snapShotValue["fishSize"] as? String
        bait = snapShotValue["bait"] as? String
        time = snapShotValue["time"] as? String
        temperature = snapShotValue["temperature"] as? Double
        pressure = snapShotValue["pressure"] as? Double
        location = snapShotValue["location"] as? String
        wethCond = snapShotValue["wethCond"] as? String
        
        ref = snapShot.ref
        
    }
    
    func convertToDictionary () -> Any {
        
        return ["fishSize": self.fishSize as Any, "fishKind": self.fishKind, "bait": self.bait as Any, "time": self.time as Any, "temperature": self.temperature as Any, "pressure": self.pressure as Any, "location":self.location as Any, "wethCond": self.wethCond as Any]
    }
}
