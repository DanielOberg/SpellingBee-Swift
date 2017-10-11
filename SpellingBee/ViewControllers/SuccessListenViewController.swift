//
//  SuccessListenViewController.swift
//  SpellingBee
//
//  Created by Daniel Oberg on 2017-10-08.
//  Copyright © 2017 Daniel Oberg. All rights reserved.
//

import UIKit

import Charts

class SuccessListenViewController: UIViewController {
    
    @IBOutlet weak var chartBgView: UIView!
    
    var barChart: Charts.BarChartView? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red:0.21, green:0.21, blue:0.33, alpha:1.0)
        chartBgView.backgroundColor = UIColor(red:0.21, green:0.21, blue:0.33, alpha:1.0)
        
        barChart = Charts.BarChartView()
        barChart?.backgroundColor = UIColor(red:0.21, green:0.21, blue:0.33, alpha:1.0)
        barChart?.tintColor = UIColor.white
        barChart?.borderColor = UIColor.white
        barChart?.gridBackgroundColor = UIColor.white
        barChart?.noDataTextColor = UIColor.white
        barChart?.chartDescription?.textColor = UIColor.white
        barChart?.chartDescription?.text = ""
        barChart?.xAxis.enabled = true
        barChart?.legend.enabled = false
        barChart?.xAxis.drawGridLinesEnabled = false
        barChart?.drawBordersEnabled = true
        barChart?.getAxis(YAxis.AxisDependency.right).enabled = false
        barChart?.getAxis(YAxis.AxisDependency.left).enabled = false
        barChart?.xAxis.labelPosition = .bottom
        barChart?.xAxis.labelTextColor = UIColor.white
        barChart?.scaleYEnabled = false
        barChart?.scaleXEnabled = false
        barChart?.pinchZoomEnabled = false
        barChart?.doubleTapToZoomEnabled = false
        barChart?.highlighter = nil
        barChart?.leftAxis.axisMinimum = 0
        barChart?.xAxis.granularityEnabled = true
        barChart?.xAxis.granularity = 1.0
        chartBgView.addSubview(barChart!)
        
        barChart!.bindFrameToSuperviewBounds()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        barChart?.frame.size = self.chartBgView.frame.size
        var entries = [Charts.BarChartDataEntry]()

        let cal = Calendar.current
        // Get the date of 50 years ago today
        let stopDate = cal.date(byAdding: .day, value: -6, to: Date())!
        
        // We want to find dates that match on Sundays at midnight local time
        var comps = DateComponents()
        comps.hour = 1
        
        var days = 0
        entries.append(BarChartDataEntry(x: Double(days), y: Double(JapaneseWord.onDate(beforeDate: Date()).count)))
        // Enumerate all of the dates
        cal.enumerateDates(startingAfter: Date(), matching: comps, matchingPolicy: .previousTimePreservingSmallerComponents, repeatedTimePolicy: .first, direction: .backward) { (date, match, stop) in
            if let date = date {
                if date < stopDate {
                    stop = true // We've reached the end, exit the loop
                } else {
                    days -= 1
                    entries.append(BarChartDataEntry(x: Double(days), y: Double(JapaneseWord.onDate(beforeDate: date).count)))
                }
            }
        }

        let set = BarChartDataSet(values: entries, label: "days")
        set.colors = [UIColor.white]
        set.valueTextColor = UIColor.white
        set.valueFormatter = DefaultValueFormatter(decimals: 0)
        barChart?.data = BarChartData(dataSet: set)
        barChart?.animate(yAxisDuration: 1.0)
    }
    
    @IBAction func menuAction(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindSegue", sender: self)
    }
    
    @IBAction func repeatAction(_ sender: Any) {
        self.performSegue(withIdentifier: "repeatSegue", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
