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
    @IBOutlet weak var kanjiLabel: UILabel!
    @IBOutlet weak var kanaLabel: UILabel!
    @IBOutlet weak var englishLabel: UILabel!
    @IBOutlet weak var speakingIndicatorLabel: UILabel!

    @IBOutlet weak var progressView: UIProgressView!
    
    var words: [JapaneseWord]!
    
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
        totalChars = words.reduce(0, { (sum, w) -> Int in
            return w.listRomaji().count + sum
        })
        spokenChars = 0
        show(word: words[0])
        progressView.progress = 0.0
    }
    
    func show(word: JapaneseWord) {
        self.kanjiLabel.text = word.kanji
        self.englishLabel.text = word.english
        self.kanaLabel.text = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        soundRecorder.onMadeSound = {data,probabilities in
            let color = UIColor(hue: CGFloat(drand48()), saturation: 1.0, brightness: 1.0, alpha: 1.0)
            self.speakingIndicatorLabel.textColor = color
            
            let firstFive = probabilities?.sorted(by: { (a, b) -> Bool in
                let aValue = (a.value as! NSNumber).floatValue
                let bValue = (b.value as! NSNumber).floatValue
                
                return aValue > bValue
            })[0...1]
            
            let romaji = self.words[self.indexWord].listRomaji()[self.indexChar]

            let containsRomaji = firstFive?.contains(where: { (a) -> Bool in
                return romaji == (a.key as! String)
            })
            
            _ = probabilities![romaji] as! NSNumber
            
            if (containsRomaji!) {
                self.kanaLabel.text = self.words[self.indexWord].listKana()[0...self.indexChar].reduce("", { (result, str) -> String in
                    return result + str
                })
                
                self.spokenChars += 1
                self.progressView.progress = Float(self.spokenChars)/Float(self.totalChars)
                self.audioPlayer?.play()
                
                let isNewWord = self.indexChar+1 >= self.words[self.indexWord].listRomaji().count
                if (isNewWord) {
                    self.words[self.indexWord].addToDB(type: JapaneseWord.ActionType.spell)

                    let isFinished = self.indexWord + 1 >= self.words.count
                    if (!isFinished) {
                        self.indexChar = 0
                        self.indexWord += 1
                        
                        self.show(word: self.words[self.indexWord])
                    } else {
                        self.performSegue(withIdentifier: "successSpellSegue", sender: self)
                    }
                } else {
                    self.indexChar += 1
                }
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
