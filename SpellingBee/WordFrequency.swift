//
//  WordFrequency.swift
//  SpellingBee
//
//  Created by Daniel Oberg on 2017-11-02.
//  Copyright © 2017 Daniel Oberg. All rights reserved.
//

import Foundation

struct WordFrequency: Codable {
    let word: String
    let frequency: Int64
    
    static let dict = toDictionary(input: all())
    
    static func all() -> [WordFrequency] {
        var result = [WordFrequency]()
        
            let jsonData = try! Data(contentsOf: Bundle.main.url(forResource: "Word-Frequency", withExtension: "json")!)
            let decoder = JSONDecoder()
            if let words = try? decoder.decode([WordFrequency].self, from: jsonData) {
                result.append(contentsOf: words)
            }
        
        return result
    }
    
    static func toDictionary(input: [WordFrequency]) -> [String: Int64] {
        var result = [String: Int64]()
        
        for item in input {
            result[item.word] = item.frequency
        }
        
        return result
    }
}
