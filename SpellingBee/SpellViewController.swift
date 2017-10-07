//
//  SpellViewController.swift
//  SpellingBee
//
//  Created by Daniel Oberg on 2017-10-07.
//  Copyright © 2017 Daniel Oberg. All rights reserved.
//

import UIKit

import SpeechFramework

class SpellViewController: UIViewController {
    @IBOutlet weak var kanjiLabel: UILabel!
    @IBOutlet weak var kanaLabel: UILabel!
    @IBOutlet weak var englishLabel: UILabel!

    @IBOutlet weak var progressView: UIProgressView!
    
    var words: [JapaneseWord]!
    
    var indexWord = 0
    var indexChar = 0
    var soundRecorder = SoundRecorderWrapper()
    
    var spokenChars = 0
    var totalChars = 0


    override func viewDidLoad() {
        super.viewDidLoad()

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
            
            let firstFive = probabilities?.sorted(by: { (a, b) -> Bool in
                let aValue = (a.value as! NSNumber).floatValue
                let bValue = (b.value as! NSNumber).floatValue
                
                return aValue > bValue
            })[0...5]
            
            let containsRomaji = firstFive?.contains(where: { (a) -> Bool in
                return self.words[self.indexWord].listRomaji()[self.indexChar] == (a.key as! String)
            })
            
            if (containsRomaji!) {
                self.kanaLabel.text = self.words[self.indexWord].listKana()[0...self.indexChar].reduce("", { (result, str) -> String in
                    return result + str
                })
                
                self.spokenChars += 1
                self.progressView.progress = Float(self.spokenChars)/Float(self.totalChars)
                
                let isNewWord = self.indexChar+1 >= self.words[self.indexWord].listRomaji().count
                if (isNewWord) {
                    let isFinished = self.indexWord + 1 >= self.words.count
                    if (!isFinished) {
                        self.indexChar = 0
                        self.indexWord += 1
                        
                        self.show(word: self.words[self.indexWord])
                    }
                } else {
                    self.indexChar += 1
                }
                return true
            } else {
                return false
            }
        }
        soundRecorder.checkForPermissionAndStart()
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
