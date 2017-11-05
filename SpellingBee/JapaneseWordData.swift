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

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date? {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)
    }
    
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday! - 1
    }
    
    func dayOfTheWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
}

extension JapaneseWord {
    enum ActionType: String {
        case listen = "LISTENED"
        case followPath = "FOLLOWED_PATH"
        case spell = "SPELLED"
    }
    
    enum LevelType: Int16 {
        case fail = 1
        case hard = 2
        case good = 3
        case easy = 4
    }
    
    static func recall(lastlyTrained: Date, timesTrainedSinceFailureOrHard: Int, currentLevel: LevelType) -> Double {
        let deltaInMin = lastlyTrained.timeIntervalSinceNow / -60.0
        
        let min_a = 10.0
        let i = timesTrainedSinceFailureOrHard
        
        let x = deltaInMin
        var y = pow(2.0, -x / ((pow(2.0, Double(i)) * Double(i)) + min_a))
        
        if currentLevel == .easy {
            y = min(1.0, y * 1.5)
        } else if currentLevel == .good {
            y = min(1.0, y * 1.0)
        } else if currentLevel == .hard {
            y = min(1.0, y * 0.51)
        } else if currentLevel == .fail {
            y = min(1.0, y * 0.10)
        }
        
        return y
    }
    
    static func recall(repitionData: [RepitionData]) -> Double {
        var data = repitionData.filter { (data) -> Bool in
            return (data.type == ActionType.spell.rawValue)
        }
        if data.isEmpty {
            return 0.0
        }
        let lastlyTrained = data.last!.date!
        let currentLevel = data.last!.level
        var timesTrainedSinceFailureOrHard = 0
        
        for i in data.indices {
            if (data[i].level == LevelType.hard.rawValue || data[i].level == LevelType.fail.rawValue) {
                timesTrainedSinceFailureOrHard = 0
            } else {
                timesTrainedSinceFailureOrHard += 1
            }
        }
        return recall(lastlyTrained: lastlyTrained, timesTrainedSinceFailureOrHard: timesTrainedSinceFailureOrHard, currentLevel: JapaneseWord.LevelType(rawValue: currentLevel)!)
    }
    
    static func graphDataLevels(japaneseDeck: JapaneseDeck) -> [Charts.BarChartDataEntry] {
        var levels = [0, 0, 0, 0, 0, 0, 0]
        var entries = [Charts.BarChartDataEntry]()
        
        for word in japaneseDeck.notes {
            let log = word.log()
            if log.isEmpty {
                levels[0] += 1
                continue
            }
            let recall_ = JapaneseWord.recall(repitionData: log)
            let level = JapaneseWord.levelFromRecall(recall: recall_)
            levels[level] += 1
        }
        
        for i in levels.indices {
            let level = levels[i]
            let entry_ = BarChartDataEntry(x: Double(i), y: Double(level))
            entries.append(entry_)
        }
        
        return entries
    }
    
    static func levelFromRecall(recall: Double) -> Int {
        if (recall <= 0.5) {
            return 1
        } else if (recall <= 0.6) {
            return 2
        } else if (recall <= 0.7) {
            return 3
        } else if (recall <= 0.8) {
            return 4
        } else if (recall <= 0.9) {
            return 5
        }
        
        return 6
    }
    
    static func graphData(type: ActionType) -> [Charts.BarChartDataEntry] {
        var entries = [Charts.BarChartDataEntry]()
        
        let cal = Calendar.current
        let stopDate = cal.date(byAdding: .day, value: +1, to: Date())!
        let startDate = cal.date(byAdding: .day, value: -6, to: Date())!
        var comps = DateComponents()
        comps.hour = 23
        
        var day = -1
        cal.enumerateDates(startingAfter: startDate, matching: comps, matchingPolicy: .nextTimePreservingSmallerComponents, repeatedTimePolicy: .first, direction: .forward) { (date, match, stop) in
            if let date = date {
                let nr = date.dayNumberOfWeek()!
                
                if day == -1 {
                    day = nr
                }
                if date > stopDate {
                    stop = true
                } else {
                    entries.append(BarChartDataEntry(x: Double(day), y: Double(JapaneseWord.onDate(date: date, type: type).count)))
                    day += 1
                }
            }
        }
        return entries
    }
    
    
    static func onDate(date: Date, type: ActionType) -> [RepitionData] {
        let startOfDay = date.startOfDay
        let endOfDay = date.endOfDay!
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let dataFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "RepitionData")
        dataFetch.predicate = NSPredicate(format: "date > %@ && date < %@ && type == %@", startOfDay as NSDate, endOfDay as NSDate, type.rawValue)
        
        do {
            let fetchedData = try context.fetch(dataFetch) as! [RepitionData]
            return fetchedData
        } catch {
            fatalError("Failed to fetch Repetition Data: \(error)")
        }
    }
    
    func log() -> [RepitionData] {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let dataFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "RepitionData")
        dataFetch.predicate = NSPredicate(format: "kana == %@ && kanji == %@", kana, kanji)
        
        do {
            let fetchedData = try context.fetch(dataFetch) as! [RepitionData]
            
            return fetchedData
        } catch {
            fatalError("Failed to fetch Repetition Data: \(error)")
        }
    }
    
    func shouldTrain(trainIfNotViewed: Bool) -> Bool {
        let log = self.log()
        if log.isEmpty {
            return trainIfNotViewed
        }
        let log_active = log.filter { (data) -> Bool in
            return (data.type == ActionType.spell.rawValue)
        }
        if log_active.isEmpty {
            return true
        }
        
        return JapaneseWord.recall(repitionData: log_active) < 0.5
    }
    
    func addToDB(level: LevelType,type: ActionType) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let data = RepitionData(context: context)
        data.date = Date()
        data.kana = self.kana
        data.kanji = self.kanji
        data.type = type.rawValue
        data.level = level.rawValue
        
        do {
            try context.save()
        } catch {
            fatalError("Failed to save Repetition Data: \(error)")
        }
    }
}
