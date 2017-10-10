//
//  JapaneseWordData.swift
//  SpellingBee
//
//  Created by Daniel Oberg on 2017-10-09.
//  Copyright © 2017 Daniel Oberg. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension JapaneseWord {
    enum ActionType: String {
        case listen = "LISTENED"
        case followPath = "FOLLOWED_PATH"
        case spell = "SPELLED"
    }
    
    static func startOfDay(beforeDate: Date) -> Date {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        let dateFrom = calendar.startOfDay(for: beforeDate)
        return dateFrom
    }
    
    static func onDate(beforeDate: Date) -> [RepitionData] {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let dataFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "RepitionData")
        dataFetch.predicate = NSPredicate(format: "date < %@", beforeDate as NSDate)
        
        do {
            let fetchedData = try context.fetch(dataFetch) as! [RepitionData]
            
            return fetchedData
        } catch {
            fatalError("Failed to fetch Repetition Data: \(error)")
        }
    }
    
    func times() -> Int64 {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        let dataFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "RepitionData")
        dataFetch.predicate = NSPredicate(format: "kana == %@ && kanji == %@", kana, kanji)
        
        do {
            let fetchedData = try context.fetch(dataFetch) as! [RepitionData]
            
            let times = fetchedData.reduce(0, { (result, d) -> Int64 in
                return max(result, d.times)
            })
            
            return times
        } catch {
            fatalError("Failed to fetch Repetition Data: \(error)")
        }
    }
    
    func addToDB(type: ActionType) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let data = RepitionData(context: context)
        data.date = Date()
        data.kana = self.kana
        data.kanji = self.kanji
        data.type = type.rawValue
        data.times = self.times() + 1

        do {
            try context.save()
        } catch {
            fatalError("Failed to save Repetition Data: \(error)")
        }
    }
}
