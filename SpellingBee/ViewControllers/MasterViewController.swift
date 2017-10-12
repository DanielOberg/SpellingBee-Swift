//
//  MasterViewController.swift
//  SpellingBee
//
//  Created by Daniel Oberg on 2017-10-05.
//  Copyright © 2017 Daniel Oberg. All rights reserved.
//

import UIKit

import SpeechFramework

class MasterViewController: UITableViewController {
    @IBOutlet weak var nextButton: UIBarButtonItem!
    var objects = JapaneseWord.all()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.nextButton.isEnabled = self.tableView.indexPathsForSelectedRows != nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func autoSelect() {
        if let selectedItems = self.tableView.indexPathsForSelectedRows {
            for indexPath in selectedItems {
                self.tableView.deselectRow(at: indexPath, animated: true)
                tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
            }
        }
        
        for i in 0...objects.count-1 {
            let word = objects[i]
            let shouldTrain = word.shouldTrain()
            
            if shouldTrain {
                self.tableView.selectRow(at: IndexPath(row: i, section: 0), animated: true, scrollPosition: UITableViewScrollPosition.none)
            }
            
            if let count = self.tableView.indexPathsForSelectedRows?.count {
                if count >= 5 {
                    break;
                }
            }
        }
        
        if let rows = self.tableView.indexPathsForSelectedRows {
            for path in rows {
                tableView.cellForRow(at: path)?.accessoryType = UITableViewCellAccessoryType.checkmark
            }
        }
        self.nextButton.isEnabled = tableView.indexPathsForSelectedRows != nil
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "nextSegue" {
            let rows = self.tableView.indexPathsForSelectedRows!.map{objects[$0.row]}
            let controller = segue.destination as? MenuTableViewController
            controller?.words = rows
        }
    }

    // MARK: - Table View
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
        self.nextButton.isEnabled = tableView.indexPathsForSelectedRows != nil
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
        self.nextButton.isEnabled = tableView.indexPathsForSelectedRows != nil
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StandardCell", for: indexPath)

        let object = objects[indexPath.row]
        cell.textLabel!.text = object.english
        cell.detailTextLabel!.text = object.kana
        cell.accessoryType = UITableViewCellAccessoryType.none
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        if let isSelected = tableView.indexPathsForSelectedRows?.contains(indexPath) {
            if (isSelected) {
                cell.accessoryType = UITableViewCellAccessoryType.checkmark
            }
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}

