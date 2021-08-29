//
//  File.swift
//  ToDoList
//
//  Created by 권은빈 on 2021/08/24.
//

import Foundation

// application data
class AppToDo: ObservableObject {
    @Published var list = [ToDo]()
}

// shared data
class ShareToDo: ObservableObject {
    @Published var list = [ToDo]()
}

struct ToDo : Codable, Identifiable {
    var id: Int64
    var title: String
    var category: String?
    var targetTo: Date?
    var targetFrom: Date?
    var checked: Bool
}

struct User: Codable, Identifiable {
    var id: Int64
    var name: String
    var email: String
    var password: String
}

struct SendToDo: Codable {
    var checked: Bool
    var title: String
}

struct SendUser: Codable {
    var name: String
    var email: String
    var password: String
}

struct ToggleToDo: Codable {
    var id: Int64
    var checked: Bool
    var title: String
}
