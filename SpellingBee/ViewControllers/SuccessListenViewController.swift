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
        barChart?.styleChart()
        chartBgView.addSubview(barChart!)
        barChart!.bindFrameToSuperviewBounds()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        barChart?.frame.size = self.chartBgView.frame.size

        let entries = JapaneseWord.graphData(type: JapaneseWord.ActionType.listen)
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
