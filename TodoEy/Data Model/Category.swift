//
//  Category.swift
//  TodoEy
//
//  Created by Anthony Ruiz on 6/13/18.
//  Copyright © 2018 Jakaboy. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
   @objc dynamic var name : String = ""
   let items = List<Item>()
}
