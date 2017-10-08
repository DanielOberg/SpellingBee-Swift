//
//  PathViewController.swift
//  SpellingBee
//
//  Created by Daniel Oberg on 2017-10-07.
//  Copyright © 2017 Daniel Oberg. All rights reserved.
//

import Foundation
import UIKit
import GameplayKit

import SpeechFramework

class PathViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var kanaCollectionView: UICollectionView!
    @IBOutlet weak var kanjiLabel: UILabel!
    @IBOutlet weak var englishLabel: UILabel!
    @IBOutlet weak var speakingIndicatorLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var bgTopView: UIView!

    var words: [JapaneseWord]!
    
    static let MAX_SQUARES = 3;
    var path = [(Int, Int)]()
    var indexWord = 0
    var indexChar = 0
    var matrix = [[String]]()
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
        
        kanaCollectionView.dataSource = self
        kanaCollectionView.delegate = self;
    }
    
    override func viewDidLayoutSubviews() {
        let gradient = CAGradientLayer()
        gradient.frame = bgTopView.frame
        let firstColor = UIColor(red:0.21, green:0.21, blue:0.33, alpha:1.0)
        let sndColor = UIColor(red:0.14, green:0.14, blue:0.26, alpha:1.0)
        gradient.colors = [firstColor.cgColor, sndColor.cgColor]
        bgTopView.layer.insertSublayer(gradient, at: 0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        soundRecorder.onMadeSound = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        soundRecorder.onMadeSound = {data,probabilities in
            let color = UIColor(hue: CGFloat(drand48()), saturation: 1.0, brightness: 1.0, alpha: 1.0)
            self.speakingIndicatorLabel.textColor = color

            let firstFive = probabilities?.sorted(by: { (a, b) -> Bool in
                let aValue = (a.value as! NSNumber).floatValue
                let bValue = (b.value as! NSNumber).floatValue

                return aValue > bValue
            })[0...5]
            
            if (firstFive!.contains(where: { ($0.key as! String) == "xxx" })) { // Noise
                return false
            }
            
            let containsRomaji = firstFive?.contains(where: { (a) -> Bool in
                return self.words[self.indexWord].listRomaji()[self.indexChar] == (a.key as! String)
            })
            
            if (containsRomaji!) {
                let indexPath = NSIndexPath(row: self.path[self.indexChar].1, section: self.path[self.indexChar].0)
                let kanaCell = self.kanaCollectionView.cellForItem(at: indexPath as IndexPath) as! KanaLetterCollectionViewCell
                kanaCell.kanaLetterButton.backgroundColor = UIColor.red;
                kanaCell.kanaLetterButton.setNeedsDisplay()
                
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
    
    func show(word: JapaneseWord) {
        let wordSplitted = word.listKana()
        let allKana = JapaneseWord.listAllKatakana()+JapaneseWord.listAllHiragana()
        let shuffledKana = GKRandomSource.sharedRandom().arrayByShufflingObjects(in:allKana)
        
        var squares = [[String]]()
        for i in 0...PathViewController.MAX_SQUARES-1 {
            squares.append([String]())
            for _ in 0...PathViewController.MAX_SQUARES-1 {
                squares[i].append("")
            }
        }
        
        let startX = arc4random_uniform(UInt32(PathViewController.MAX_SQUARES));
        let startY = arc4random_uniform(UInt32(PathViewController.MAX_SQUARES));
        
        let path = PathViewController.recRandomPath(kanas: wordSplitted[...], xv: Int(startX), yv: Int(startY), result: [])
        
        for i in 0...path.count-1 {
            let p = path[i];
            squares[p.0][p.1] = wordSplitted[i];
        }
        
        for i in 0...PathViewController.MAX_SQUARES-1 {
            for j in 0...PathViewController.MAX_SQUARES-1 {
                if (squares[i][j] == "") {
                    squares[i][j] = shuffledKana[j + (i * PathViewController.MAX_SQUARES)] as! String;
                }
            }
        }
        
        self.path = path;
        self.matrix = squares
        
        self.kanjiLabel.text = word.kanji
        self.englishLabel.text = word.english
        
        self.kanaCollectionView.reloadData()
    }
    
    static func recRandomPath(kanas: ArraySlice<String>, xv: Int, yv: Int, result: [(Int, Int)]) -> [(Int, Int)] {
        let directions = GKRandomSource.sharedRandom().arrayByShufflingObjects(in:[(0, 1), (-1, 0), (0, 0), (1, 0), (0, -1)]) as! [(Int, Int)]
        
        if (kanas.count == 0) {
            return result;
        }
        
        for  i in 0...directions.count {
            let X = xv + directions[i].0;
            let Y = yv + directions[i].1;
            
            if (X >= MAX_SQUARES || Y >= MAX_SQUARES || X < 0 || Y < 0) {
                continue;
            }
            
            let hasDuplicate = result.first {
                return ($0.0 == X) && ($0.1 == Y);
            };
            
            if (hasDuplicate != nil) {
                continue;
            }
            
            var newResult = result
            newResult.append((X,Y))
            
            let r = PathViewController.recRandomPath(kanas: kanas.dropFirst(), xv: X, yv: Y, result: newResult);
            if (!r.isEmpty) {
                return r;
            }
        }
        return [];
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KanaLetter", for: indexPath) as! KanaLetterCollectionViewCell
        cell.kanaLetterButton.setTitle(self.matrix[indexPath.section][indexPath.row], for: UIControlState.normal)
        cell.kanaLetterButton.layer.masksToBounds = true;
        cell.kanaLetterButton.layer.cornerRadius = collectionView.frame.size.width/CGFloat(PathViewController.MAX_SQUARES) / 2.375;
        
        cell.kanaLetterButton.backgroundColor = UIColor.black;
        if (self.path.first?.0 == indexPath.section && self.path.first?.1 == indexPath.row) {
            cell.kanaLetterButton.backgroundColor = UIColor.gray;
        }
        
        cell.kanaLetterButton.isEnabled = false;
        
        for point in self.path {
            if (point.0 == indexPath.section && point.1 == indexPath.row) {
                cell.kanaLetterButton.isEnabled = true;
            }
        }
        cell.kanaLetterButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PathViewController.MAX_SQUARES
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return PathViewController.MAX_SQUARES
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthOfCell = collectionView.frame.size.width/CGFloat(PathViewController.MAX_SQUARES);
        let heightOfCell = widthOfCell;
        let returnValue = CGSize(width: widthOfCell, height: heightOfCell);
        return returnValue;
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
