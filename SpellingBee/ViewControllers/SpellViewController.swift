//
//  SpellViewController.swift
//  SpellingBee
//
//  Created by Daniel Oberg on 2017-10-07.
//  Copyright © 2017 Daniel Oberg. All rights reserved.
//

import UIKit
import AVKit

import SwiftRichString
import BulletinBoard
import FacebookCore

import SpeechFramework

class SpellViewController: UIViewController {
    @IBOutlet weak var kanaLabel: UILabel!
    @IBOutlet weak var englishLabel: UILabel!
    @IBOutlet weak var difficultySegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    var deck: JapaneseDeck!
    var words: [JapaneseWord]!
    
    var shouldShowHint = false
    
    var indexWord = 0
    var indexChar = 0
    var soundRecorder = SoundRecorderWrapper()
    var audioPlayer:AVAudioPlayer? = nil
    
    var spokenChars = 0
    var totalChars = 0
    
    var bulletinManager: BulletinManager? = nil
    
    var showKana: Bool { get {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.showKana()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let url = URL(fileURLWithPath: Bundle.main.path(forResource: "correct", ofType: "mp3")!)
            audioPlayer = try AVAudioPlayer(contentsOf: url)
        } catch {
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        words = deck.trainingList(amount: 10, trainIfNotViewed: true)
        totalChars = words.reduce(0, { (sum, w) -> Int in
            return w.listRomaji().count + sum
        })
        spokenChars = 0
        show(word: words[0])
        progressView.progress = 0.0
    }
    
    func showCharacters(shouldShowHint: Bool) {
        var toShow = self.words[self.indexWord].romaji
        
        if (self.showKana) {
            toShow = self.words[self.indexWord].kana
        }
        
        // Define your own used styles
        let black = Style("black", {
            $0.font = FontAttribute(FontName.HiraginoSans_W6, size: 30) // font + size
            $0.color = UIColor.black // text color
            $0.align = .center // align on center
        })
        
        let attributedString = toShow.set(style: black)
        self.kanaLabel.attributedText = attributedString
    }
    
    @IBAction func showAction(_ sender: Any) {
        self.shouldShowHint = true
        showCharacters(shouldShowHint: self.shouldShowHint)
    }
    
    @IBAction func valueChangedAction(_ sender: Any) {
        self.shouldShowHint = false
        let difficulty = Int16(difficultySegmentedControl.selectedSegmentIndex+1)
        let level = JapaneseWord.LevelType(rawValue: difficulty)
        self.words[self.indexWord].addToDB(level: level!, type: JapaneseWord.ActionType.spell)
        
        let fbParameters: [AppEventParameterName : AppEventParameterValueType]  = [AppEventParameterName.init("Kana"): self.words[self.indexWord].kana, AppEventParameterName.init("Level"): String(difficulty)]
        AppEventsLogger.log("SpellShownNewWord", parameters: fbParameters, valueToSum: Double(1.0))
        
        let isFinished = self.indexWord + 1 >= self.words.count
        if (!isFinished) {
            self.indexChar = 0
            self.indexWord += 1
            
            self.showNewAwards()
            
            self.show(word: self.words[self.indexWord])
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func show(word: JapaneseWord) {
        self.englishLabel.text = word.english
        self.kanaLabel.text = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        AppEventsLogger.log("SpellShown")

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if !appDelegate.isOnboardingFinished() {
            let page = PageBulletinItem(title: "Welcome")
            page.image = UIImage.fontAwesomeIcon(name: .info, textColor: UIColor.black, size: CGSize.init(width: 128, height: 128), backgroundColor: UIColor.white, borderWidth: 1.0, borderColor: UIColor.black)
            page.descriptionText = "Try to figure out the word and then click show. After you've seen the result you must rate how hard it was to remember to get to the next word."
            page.shouldCompactDescriptionText = true
            page.actionButtonTitle = "Let's do this"
            
            page.actionHandler = { (item: PageBulletinItem) in
                appDelegate.saveOnboardingFinished()
                item.manager?.dismissBulletin(animated: true)
            }
            
            bulletinManager = BulletinManager(rootItem: page)
            bulletinManager?.backgroundViewStyle = .blurredExtraLight
            bulletinManager?.prepare()
            bulletinManager?.presentBulletin(above: self)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.audioPlayer?.stop()
    }
    
    @IBAction func prepareForUnwindToRepeatSpelling(segue: UIStoryboardSegue){
        self.indexChar = 0
        self.indexWord = 0
    }
    
    func showNewAwards() {
        var pages = [PageBulletinItem]()
        for award in Awards.notShownButAwarded(words: (self.deck?.notes)!) {
            let page = PageBulletinItem(title: award.name)
            page.image = award.blackImage()
            page.descriptionText = award.desc.string
            page.actionButtonTitle = "Done"
            
            page.actionHandler = { (item: PageBulletinItem) in
                award.setShown()
                if item.nextItem == nil {
                    item.manager?.dismissBulletin(animated: true)
                } else {
                    item.displayNextItem()
                }
            }
            pages.append(page)
        }
        if pages.isEmpty {
            return
        }
        
        for i in pages.indices.dropLast() {
            pages[i].nextItem = pages[i+1]
        }
        
        bulletinManager = BulletinManager(rootItem: pages.first!)
        bulletinManager?.backgroundViewStyle = .blurredExtraLight
        bulletinManager?.prepare()
        bulletinManager?.presentBulletin(above: self)
    }
}
