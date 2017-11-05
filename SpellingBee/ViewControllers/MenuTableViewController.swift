//
//  MenuTableViewController.swift
//  SpellingBee
//
//  Created by Daniel Oberg on 2017-10-06.
//  Copyright © 2017 Daniel Oberg. All rights reserved.
//

import UIKit

import Charts

class MenuTableViewController: UITableViewController {
    
    var deck: JapaneseDeck? = nil
    
    var barLevelsChart: Charts.BarChartView? = nil
    var barReviewChart: Charts.BarChartView? = nil

    @IBOutlet weak var rootLevelsChartView: UIView!
    @IBOutlet weak var rootReviewsChartView: UIView!
    
    @IBOutlet weak var reviewsTodayLabel: UILabel!
    @IBOutlet weak var reviewsAverageLabel: UILabel!
    @IBOutlet weak var reviewsTotalLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        barLevelsChart = Charts.BarChartView()
        barLevelsChart?.styleChart()
        rootLevelsChartView.addSubview(barLevelsChart!)
        barLevelsChart!.bindFrameToSuperviewBounds()
        
        barReviewChart = Charts.BarChartView()
        barReviewChart?.styleChart()
        rootReviewsChartView.addSubview(barReviewChart!)
        barReviewChart!.bindFrameToSuperviewBounds()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setLevelsChart()
        setReviewChart()
        reviewsToday()
        reviewsAverage()
    }
    
    func reviewsToday() {
        let count = JapaneseWord.onDate(date: Date(), type: .spell).count
        self.reviewsTodayLabel.text = String(format:"Today \t\t%d", count)
    }
    
    func reviewsAverage() {
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
        
        let avg = Double(count) / Double(components.day!+1)
        self.reviewsAverageLabel.text = String(format:"Average \t%.0f", avg)
        self.reviewsTotalLabel.text = String(format:"Total  \t\t%d", count)
    }
    
    func setReviewChart() {
        let entries = JapaneseWord.graphData(type: .spell)
        let set = BarChartDataSet(values: entries, label: "days")
        set.colors = [UIColor.white]
        set.valueTextColor = UIColor.white
        set.valueFormatter = DefaultValueFormatter(decimals: 0)
        
        var weekdays = [
            "Sunday",
            "Monday",
            "Tuesday",
            "Wednesday",
            "Thursday",
            "Friday",
            "Saturday",
        ]
        weekdays += weekdays
        
        barReviewChart?.xAxis.valueFormatter = IndexAxisValueFormatter(values: weekdays)
        
        barReviewChart?.data = BarChartData(dataSet: set)
        barReviewChart?.animate(yAxisDuration: 1.0)
    }
    
    func setLevelsChart() {
        let entries = JapaneseWord.graphDataLevels(japaneseDeck: deck!)
        let set = BarChartDataSet(values: entries, label: "level")
        set.colors = [UIColor.white]
        set.valueTextColor = UIColor.white
        barLevelsChart?.xAxis.valueFormatter = IndexAxisValueFormatter(values: ["New", "F", "E", "D", "C", "B", "A"])
        barLevelsChart?.data = BarChartData(dataSet: set)
        barLevelsChart?.animate(yAxisDuration: 1.0)
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
        }
    }
}
