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
    var notes: [JapaneseWord]
    
    static func all() -> [JapaneseDeck] {
        var result = [JapaneseDeck]()
        
        for filename in ["JapaneseWords", "JLPT-N5", "JLPT-N4", "JLPT-N3"] {
            let jsonData = try! Data(contentsOf: Bundle.main.url(forResource: filename, withExtension: "json")!)
            let decoder = JSONDecoder()
            if var deck = try? decoder.decode(JapaneseDeck.self, from: jsonData) {
                deck.notes = deck.notes.sorted(by: { (word1, word2) -> Bool in
                    var str1 = word1.kanji
                    if str1.isEmpty {
                        str1 = word1.kana
                    }
                    var str2 = word2.kanji
                    if str2.isEmpty {
                        str2 = word2.kana
                    }
                    return (WordFrequency.dict[str1] ?? 0) >= (WordFrequency.dict[str2] ?? 0)
                })
                result.append(deck)
                
                let encoder = JSONEncoder()
                if let enc = try? encoder.encode(deck) {
                    print(String(data: enc, encoding: .utf8) ?? "")
                }
            }
        }

        return result
    }
}
