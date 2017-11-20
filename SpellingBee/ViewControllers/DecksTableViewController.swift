//
//  DecksTableViewController.swift
//  SpellingBee
//
//  Created by Daniel Oberg on 2017-11-01.
//  Copyright © 2017 Daniel Oberg. All rights reserved.
//

import UIKit
import FacebookCore


class DecksTableViewController: UITableViewController {
    
    lazy var decks = JapaneseDeck.all()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return decks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "deckIdentifier", for: indexPath)
        
        cell.detailTextLabel?.text = String(format:"%i notes", decks[indexPath.row].notes.count)
        cell.textLabel?.text = String(format:"%@ ⟩", decks[indexPath.row].name)
        
        return cell
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "menuSegue" {
            let controller = segue.destination as? MenuTableViewController
            if let row = self.tableView.indexPathForSelectedRow?.row {
                controller?.deck = decks[row]
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.saveActivePack(pack: UUID(uuidString:decks[row].uuid)!)
                
                let event = AppEvent(name: "DeckChosen", parameters: [.custom("Deck Name"): decks[row].name, .custom("Deck UUID"): decks[row].uuid], valueToSum: nil)
                AppEventsLogger.log(event)
            }
        }
    }
    
}
