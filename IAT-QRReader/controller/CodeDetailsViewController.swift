//
//  CodeDetailsViewController.swift
//  IAT-QRReader
//
//  Created by Timon Sachweh on 11.12.17.
//  Copyright © 2017 Timon Sachweh. All rights reserved.
//

import UIKit

class CodeDetailsViewController: UIViewController {
    
    @IBOutlet weak var codeDetailsLabel: UILabel!
    
    @IBOutlet weak var timeOfScanLabel: UILabel!
    
    var readCode: ReadCode?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        codeDetailsLabel.text = readCode?.code
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        timeOfScanLabel.text = formatter.string(from: readCode?.readingDate as! Date)
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
