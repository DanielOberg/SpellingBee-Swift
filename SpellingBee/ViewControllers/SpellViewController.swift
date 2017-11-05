//
//  SpellViewController.swift
//  SpellingBee
//
//  Created by Daniel Oberg on 2017-10-07.
//  Copyright © 2017 Daniel Oberg. All rights reserved.
//

import UIKit
import AVKit

import SpeechFramework

class SpellViewController: UIViewController {
    @IBOutlet weak var kanaLabel: UILabel!
    @IBOutlet weak var englishLabel: UILabel!
    @IBOutlet weak var speakingIndicatorLabel: UILabel!
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
        let kanas = self.words[self.indexWord].listKana()
        var textBlack = ""
        if (0 <= self.indexChar-1) {
            textBlack = kanas[0...self.indexChar-1].reduce("", { (result, str) -> String in
                return result + str
            })
        }
        
        var textGray = ""
        
        if self.indexChar <= kanas.count-1 && shouldShowHint {
            textGray = kanas[self.indexChar...kanas.count-1].reduce("", { (result, str) -> String in
                return result + str
            })
        }
        
        let attributedString = NSAttributedString(html: "<center><font color=\"black\">\(textBlack)</font><font color=\"gray\">\(textGray)</font></center>")
        self.kanaLabel.attributedText = attributedString
    }
    
    @IBAction func showAction(_ sender: Any) {
        self.shouldShowHint = true
        showCharacters(shouldShowHint: self.shouldShowHint)
    }
    
    @IBAction func nextAction(_ sender: Any) {
        self.shouldShowHint = false
        let level = JapaneseWord.LevelType(rawValue: Int16(difficultySegmentedControl.selectedSegmentIndex+1))
        self.words[self.indexWord].addToDB(level: level!, type: JapaneseWord.ActionType.spell)
        
        let isFinished = self.indexWord + 1 >= self.words.count
        if (!isFinished) {
            self.indexChar = 0
            self.indexWord += 1
            
            self.show(word: self.words[self.indexWord])
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func valueChangedAction(_ sender: Any) {
        self.shouldShowHint = false
        let level = JapaneseWord.LevelType(rawValue: Int16(difficultySegmentedControl.selectedSegmentIndex+1))
        self.words[self.indexWord].addToDB(level: level!, type: JapaneseWord.ActionType.spell)
        
        let isFinished = self.indexWord + 1 >= self.words.count
        if (!isFinished) {
            self.indexChar = 0
            self.indexWord += 1
            
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
        soundRecorder.onMadeSound = {data,probabilities in
            let isNewWord = self.indexChar >= self.words[self.indexWord].listRomaji().count
            if isNewWord {
                return true
            }
            
            let color = UIColor(hue: CGFloat(drand48()), saturation: 1.0, brightness: 1.0, alpha: 1.0)
            self.speakingIndicatorLabel.textColor = color
            
            let firstFive = probabilities?.sorted(by: { (a, b) -> Bool in
                let aValue = (a.value as! NSNumber).floatValue
                let bValue = (b.value as! NSNumber).floatValue
                
                return aValue > bValue
            })[0...2]
            
            let romaji = self.words[self.indexWord].listRomaji()[self.indexChar]

            let containsRomaji = firstFive?.contains(where: { (a) -> Bool in
                return romaji == (a.key as! String)
            })
            
            let probability = probabilities![romaji] as! NSNumber
            
            NSLog("probability: %@", probability)
            NSLog("First: %@", firstFive!.debugDescription)
            
            if (containsRomaji!) {
                self.spokenChars += 1
                self.progressView.progress = Float(self.spokenChars)/Float(self.totalChars)
                self.audioPlayer?.play()
                
                self.indexChar += 1
                
                self.showCharacters(shouldShowHint: self.shouldShowHint)
                
                return true
            } else {
                return true
            }
        }
        soundRecorder.checkForPermissionAndStart()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.audioPlayer?.stop()
        self.soundRecorder.stop()
        self.soundRecorder.onMadeSound = nil
    }
    
    @IBAction func prepareForUnwindToRepeatSpelling(segue: UIStoryboardSegue){
        self.indexChar = 0
        self.indexWord = 0
    }
    
}
