//
//  urlMethods.swift
//  ToDoList
//
//  Created by 권은빈 on 2021/08/29.
//

import Foundation

func getToDoUrl(_ param: String?) -> URL? {
    
    if param == nil {
        print("Error: param is nil")
        return nil
    }
    
    guard let url = URL(string: "http://34.64.87.191:8080/api/" + "todos/" + param!) else {
        print("Error: cannot create URL")
        return nil
    }
    
    return url
}

func getUserNameUrl(_ param: String?) -> URL? {
    
    if param == nil {
        print("Error: param is nil")
        return nil
    }
    
    guard let url = URL(string: "http://34.64.87.191:8080/api/" + "users/" + param!) else {
        print("Error: cannot create URL")
        return nil
    }
    
    return url
}

func getUserUrl() -> URL? {

    guard let url = URL(string: "http://34.64.87.191:8080/api/" + "users/") else {
        print("Error: cannot create URL")
        return nil
    }
    
    return url
}
