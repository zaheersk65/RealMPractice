//
//  Category.swift
//  RealMPractice
//
//  Created by IMAC on 9/25/19.
//  Copyright © 2019 IMAC. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name:String = ""
    //This is define a forward Relationship from cateory to list
    let items = List<Item>()   //Similar to array Here List is array like let array = Array<Int>()
    
}
