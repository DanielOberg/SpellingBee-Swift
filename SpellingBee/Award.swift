//
//  Awards.swift
//  SpellingBee
//
//  Created by Daniel Oberg on 2017-11-05.
//  Copyright © 2017 Daniel Oberg. All rights reserved.
//

import Foundation

import CoreData

import SwiftRichString
import FontAwesome_swift

protocol Award {
    var uuid: UUID {get}
    var name: String {get}
    var logo: String {get}
    var desc: NSAttributedString {get}
    
    func progress(words: [JapaneseWord]) -> Double
    func check(words: [JapaneseWord]) -> Bool
}

extension Award {
    func hasBeenShown() -> Bool {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let dataFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "AwardData")
        dataFetch.predicate = NSPredicate(format: "uuid == %@", self.uuid.uuidString)
        
        do {
            let fetchedData = try context.fetch(dataFetch) as! [AwardData]
            
            return !fetchedData.filter({ (data) -> Bool in
                return data.shown
            }).isEmpty
        } catch {
            fatalError("Failed to fetch Repetition Data: \(error)")
        }
        return false
    }
    
    func shownDate() -> Date? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let dataFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "AwardData")
        dataFetch.predicate = NSPredicate(format: "uuid == %@", self.uuid.uuidString)
        
        do {
            let fetchedData = try context.fetch(dataFetch) as! [AwardData]
            
            return fetchedData.filter({ (data) -> Bool in
                return data.shown
            }).first?.shownDate
        } catch {
            fatalError("Failed to fetch Repetition Data: \(error)")
        }
        return nil
    }
    
    func setShown() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let data = AwardData(context: context)
        data.shown = true
        data.uuid = self.uuid
        data.shownDate = Date()
        
        do {
            try context.save()
        } catch {
            fatalError("Failed to save Repetition Data: \(error)")
        }
    }
    
    func blackImage() -> UIImage {
        return UIImage.fontAwesomeIcon(name: FontAwesome(rawValue: self.logo)!, textColor: UIColor.black, size: CGSize(width: 128, height: 128))
    }
    
    func whiteImage() -> UIImage {
        return UIImage.fontAwesomeIcon(name: FontAwesome(rawValue: self.logo)!, textColor: UIColor.white, size: CGSize(width: 128, height: 128))
    }
}

class Awards {
    static let all: [Award] = [
        BeginnerAward(uuid: UUID(uuidString:"78481eec-c238-11e7-b781-06006d28d601")!),
        ReviewedXTimesAward(uuid: UUID(uuidString:"78481eec-c238-11e7-b781-06006d28d701")!, times: 5),
        ReviewedXTimesAward(uuid: UUID(uuidString:"78481eec-c238-11e7-b781-06006d28d702")!, times: 15),
        ReviewedXTimesAward(uuid: UUID(uuidString:"78481eec-c238-11e7-b781-06006d28d703")!, times: 30),
        ReviewedXTimesAward(uuid: UUID(uuidString:"78481eec-c238-11e7-b781-06006d28d704")!, times: 100),
        ReviewedXTimesAward(uuid: UUID(uuidString:"78481eec-c238-11e7-b781-06006d28d705")!, times: 300),
        ReviewedXTimesAward(uuid: UUID(uuidString:"78481eec-c238-11e7-b781-06006d28d706")!, times: 1000),
        ListenedXTimesAward(uuid: UUID(uuidString:"78481eec-c238-11e7-b781-06006d28d707")!, times: 10),
        ListenedXTimesAward(uuid: UUID(uuidString:"78481eec-c238-11e7-b781-06006d28d708")!, times: 20),
        ListenedXTimesAward(uuid: UUID(uuidString:"78481eec-c238-11e7-b781-06006d28d709")!, times: 150),
        ListenedXTimesAward(uuid: UUID(uuidString:"78481eec-c238-11e7-b781-06006d28d710")!, times: 400),
        ListenedXTimesAward(uuid: UUID(uuidString:"78481eec-c238-11e7-b781-06006d28d711")!, times: 750),
        AnimalInterestAward(uuid: UUID(uuidString:"78481eec-c238-11e7-b781-06006d28d712")!),
        AnimalLoverAward(uuid: UUID(uuidString:"78481eec-c238-11e7-b781-06006d28d713")!),
        SushiLoverAward(uuid: UUID(uuidString:"78481eec-c238-11e7-b781-06006d28d714")!)
    ]
    
    static let defStyle = Style("default", {
        $0.font = FontAttribute(FontName.HelveticaNeue_ThinItalic, size: 16)
        $0.color = UIColor.black
        $0.align = .center // align on center
    })
    
    static func notShownButAwarded(words: [JapaneseWord]) -> [Award] {
        JapaneseWord.cache = [String : [RepitionData]]()
        return notShown().filter({ (award) -> Bool in
            return award.check(words: words)
        })
    }
    
    static func notShown() -> [Award] {
        JapaneseWord.cache = [String : [RepitionData]]()
        return all.filter { (award) -> Bool in
            return !award.hasBeenShown()
        }
    }
    static func shown() -> [Award] {
        JapaneseWord.cache = [String : [RepitionData]]()
        return all.filter { (award) -> Bool in
            return award.hasBeenShown()
        }
    }
    
    static func latestAward(words: [JapaneseWord]) -> [Award] {
        let shown = Awards.shown().sorted { (a1, a2) -> Bool in
            return a1.shownDate()! > a2.shownDate()!
        }
        
        return notShownButAwarded(words:words) + shown
    }
}

