//
//  CardViewWhite.swift
//  SpellingBee
//
//  Created by Daniel Oberg on 2017-12-01.
//  Copyright © 2017 Daniel Oberg. All rights reserved.
//

import UIKit

@IBDesignable
class CardViewWhite: UIView {
    @IBOutlet weak var bgImg: UIImageView?

    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var bigLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBInspectable var cardImage: UIImage = #imageLiteral(resourceName: "CardWhiteStats") { didSet { self.bgImg?.image = cardImage } }
    
    override var intrinsicContentSize: CGSize { get { return CGSize(width: 258.0, height: 321.0) } }

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
//        view.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: 258.0, height: 321.0)

        self.addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CardViewWhite", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
}
