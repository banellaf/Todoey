//
//  Category.swift
//  Todoey
//
//  Created by BANELLA Frederic on 18/08/2018.
//  Copyright © 2018 BANELLA Frederic. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    //MARK: - Relashionship
    let items = List<Item>()
}
