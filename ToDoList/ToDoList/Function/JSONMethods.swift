//
//  JSONMethods.swift
//  ToDoList
//
//  Created by 권은빈 on 2021/08/29.
//

import Foundation

func checkJsonPretty(_ data: Data) {
    
    do {
        
        guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            print("Error: Cannot convert data to JSON object")
            return
        }
        
        guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
            print("Error: Cannot convert JSON object to Pretty JSON data")
            return
        }
        
        guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8)
        else {
            print("Error: Couldn't print JSON in String")
            return
        }
        
        print("-------Posted Data-------")
        print(prettyPrintedJson)
        print("-------------------------")
        
    } catch {
        
        print("Error: Trying to convert JSON data to string")
        return
        
    }
}
