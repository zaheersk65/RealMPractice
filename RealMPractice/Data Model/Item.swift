//
//  Item.swift
//  RealMPractice
//
//  Created by IMAC on 9/25/19.
//  Copyright © 2019 IMAC. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title:String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateWise: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
