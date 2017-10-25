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
    
    var words: [JapaneseWord]!
    var barChart: Charts.BarChartView? = nil

    @IBOutlet weak var toGoLabel: UILabel!
    @IBOutlet weak var rootChartView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        barChart = Charts.BarChartView()
        barChart?.styleChart()
        rootChartView.addSubview(barChart!)
        barChart!.bindFrameToSuperviewBounds()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.toGoLabel.text = String(format:"%d items to go", words.count)
        let entries = JapaneseWord.graphData()
        let set = BarChartDataSet(values: entries, label: "days")
        set.colors = [UIColor.white]
        set.valueTextColor = UIColor.white
        set.valueFormatter = DefaultValueFormatter(decimals: 0)
        barChart?.data = BarChartData(dataSet: set)
        barChart?.animate(yAxisDuration: 1.0)
    }
    
    @IBAction func prepareForUnwindToMenu(segue: UIStoryboardSegue){
        
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "listenSegue" {
            let controller = segue.destination as? ListenViewController
            controller?.words = words
        } else if segue.identifier == "pathSegue" {
            let controller = segue.destination as? PathViewController
            controller?.words = words
        } else if segue.identifier == "spellSegue" {
            let controller = segue.destination as? SpellViewController
            controller?.words = words
        }
    }
}
