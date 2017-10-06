//
//  JapaneseWord.swift
//  SpellingBee
//
//  Created by Daniel Oberg on 2017-10-06.
//  Copyright © 2017 Daniel Oberg. All rights reserved.
//

import Foundation

struct JapaneseWord: Codable {
    let hiragana: String
    let kanji: String
    let english: String
    let romaji: String
    
    static func all() -> [JapaneseWord] {
        let jsonData = try! Data(contentsOf: Bundle.main.url(forResource: "JapaneseWords", withExtension: "json")!)
        let decoder = JSONDecoder()
        let words = try! decoder.decode([JapaneseWord].self, from: jsonData)
        
        return words
    }
}
