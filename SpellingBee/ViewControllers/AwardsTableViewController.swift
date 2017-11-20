//
//  AwardsTableViewController.swift
//  SpellingBee
//
//  Created by Daniel Oberg on 2017-11-05.
//  Copyright © 2017 Daniel Oberg. All rights reserved.
//

import UIKit

import FacebookCore

class AwardsTableViewController: UITableViewController {
    
    var deck: JapaneseDeck!
    var awards = [Awards.shown(), Awards.notShown()]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return awards[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "awardIdentifier", for: indexPath) as! AwardTableViewCell
        
        cell.set(award: awards[indexPath.section][indexPath.row], words: deck.notes)

        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        AppEventsLogger.log("AwardsShown")
    }

}
