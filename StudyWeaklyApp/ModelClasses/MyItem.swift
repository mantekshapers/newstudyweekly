//
//  Item.swift
//  RealmSwift
//
//  Created by Riccardo Rizzo on 12/07/17.
//  Copyright © 2017 Riccardo Rizzo. All rights reserved.
//

import UIKit
import RealmSwift

class Item: Object {
    
    dynamic var ID = -1
    dynamic var textString = ""
    
    override static func primaryKey() -> String? {
        return "ID"
    }
    
}
