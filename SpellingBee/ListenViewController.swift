//
//  ListenViewController.swift
//  SpellingBee
//
//  Created by Daniel Oberg on 2017-10-06.
//  Copyright © 2017 Daniel Oberg. All rights reserved.
//

import UIKit
import AVFoundation

class ListenViewController: UIViewController, AVSpeechSynthesizerDelegate {
    
    @IBOutlet weak var kanjiLabel: UILabel!
    @IBOutlet weak var romajiLabel: UILabel!
    @IBOutlet weak var hiraganaiLabel: UILabel!
    @IBOutlet weak var englishLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    var words: [JapaneseWord]!
    
    let speechSynth = AVSpeechSynthesizer()
    let speechSynthVoiceJP = AVSpeechSynthesisVoice(language: "ja-JP")
    let speechSynthVoiceEN = AVSpeechSynthesisVoice(language: "en-GB")
    
    var enLastSpeechUtterance: AVSpeechUtterance?
    
    var index = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        speechSynth.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        speak(word: words[index])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        show(word: words[index])
        progressView.progress = 0.0
    }
    
    func speak(word: JapaneseWord) {
        let utEn = AVSpeechUtterance(string: word.english)
        utEn.voice = speechSynthVoiceEN
        utEn.preUtteranceDelay = 0.1
        self.speechSynth.speak(utEn)
        let utJp = AVSpeechUtterance(string: word.kanji)
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
            index += 1
            
            progressView.progress = Float(index) / Float(words.count)
            
            if (index < words.count) {
                speak(word: words[index])
                show(word: words[index])
            } 
        }
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
