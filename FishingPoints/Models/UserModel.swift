//
//  UserModel.swift
//  FishingPoints
//
//  Created by Roman Torry on 4.04.22.
//

import Foundation
import Firebase
import FirebaseAuth

struct Users {
    
    let uid: String
    let email: String
    
    init (user: User) {
        self.uid = user.uid
        self.email = user.email!
    }
    
    
    
}
