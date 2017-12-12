//
//  FilterViewController.swift
//  IAT-QRReader
//
//  Created by Timon Sachweh on 11.12.17.
//  Copyright © 2017 Timon Sachweh. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {

    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var beginPicker: UIDatePicker!
    @IBOutlet weak var endPicker: UIDatePicker!
    
    var beginDate:Date?
    var endDate:Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        popupView.layer.cornerRadius = 10
        popupView.layer.masksToBounds = true
        beginPicker.datePickerMode = .dateAndTime
        endPicker.datePickerMode = .dateAndTime
        
        if let begin = beginDate {
            beginPicker.setDate(begin, animated: true)
        }
        if let end = endDate {
            endPicker.setDate(end, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func applyFilterButtonClicked(_ sender: Any) {
        let values = FilterValues(minDate: beginPicker.date, maxDate: endPicker.date)
        NotificationCenter.default.post(name: NSNotification.Name("filterValues"), object: values)
        
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first?.view != popupView {
            dismiss(animated: true, completion: nil)
        }
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