class BeginnerAward: Award {
    let uuid: UUID
    let logo: String = ""
    let name: String
    let desc: NSAttributedString
    
    func check(words: [JapaneseWord]) -> Bool {
        return true
    }
    
    func progress(words: [JapaneseWord]) -> Double {
        return 1.0
    }
    
    init(uuid: UUID) {
        self.uuid = uuid
        self.name = "Beginner Award"
        self.desc = "Given to those who have started their journey into Japanese mastery!".set(style: Awards.defStyle)
    }
}

class ReviewedXTimesAward: Award {
    
    let uuid: UUID
    let times: Int
    let logo: String = ""
    let name: String
    let desc: NSAttributedString
    
    func check(words: [JapaneseWord]) -> Bool {
        let count = words.reduce(0) { (result, word) -> Int in
            return result + word.cachedLog().filter({ (rep) -> Bool in
                rep.type == JapaneseWord.ActionType.spell.rawValue
            }).count
        }
        
        return count >= times
    }
    
    func progress(words: [JapaneseWord]) -> Double {
        let count = words.reduce(0) { (result, word) -> Int in
            return result + word.cachedLog().filter({ (rep) -> Bool in
                rep.type == JapaneseWord.ActionType.spell.rawValue
            }).count
        }
        
        return min(1.0, Double(count)/Double(times))
    }
    
    init(uuid: UUID, times: Int) {
        self.uuid = uuid
        self.times = times
        self.name = "\(times) Reviews Award"
        self.desc = "Given to those who have made \(times) reviews".set(style: Awards.defStyle)
    }
}

class ListenedXTimesAward: Award {
    let uuid: UUID
    let times: Int
    let logo: String = ""
    let name: String
    let desc: NSAttributedString
    
    func check(words: [JapaneseWord]) -> Bool {
        let count = words.reduce(0) { (result, word) -> Int in
            return result + word.cachedLog().filter({ (rep) -> Bool in
                rep.type == JapaneseWord.ActionType.listen.rawValue
            }).count
        }
        
        return count >= times
    }
    
    func progress(words: [JapaneseWord]) -> Double {
        let count = words.reduce(0) { (result, word) -> Int in
            return result + word.cachedLog().filter({ (rep) -> Bool in
                rep.type == JapaneseWord.ActionType.listen.rawValue
            }).count
        }
        
        return min(1.0, Double(count)/Double(times))
    }
    
    init(uuid: UUID, times: Int) {
        self.uuid = uuid
        self.times = times
        self.name = "\(times) Listened Award"
        self.desc = "Given to those who have made listened to \(times) words".set(style: Awards.defStyle)
        
    }
}

class AnimalInterestAward: Award {
    let uuid: UUID
    var logo: String = ""
    var name: String = "Animal Interest"
    var desc: NSAttributedString = "Given to those who have reviewed or listened to 5 different animals".set(style: Awards.defStyle)
    
    func check(words: [JapaneseWord]) -> Bool {
        let count = words.reduce(0) { (result, word) -> Int in
            if !word.tags.contains("animal") { return result + 0 }
            else { return result + min(1, word.cachedLog().count) }
        }
        
        return count >= 5
    }
    
    func progress(words: [JapaneseWord]) -> Double {
        let count = words.reduce(0) { (result, word) -> Int in
            if !word.tags.contains("animal") { return result + 0 }
            else { return result + min(1, word.cachedLog().count) }
        }
        
        return min(1.0, Double(count)/5.0)
    }
    
    init(uuid: UUID) {
        self.uuid = uuid
    }
}

class AnimalLoverAward: Award {
    let uuid: UUID
    var logo: String = ""
    var name: String = "Animal Lover"
    var desc: NSAttributedString = "Given to those who have reviewed or listened to 15 different animals".set(style: Awards.defStyle)
    
    func check(words: [JapaneseWord]) -> Bool {
        let count = words.reduce(0) { (result, word) -> Int in
            if !word.tags.contains("animal") { return result + 0 }
            else { return result + min(1, word.cachedLog().count) }
        }
        
        return count >= 15
    }
    
    func progress(words: [JapaneseWord]) -> Double {
        let count = words.reduce(0) { (result, word) -> Int in
            if !word.tags.contains("animal") { return result + 0 }
            else { return result + min(1, word.cachedLog().count) }
        }
        
        return min(1.0, Double(count)/15.0)
    }
    
    init(uuid: UUID) {
        self.uuid = uuid
    }
}

class SushiLoverAward: Award {
    let uuid: UUID
    var logo: String = ""
    var name: String = "Sushi Eater"
    var desc: NSAttributedString = "Given to those who have reviewed or listened to 5 different sushiterms".set(style: Awards.defStyle)
    
    func check(words: [JapaneseWord]) -> Bool {
        let count = words.reduce(0) { (result, word) -> Int in
            if !word.tags.contains("sushi") { return result + 0 }
            else { return result + min(1, word.cachedLog().count) }
        }
        
        return count >= 5
    }
    
    func progress(words: [JapaneseWord]) -> Double {
        let count = words.reduce(0) { (result, word) -> Int in
            if !word.tags.contains("sushi") { return result + 0 }
            else { return result + min(1, word.cachedLog().count) }
        }
        
        return min(1.0, Double(count)/5.0)
    }
    
    init(uuid: UUID) {
        self.uuid = uuid
    }
}


