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
import BulletinBoard


class ChooseDeckViewController: UIViewController, TGLParallaxCarouselDelegate {

    var bulletinManager: BulletinManager? = nil

    @IBOutlet weak var parallaxCarousel: TGLParallaxCarousel!

    var scrollView: UIScrollView!
    var stackView: UIStackView!
    
    lazy var decks = JapaneseDeck.all()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
                
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
    
    @IBAction func showSettings() {
        let page = PageBulletinItem(title: "Beginner or Intermediate")
        page.descriptionText = "If you can read Hiragana and Katakana then choose Intermediate."
        page.actionButtonTitle = "Beginner"
        page.alternativeButtonTitle = "Intermediate"
            
        page.actionHandler = { (item: PageBulletinItem) in
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.setShowKana(showRomaji: false)
            self.bulletinManager?.dismissBulletin(animated: true)
        }
        page.alternativeHandler = { (item: PageBulletinItem) in
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.setShowKana(showRomaji: true)
            self.bulletinManager?.dismissBulletin(animated: true)
        }
        
        bulletinManager = BulletinManager(rootItem: page)
        bulletinManager?.backgroundViewStyle = .blurredExtraLight
        bulletinManager?.prepare()
        bulletinManager?.presentBulletin(above: self)
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
