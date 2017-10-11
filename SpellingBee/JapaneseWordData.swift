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
import Charts

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
    
    static func graphData(type: ActionType) -> [Charts.BarChartDataEntry] {
        var entries = [Charts.BarChartDataEntry]()
        
        let cal = Calendar.current
        // Get the date of 50 years ago today
        let stopDate = cal.date(byAdding: .day, value: -6, to: Date())!
        
        // We want to find dates that match on Sundays at midnight local time
        var comps = DateComponents()
        comps.hour = 1
        
        var days = 0
        entries.append(BarChartDataEntry(x: Double(days), y: Double(JapaneseWord.onDate(beforeDate: Date(), type: type).count)))
        // Enumerate all of the dates
        cal.enumerateDates(startingAfter: Date(), matching: comps, matchingPolicy: .previousTimePreservingSmallerComponents, repeatedTimePolicy: .first, direction: .backward) { (date, match, stop) in
            if let date = date {
                if date < stopDate {
                    stop = true // We've reached the end, exit the loop
                } else {
                    days -= 1
                    entries.append(BarChartDataEntry(x: Double(days), y: Double(JapaneseWord.onDate(beforeDate: date, type: type).count)))
                }
            }
        }
        return entries
    }
    
    static func onDate(beforeDate: Date, type: ActionType) -> [RepitionData] {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let dataFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "RepitionData")
        dataFetch.predicate = NSPredicate(format: "date < %@ && type == %@", beforeDate as NSDate, type.rawValue)
        
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
