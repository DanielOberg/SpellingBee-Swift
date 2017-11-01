//
//  Deck.swift
//  SpellingBee
//
//  Created by Daniel Oberg on 2017-10-31.
//  Copyright © 2017 Daniel Oberg. All rights reserved.
//

import Foundation

struct JapaneseDeck: Codable {
    let uuid: String
    let name: String
    let notes: [JapaneseWord]
    
    static func all() -> [JapaneseDeck] {
        var result = [JapaneseDeck]()
        
        for filename in ["JapaneseWords", "JLPT-N5", "JLPT-N4", "JLPT-N3"] {
            let jsonData = try! Data(contentsOf: Bundle.main.url(forResource: filename, withExtension: "json")!)
            let decoder = JSONDecoder()
            if let deck = try? decoder.decode(JapaneseDeck.self, from: jsonData) {
                result.append(deck)
            }
        }

        return result
    }
}
