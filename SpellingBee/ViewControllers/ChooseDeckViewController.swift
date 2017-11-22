//
//  ChooseDeckViewController.swift
//  SpellingBee
//
//  Created by Daniel Oberg on 2017-11-21.
//  Copyright © 2017 Daniel Oberg. All rights reserved.
//

import UIKit

import FacebookCore
import TGLParallaxCarousel

class ChooseDeckViewController: UIViewController, TGLParallaxCarouselDelegate {

    @IBOutlet weak var parallaxCarousel: TGLParallaxCarousel!

    var scrollView: UIScrollView!
    var stackView: UIStackView!
    
    lazy var decks = JapaneseDeck.all()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logoImage:UIImage = UIImage(named: "SmallLogo")!
        let imgTitleView = UIImageView(image: logoImage)
        imgTitleView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imgTitleView
        
        parallaxCarousel.delegate = self
        parallaxCarousel.margin = 0
        parallaxCarousel.selectedIndex = 0
        parallaxCarousel.carouselType = .threeDimensional
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func carouselView(_ carouselView: TGLParallaxCarousel, itemForRowAtIndex index: Int) -> TGLParallaxCarouselItem {
        let colors = [CardColor.blue, .green, .yellow, .purple, .orange]
        
        let card = CardView()
        card.frame.size = CGSize(width: 320, height: 420)
        card.setColor(color: colors[index])
        card.titleLabel.text = decks[index].name
        card.bigLabel.text = decks[index].short_name
        card.descriptionLabel.text = "\(decks[index].notes.count) notes"
        return card
    }
    
    func carouselView(_ carouselView: TGLParallaxCarousel, didSelectItemAtIndex index: Int) {
        self.performSegue(withIdentifier: "menuSegue", sender: self.parallaxCarousel)
    }
    
    func carouselView(_ carouselView: TGLParallaxCarousel, willDisplayItem item: TGLParallaxCarouselItem, forIndex index: Int) {
    }
    
    func numberOfItemsInCarouselView(_ carouselView: TGLParallaxCarousel) -> Int {
        return decks.count
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "menuSegue" {
            let controller = segue.destination as? MenuTableViewController
            let row = self.parallaxCarousel.selectedIndex
            controller?.deck = decks[row]
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.saveActivePack(pack: UUID(uuidString:decks[row].uuid)!)
            
            let event = AppEvent(name: "DeckChosen", parameters: [.custom("Deck Name"): decks[row].name, .custom("Deck UUID"): decks[row].uuid], valueToSum: nil)
            AppEventsLogger.log(event)
            
        }
    }
}
