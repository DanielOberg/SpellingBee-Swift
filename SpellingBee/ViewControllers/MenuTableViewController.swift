//
//  MenuTableViewController.swift
//  SpellingBee
//
//  Created by Daniel Oberg on 2017-10-06.
//  Copyright © 2017 Daniel Oberg. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
    
    var words: [JapaneseWord]!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func prepareForUnwindToMenu(segue: UIStoryboardSegue){
        
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "listenSegue" {
            let controller = segue.destination as? ListenViewController
            controller?.words = words
        } else if segue.identifier == "pathSegue" {
            let controller = segue.destination as? PathViewController
            controller?.words = words
        } else if segue.identifier == "spellSegue" {
            let controller = segue.destination as? SpellViewController
            controller?.words = words
        }
    }
}
