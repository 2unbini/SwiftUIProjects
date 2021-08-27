//
//  File.swift
//  ToDoList
//
//  Created by 권은빈 on 2021/08/24.
//

import Foundation

struct ToDo : Codable, Identifiable {
    var id: Int
    var title: String
    var category: String
    var targetFrom: String
    var targetTo: String
    var checked: Bool
}

struct SendToDo: Codable {
    var checked: Bool
    var title: String
}
