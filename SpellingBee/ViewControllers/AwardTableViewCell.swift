//
//  AwardTableViewCell.swift
//  SpellingBee
//
//  Created by Daniel Oberg on 2017-11-05.
//  Copyright © 2017 Daniel Oberg. All rights reserved.
//

import UIKit

class AwardTableViewCell: UITableViewCell {
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(award: Award, words: [JapaneseWord]) {
        logoImageView.image = award.whiteImage()
        titleLabel.text = award.name
        descLabel.text = award.desc.string
        progressView.progress = Float(award.progress(words: words))
    }

}
