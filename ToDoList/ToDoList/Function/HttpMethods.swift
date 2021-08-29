//
//  HttpMethods.swift
//  ToDoList
//
//  Created by 권은빈 on 2021/08/29.
//

import Foundation

func getMethod(_ url: URL) {
    
}

func deleteMethod(_ url: URL) {
    
    var request = URLRequest(url: url)
    request.httpMethod = "DELETE"
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        
            guard error == nil else {
                print("Error: error calling DELETE")
                print(error!)
                return
            }
    
            guard let data = data else {
                print("Error: Did not receive data")
                print(error!)
                return
            }
    
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                print(error!)
                return
            }
        
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
            
            print("-------Deleted Data-------")
            print(prettyPrintedJson)
            print("--------------------------")
            
        } catch {
            
            print("Error: Trying to convert JSON data to string")
            return
            
        }
        
        }.resume()
}


func postMethod(_ url: URL, _ sendData: Data) {
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = sendData
    
    URLSession.shared.dataTask(with: request) { data, respose, error in
        
        guard error == nil else {
            print("Error: Error calling POST")
            print(error!)
            return
        }
        
        guard let data = data else {
            print("Error: Did not recieve Data")
            return
        }
        
        guard let response = respose as? HTTPURLResponse else {
            print("Error: HTTP request failed")
            return
        }
        
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
        
    }.resume()
}
