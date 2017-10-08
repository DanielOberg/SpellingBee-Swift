//
//  KanaLetterCollectionViewCell.swift
//  SpellingBee
//
//  Created by Daniel Oberg on 2017-10-07.
//  Copyright © 2017 Daniel Oberg. All rights reserved.
//

import UIKit

class KanaLetterCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var kanaLetterButton: UIButton!
    @IBAction func kanaLetterPress(_ sender: Any) {
        self.kanaLetterButton.backgroundColor = UIColor.gray
    }
}
