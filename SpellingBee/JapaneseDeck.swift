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
}
