//
//  File.swift
//  ToDoList
//
//  Created by 권은빈 on 2021/08/24.
//

import Foundation

// task structure

struct ToDo : Identifiable, Codable {
    var id = UUID()
    var toDo: String
    var checked: Bool
}
