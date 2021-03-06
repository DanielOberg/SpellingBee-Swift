//
//  ListenViewController.swift
//  SpellingBee
//
//  Created by Daniel Oberg on 2017-10-06.
//  Copyright © 2017 Daniel Oberg. All rights reserved.
//

import UIKit
import AVFoundation

import FacebookCore
import BulletinBoard

class ListenViewController: UIViewController, AVSpeechSynthesizerDelegate {
    
    @IBOutlet weak var kanjiLabel: UILabel!
    @IBOutlet weak var romajiLabel: UILabel!
    @IBOutlet weak var hiraganaiLabel: UILabel!
    @IBOutlet weak var englishLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    var deck: JapaneseDeck? = nil
    var words: [JapaneseWord] = []
    
    let speechSynth = AVSpeechSynthesizer()
    let speechSynthVoiceJP = AVSpeechSynthesisVoice(language: "ja-JP")
    let speechSynthVoiceEN = AVSpeechSynthesisVoice(language: "en-GB")
    
    var enLastSpeechUtterance: AVSpeechUtterance?
    
    var index = 0
    
    var bulletinManager: BulletinManager? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        speechSynth.delegate = self
        
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        let firstColor = UIColor(red:0.21, green:0.21, blue:0.33, alpha:1.0)
        let sndColor = UIColor(red:0.16, green:0.16, blue:0.28, alpha:1.0)
        gradient.colors = [firstColor.cgColor, sndColor.cgColor]
        view.layer.insertSublayer(gradient, at: 0)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.speechSynth.stopSpeaking(at: .immediate)
        self.speechSynth.delegate = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        AppEventsLogger.log("ListenShown")
        self.speechSynth.delegate = self
        if !words.isEmpty {
            speak(word: words[index])
        } else {
            let page = PageBulletinItem(title: "No difficult items left")
            
            page.descriptionText = "You have no words left tagged as hard or failed."
            page.actionButtonTitle = "Go back"
            
            page.image = UIImage.fontAwesomeIcon(name: .info, textColor: UIColor.black, size: CGSize.init(width: 128, height: 128), backgroundColor: UIColor.white, borderWidth: 1.0, borderColor: UIColor.black)
            
            page.actionHandler = { (item: PageBulletinItem) in
                item.manager?.dismissBulletin(animated:true)
                
                self.navigationController?.popViewController(animated: true)
            }
            
            bulletinManager = BulletinManager(rootItem: page)
            bulletinManager?.backgroundViewStyle = .blurredExtraLight
            bulletinManager?.prepare()
            bulletinManager?.presentBulletin(above: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        words = (deck?.trainingList(amount: 10, trainIfNotViewed: true))!
        if words.isEmpty {
            return
        }
        show(word: words[index])
        progressView.progress = 0.0
    }
    
    @IBAction func prepareForUnwindToRepeat(segue: UIStoryboardSegue){
        index = 0
    }
    
    func speak(word: JapaneseWord) {
        let utEn = AVSpeechUtterance(string: word.english)
        utEn.voice = speechSynthVoiceEN
        utEn.preUtteranceDelay = 0.1
        self.speechSynth.speak(utEn)
        let utJp = AVSpeechUtterance(string: word.kana)
        utJp.voice = speechSynthVoiceJP
        utJp.rate = (AVSpeechUtteranceDefaultSpeechRate - AVSpeechUtteranceMinimumSpeechRate) / 2 + AVSpeechUtteranceMinimumSpeechRate
        utJp.preUtteranceDelay = 0.2
        self.speechSynth.speak(utJp)
        let utJp2 = AVSpeechUtterance(string: word.kana)
        utJp2.voice = speechSynthVoiceJP
        utJp2.rate = (AVSpeechUtteranceDefaultSpeechRate - AVSpeechUtteranceMinimumSpeechRate) / 2 + AVSpeechUtteranceMinimumSpeechRate
        utJp2.preUtteranceDelay = 0.2
        self.speechSynth.speak(utJp2)
        enLastSpeechUtterance = AVSpeechUtterance(string: word.english)
        enLastSpeechUtterance?.voice = speechSynthVoiceEN
        enLastSpeechUtterance?.preUtteranceDelay = 0.1
        enLastSpeechUtterance?.postUtteranceDelay = 0.5
        self.speechSynth.speak(enLastSpeechUtterance!)
    }
    
    func show(word: JapaneseWord) {
        kanjiLabel.text = word.kanji
        hiraganaiLabel.text = word.kana
        englishLabel.text = word.english
        romajiLabel.text = word.romaji
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        if (enLastSpeechUtterance == utterance) {
            words[index].addToDB(level: .good, type: JapaneseWord.ActionType.listen)
        
            let fbParameters: [AppEventParameterName : AppEventParameterValueType]  = [AppEventParameterName.init("Kana"): self.words[index].kana]
            AppEventsLogger.log("ListenShownNewWord", parameters: fbParameters, valueToSum: Double(1.0))
            
            index += 1
            
            progressView.progress = Float(index) / Float(words.count)
            
            if (index >= words.count) {
                index = 0
            }
            
            speak(word: words[index])
            show(word: words[index])
        }
    }
    
}
