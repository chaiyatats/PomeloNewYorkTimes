//
//  DataMockManager.swift
//  PomeloNewYorkTimesTests
//
//  Created by Chaiyatat Saiphin on 27/3/2565 BE.
//

import Foundation

class DataMockManager {
    
    static func getDataFromFile(name: String) -> [[String : Any]] {
        if let path = Bundle.main.path(forResource: name, ofType: "json")  {
            print("filename:\(path)")
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                print("jsonData:\(jsonResult)")
                if let jsonResult = jsonResult as? Dictionary <String, Any> {
                    return [jsonResult]
                } else if let jsonResult = jsonResult as? [Dictionary<String, Any>] {
                    return jsonResult
                }
            } catch {
                // handle error
                 print("parse error: \(error.localizedDescription)")
            }
        } else {
            print("Invalid filename/path. \(Bundle.main.bundlePath.description)")
        }
        return []
    }
}
