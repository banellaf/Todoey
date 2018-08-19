//
//  Item.swift
//  Todoey
//
//  Created by BANELLA Frederic on 18/08/2018.
//  Copyright © 2018 BANELLA Frederic. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
