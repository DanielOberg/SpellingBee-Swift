//
//  AwardCardView.swift
//  SpellingBee
//
//  Created by Daniel Oberg on 2017-12-02.
//  Copyright © 2017 Daniel Oberg. All rights reserved.
//

import UIKit

class AwardCardView: UIView {
    @IBOutlet weak var bgImg: UIImageView?
    
    @IBOutlet weak var middleView: UIImageView!
    @IBOutlet weak var bigLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override var intrinsicContentSize: CGSize { get { return CGSize(width: 206.0, height: 196.0) } }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.setup()
        
    }
    
    func setup() {
        let view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(UInt8(UIViewAutoresizing.flexibleWidth.rawValue) | UInt8(UIViewAutoresizing.flexibleHeight.rawValue)))
        
        view.backgroundColor = UIColor.clear
        self.addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "AwardCardView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
}
