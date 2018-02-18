//
//  OnboardingViewController.swift
//  SpellingBee
//
//  Created by Daniel Oberg on 2018-02-18.
//  Copyright © 2018 Daniel Oberg. All rights reserved.
//

import UIKit
import paper_onboarding

class OnboardingViewController: UIViewController, PaperOnboardingDataSource, PaperOnboardingDelegate {
    
    @IBOutlet weak var onboarding: PaperOnboarding!
    @IBOutlet weak var skipButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        skipButton.isHidden = true
        onboarding.bringSubview(toFront: skipButton)
        onboarding.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func onboardingItemAtIndex(_ index: Int) -> OnboardingItemInfo {
        let titleFont = UIFont(name: "Nunito-Bold", size: 36.0) ?? UIFont.boldSystemFont(ofSize: 36.0)
        let descriptionFont = UIFont(name: "OpenSans-Regular", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
        return [
            (UIImage(named: "SmallLogo")!,
             "Voicefy",
             "Time to learn Japanese! Please read the instructions carefully",
             UIImage(named: "Key")!,
             UIColor(red:0.21, green:0.21, blue:0.33, alpha:1.0),
             UIColor.white, UIColor.white, titleFont,descriptionFont),
            
            (UIImage(named: "DeckSlanted")!,
             "Deck",
             "Start with choosing a deck. The deck contains all the words you will practice.",
             UIImage(named: "DeckSlantedCircle")!,
             UIColor(red:0.40, green:0.69, blue:0.71, alpha:1.00),
             UIColor.white, UIColor.white, titleFont,descriptionFont),
            
            (UIImage(named: "DeckSlanted")!,
             "JLPT Decks",
             "Japanese-Language Proficiency Test (JLPT) decks are for those who want to practice before their official japanes tests.",
             UIImage(named: "DeckSlantedCircle")!,
             UIColor(red:0.00, green:0.36, blue:0.73, alpha:1.0),
             UIColor.white, UIColor.white, titleFont,descriptionFont),
            
            (UIImage(named: "DeckSlanted")!,
             "Common Japanese Words Deck",
             "Choose Common Japanese Words if you are a beginner.",
             UIImage(named: "DeckSlantedCircle")!,
             UIColor(red:0.61, green:0.56, blue:0.74, alpha:1.00),
             UIColor.white, UIColor.white, titleFont,descriptionFont),
            
            (UIImage(named: "Kana")!,
             "Hiragana",
             "Know the Hiragana & Katakana alphabet? Click the cogwheel before choosing the deck.",
             UIImage(named: "KanaCircle")!,
             UIColor(red:0.00, green:0.36, blue:0.73, alpha:1.0),
             UIColor.white, UIColor.white, titleFont,descriptionFont),
            
            (UIImage(named: "Kana")!,
             "Spell",
             "In the spell view you tell the app which words you know and how well you have them memorised. To progress you have to go through the Spell view.",
             UIImage(named: "KanaCircle")!,
             UIColor(red:0.40, green:0.56, blue:0.71, alpha:1.00),
             UIColor.white, UIColor.white, titleFont,descriptionFont),
            
            (UIImage(named: "Mic")!,
             "Find Path",
             "Speak into the microphone one kana at a time, pausing after each kana.",
             UIImage(named: "MicCircle")!,
             UIColor(red:0.40, green:0.69, blue:0.71, alpha:1.00),
             UIColor.white, UIColor.white, titleFont,descriptionFont),
            
            (UIImage(named: "Mic")!,
             "Quiet room",
             "After speaking a small dot will change its color, if its changing all the time then move to a more quiet room",
             UIImage(named: "MicCircle")!,
             UIColor(red:0.00, green:0.36, blue:0.73, alpha:1.0),
             UIColor.white, UIColor.white, titleFont,descriptionFont),
            
            (UIImage(named: "SmallLogo")!,
             "Listen",
             "Listen to ten words. To progress to the next words do the Spelling test",
             UIImage(named: "Key")!,
             UIColor(red:0.61, green:0.56, blue:0.74, alpha:1.00),
             UIColor.white, UIColor.white, titleFont,descriptionFont),
            
            (UIImage(named: "SmallLogo")!,
             "Sorry",
             "Sorry for the amount of text you had to read! Are you ready? Click on continue.",
             UIImage(named: "Key")!,
             UIColor(red:0.21, green:0.21, blue:0.33, alpha:1.0),
             UIColor.white, UIColor.white, titleFont,descriptionFont),
            
            ][index]
    }
    
    func onboardingItemsCount() -> Int {
        return 10
    }
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        skipButton.isHidden = index == 9 ? false : true
    }
    
    func onboardingDidTransitonToIndex(_ index: Int) {
    }
    
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
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
