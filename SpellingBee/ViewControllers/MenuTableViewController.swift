//
//  MenuTableViewController.swift
//  SpellingBee
//
//  Created by Daniel Oberg on 2017-10-06.
//  Copyright © 2017 Daniel Oberg. All rights reserved.
//

import UIKit

import Charts
import SwiftRichString
import BulletinBoard
import FacebookCore


class MenuTableViewController: UITableViewController {
    
    var deck: JapaneseDeck? = nil
    
    var barLevelsChart: Charts.BarChartView? = nil
    var barReviewChart: Charts.BarChartView? = nil
    
    @IBOutlet weak var rootLevelsChartView: CardViewWhite!
    @IBOutlet weak var rootReviewsChartView: CardViewWhite!
    
    @IBOutlet weak var reviewsTodayLabel: UILabel!
    
    @IBOutlet weak var latestAwardTitle: UILabel!
    @IBOutlet weak var latestAwardImage: UIImageView!
    @IBOutlet weak var latestAwardDesc: UILabel!
    
    var bulletinManager: BulletinManager? = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        barLevelsChart = Charts.BarChartView()
        barLevelsChart?.styleChart()
        rootLevelsChartView.middleView.addSubview(barLevelsChart!)
        rootLevelsChartView.bigLabel.text = "Level"
        barLevelsChart!.bindFrameToSuperviewBounds()
        
        barReviewChart = Charts.BarChartView()
        barReviewChart?.styleChart()
        rootReviewsChartView.middleView.addSubview(barReviewChart!)
        rootReviewsChartView.bigLabel.text = "Per Day"
        barReviewChart!.bindFrameToSuperviewBounds()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setLevelsChart()
        setReviewChart()
        reviewsToday()
        latestAward()
    }
    
    func latestAward() {
        let award = Awards.latestAward(words: self.deck!.notes).first!
        self.latestAwardImage.image = award.whiteImage()
        self.latestAwardTitle.text = award.name
        
        self.latestAwardDesc.text = award.desc.string
    }
    
    func reviewsToday() {
        var startDate = Date()
        var count = 0
        for word in self.deck!.notes {
            let filtered = word.log().filter({ (data) -> Bool in
                return data.type == JapaneseWord.ActionType.spell.rawValue
            })
            count += filtered.count
            
            if (filtered.first?.date ?? Date()) < startDate {
                startDate = (filtered.first?.date!)!
            }
        }
        
        let calendar = NSCalendar.current
        
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: Date())
        let date2 = calendar.startOfDay(for: startDate)
        
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        
        let avg = Double(count) / Double(abs(components.day!)+1)
        
        let todaysCount = JapaneseWord.onDate(date: Date(), type: .spell).count
        let avgStr = String(format:"%.0f", avg)
        let totalStr = String(format:"%d", count)
        
        self.reviewsTodayLabel.text = "Today you've done \(todaysCount) reviews, on average \(avgStr) reviews and in total \(totalStr) reviews.";
        
        rootReviewsChartView.titleLabel.text = "\(todaysCount) reviews today"
    }
    
    func setReviewChart() {
        let entries = JapaneseWord.graphData(type: .spell)
        let set = BarChartDataSet(values: entries, label: "days")
        set.colors = [UIColor(red:0.21, green:0.21, blue:0.33, alpha:1.0)]
        set.valueTextColor = UIColor(red:0.21, green:0.21, blue:0.33, alpha:1.0)
        set.valueFormatter = DefaultValueFormatter(decimals: 0)
        
        var weekdays = [
            "Sun",
            "Mon",
            "Tue",
            "Wed",
            "Thu",
            "Fri",
            "Sat",
            ]
        weekdays += weekdays
        
        barReviewChart?.xAxis.valueFormatter = IndexAxisValueFormatter(values: weekdays)
        barReviewChart?.xAxis.labelTextColor = UIColor(red:0.21, green:0.21, blue:0.33, alpha:1.0)
        barReviewChart?.data = BarChartData(dataSet: set)
        barReviewChart?.animate(yAxisDuration: 1.0)
    }
    
    func setLevelsChart() {
        let entries = JapaneseWord.graphDataLevels(japaneseDeck: deck!)
        let set = BarChartDataSet(values: entries, label: "level")
        set.colors = [UIColor(red:0.21, green:0.21, blue:0.33, alpha:1.0)]
        set.valueTextColor = UIColor(red:0.21, green:0.21, blue:0.33, alpha:1.0)
        barLevelsChart?.xAxis.valueFormatter = IndexAxisValueFormatter(values: ["New", "F", "E", "D", "C", "B", "A"])
        barLevelsChart?.xAxis.labelTextColor = UIColor(red:0.21, green:0.21, blue:0.33, alpha:1.0)
        barLevelsChart?.data = BarChartData(dataSet: set)
        barLevelsChart?.animate(yAxisDuration: 1.0)
        
        rootLevelsChartView.titleLabel.text = "\(Int(entries.first!.y)) to go"
    }
    
    func showNewAwards() {
        var pages = [PageBulletinItem]()
        for award in Awards.notShownButAwarded(words: (self.deck?.notes)!) {
            let page = PageBulletinItem(title: award.name)
            page.image = award.blackImage()
            page.descriptionText = award.desc.string
            page.actionButtonTitle = "Done"
            
            page.actionHandler = { (item: PageBulletinItem) in
                award.setShown()
                if item.nextItem == nil {
                    item.manager?.dismissBulletin(animated: true)
                } else {
                    item.displayNextItem()
                }
            }
            pages.append(page)
        }
        if pages.isEmpty {
            return
        }
        
        for i in pages.indices.dropLast() {
            pages[i].nextItem = pages[i+1]
        }
        
        bulletinManager = BulletinManager(rootItem: pages.first!)
        bulletinManager?.backgroundViewStyle = .blurredExtraLight
        bulletinManager?.prepare()
        bulletinManager?.presentBulletin(above: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showNewAwards()
        AppEventsLogger.log("MenuShown")
    }
    
    @IBAction func prepareForUnwindToMenu(segue: UIStoryboardSegue){
        
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "listenSegue" {
            let controller = segue.destination as? ListenViewController
            controller?.deck = self.deck
        } else if segue.identifier == "pathSegue" {
            let controller = segue.destination as? PathViewController
            controller?.deck = self.deck
        } else if segue.identifier == "spellSegue" {
            let controller = segue.destination as? SpellViewController
            controller?.deck = self.deck
        } else if segue.identifier == "awardsSegue" {
            let controller = segue.destination as? AwardsTableViewController
            controller?.deck = self.deck
        }
    }
}
