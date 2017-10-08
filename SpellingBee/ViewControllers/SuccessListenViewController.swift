//
//  SuccessListenViewController.swift
//  SpellingBee
//
//  Created by Daniel Oberg on 2017-10-08.
//  Copyright © 2017 Daniel Oberg. All rights reserved.
//

import UIKit

class SuccessListenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func menuAction(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindSegue", sender: self)
    }
    
    @IBAction func repeatAction(_ sender: Any) {
        self.performSegue(withIdentifier: "repeatSegue", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
