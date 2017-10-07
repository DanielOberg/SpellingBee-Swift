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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
