//
//  ChooseDeckViewController.swift
//  SpellingBee
//
//  Created by Daniel Oberg on 2017-11-21.
//  Copyright © 2017 Daniel Oberg. All rights reserved.
//

import UIKit

import TGLParallaxCarousel

class ChooseDeckViewController: UIViewController {
    
    var scrollView: UIScrollView!
    var stackView: UIStackView!
    
    lazy var decks = JapaneseDeck.all()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logoImage:UIImage = UIImage(named: "SmallLogo")!
        let imgTitleView = UIImageView(image: logoImage)
        imgTitleView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imgTitleView
        
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[scrollView]|", options: .alignAllCenterX, metrics: nil, views: ["scrollView": scrollView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-30-[scrollView]|", options: .alignAllCenterX, metrics: nil, views: ["scrollView": scrollView]))
        
        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 0.0
        let spacing = (self.view.frame.size.width - CardView().intrinsicContentSize.width) / 2.0
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
        scrollView.addSubview(stackView)
        
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[stackView]|", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: ["stackView": stackView]))
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[stackView]", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: ["stackView": stackView]))
        
        let colors = [CardColor.blue, .green, .yellow, .purple, .orange]
        for i in 0 ..< decks.count {
            let card = CardView()
            card.frame.size = CGSize(width: 320, height: 420)
            card.setColor(color: colors[i])
            card.titleLabel.text = decks[i].name
            card.bigLabel.text = decks[i].short_name
            card.descriptionLabel.text = "\(decks[i].notes.count) notes"
            stackView.addArrangedSubview(card)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: stackView.frame.width, height: stackView.frame.height)
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
