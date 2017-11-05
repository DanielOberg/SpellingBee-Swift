//
//  UIViewExtensions.swift
//  SpellingBee


import Foundation
import UIKit
import Charts

extension UIView {
    
    /// Adds constraints to this `UIView` instances `superview` object to make sure this always has the same size as the superview.
    /// Please note that this has no effect if its `superview` is `nil` – add this `UIView` instance as a subview before calling this.
    func bindFrameToSuperviewBounds() {
        guard let superview = self.superview else {
            print("Error! `superview` was nil – call `addSubview(view: UIView)` before calling `bindFrameToSuperviewBounds()` to fix this.")
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
    }
}

extension BarChartView {
    func styleChart() {
        self.backgroundColor = UIColor(red:0.21, green:0.21, blue:0.33, alpha:1.0)
        self.tintColor = UIColor.white
        self.borderColor = UIColor.white
        self.gridBackgroundColor = UIColor.white
        self.noDataTextColor = UIColor.white
        self.chartDescription?.textColor = UIColor.white
        self.chartDescription?.text = ""
        self.xAxis.enabled = true
        self.legend.enabled = false
        self.xAxis.drawGridLinesEnabled = false
        self.drawBordersEnabled = true
        self.getAxis(YAxis.AxisDependency.right).enabled = false
        self.getAxis(YAxis.AxisDependency.left).enabled = false
        self.xAxis.labelPosition = .bottom
        self.xAxis.labelTextColor = UIColor.white
        self.scaleYEnabled = false
        self.scaleXEnabled = false
        self.pinchZoomEnabled = false
        self.doubleTapToZoomEnabled = false
        self.highlighter = nil
        self.leftAxis.axisMinimum = 0
        self.xAxis.granularityEnabled = true
        self.xAxis.granularity = 1.0
        self.drawBordersEnabled = false
    }
}

extension NSAttributedString {
    
    internal convenience init?(html: String) {
        guard let data = html.data(using: String.Encoding.utf16, allowLossyConversion: false) else {
            return nil
        }
        
        guard let attributedString = try? NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) else {
            return nil
        }
        
        self.init(attributedString: attributedString)
    }
}
