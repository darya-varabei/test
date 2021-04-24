//
//  MedicationModel.swift
//  Pillquipo
//
//  Created by Дарья Воробей on 4/23/21.
//

import Foundation
import SwiftUI
import Firebase


class MedicationModel: ObservableObject, Codable{
    enum CodingKeys: CodingKey{
        
        case product_ndc, generic_name, labeler_name, dosage_form, userId, start_date, finish_date, doze, time, state
    }

    @Published var product_ndc = ""
    @Published var generic_name = ""
    @Published var labeler_name = ""
    @Published var dosage_form = "Capsule"
    @Published var userId = ""
    @Published var start_date = Date()
    @Published var finish_date = Date()
    @Published var doze = ""
    @Published var time = Date()
    @Published var state = false
//    @Published var daysOn = 0
//    @Published var daysOff = 0
    
    init() { }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        product_ndc = try container.decode(String.self, forKey: .product_ndc)
        generic_name = try container.decode(String.self, forKey: .generic_name)

        labeler_name = try container.decode(String.self, forKey: .labeler_name)
        dosage_form = try container.decode(String.self, forKey: .dosage_form)

        userId = try container.decode(String.self, forKey: .userId)
        start_date = try container.decode(Date.self, forKey: .start_date)
        finish_date = try container.decode(Date.self, forKey: .finish_date)
        doze = try container.decode(String.self, forKey: .doze)
        time = try container.decode(Date.self, forKey: .time)
        state = try container.decode(Bool.self, forKey: .state)
//        daysOn = try container.decode(Int.self, forKey: .daysOn)
//        daysOff = try container.decode(Int.self, forKey: .daysOff)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(product_ndc, forKey: .product_ndc)
        try container.encode(generic_name, forKey: .generic_name)

        try container.encode(labeler_name, forKey: .labeler_name)
        try container.encode(dosage_form, forKey: .dosage_form)

        try container.encode(userId, forKey: .userId)
        try container.encode(start_date, forKey: .start_date)
        try container.encode(finish_date, forKey: .finish_date)
        try container.encode(doze, forKey: .doze)
        try container.encode(time, forKey: .time)
        try container.encode(state, forKey: .state)
//        try container.encode(daysOn, forKey: .daysOn)
//        try container.encode(daysOff, forKey: .daysOff)
    }
    
    func validation() -> Bool{
        if self.generic_name == "" ||  self.start_date >= self.finish_date{
            Alert(title: Text("Invalid input"), message: Text("Fill the content properly!"), dismissButton: .destructive(Text("Ok")))
            return false
        }
        else{
        return true
        }
    }
    func postMethod() {
        if self.validation(){
            guard let url = URL(string: "https://my-json-server.typicode.com/darya-varabei/pillquipo") else {
                print("Error: cannot create URL")
                return
            }
            guard let jsonData = try? JSONEncoder().encode(self) else {
                print("Error: Trying to convert model to JSON data")
                return
            }
            // Create the url request
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type") // the request is JSON
            request.setValue("application/json", forHTTPHeaderField: "Accept") // the response expected to be in JSON format
            request.httpBody = jsonData
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard error == nil else {
                    print("Error: error calling POST")
                    print(error!)
                    return
                }
                guard let data = data else {
                    print("Error: Did not receive data")
                    return
                }
                guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
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
                    guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                        print("Error: Couldn't print JSON in String")
                        return
                    }
                    
                    print(prettyPrintedJson)
                } catch {
                    print("Error: Trying to convert JSON data to string")
                    return
                }
            }.resume()
        }
        else{
            return
        }
        }
    
    func getMethod() {
            guard let url = URL(string: "http://localhost:8080/api/medication") else {
                print("Error: cannot create URL")
                return
            }
            // Create the url request
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard error == nil else {
                    print("Error: error calling GET")
                    print(error!)
                    return
                }
                guard let data = data else {
                    print("Error: Did not receive data")
                    return
                }
                guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
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
                    guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                        print("Error: Could print JSON in String")
                        return
                    }
                    
                    print(prettyPrintedJson)
                } catch {
                    print("Error: Trying to convert JSON data to string")
                    return
                }
            }.resume()
        }
    
    func putMethod() {
        if self.validation(){
            guard let url = URL(string: "http://localhost:8080/api/medication") else {
                print("Error: cannot create URL")
                return
            }
            // Convert model to JSON data
            guard let jsonData = try? JSONEncoder().encode(self) else {
                print("Error: Trying to convert model to JSON data")
                return
            }
            
            // Create the request
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard error == nil else {
                    print("Error: error calling PUT")
                    print(error!)
                    return
                }
                guard let data = data else {
                    print("Error: Did not receive data")
                    return
                }
                guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
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
                    guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                        print("Error: Could print JSON in String")
                        return
                    }
                    
                    print(prettyPrintedJson)
                } catch {
                    print("Error: Trying to convert JSON data to string")
                    return
                }
            }.resume()
        }
        else{
            return
        }
        }
    
    func deleteMethod() {
            guard let url = URL(string: "http://localhost:8080/api/medication") else {
                print("Error: cannot create URL")
                return
            }
            // Create the request
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
                    return
                }
                guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                    print("Error: HTTP request failed")
                    return
                }
                do {
                    guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                        print("Error: Cannot convert data to JSON")
                        return
                    }
                    guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                        print("Error: Cannot convert JSON object to Pretty JSON data")
                        return
                    }
                    guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                        print("Error: Could print JSON in String")
                        return
                    }
                    
                    print(prettyPrintedJson)
                } catch {
                    print("Error: Trying to convert JSON data to string")
                    return
                }
            }.resume()
        }
}



