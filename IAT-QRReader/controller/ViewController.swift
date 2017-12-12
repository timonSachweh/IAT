//
//  ViewController.swift
//  IAT-QRReader
//
//  Created by Timon Sachweh on 11.12.17.
//  Copyright © 2017 Timon Sachweh. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var videoPreview: UIView!
    private var videoLayer: CALayer!
    @IBOutlet weak var lastScannedLabel: UILabel!
    
    var lastScanTime: Date = Date()
    
    var codeReader: CodeReader! = AVCodeReader()
    
    var didFindCard: ((String) -> Void)?
    var didReadUnknownCode: ((String) -> Void)?
    
    override func viewDidLoad() {
        videoLayer = codeReader.videoPreview
        videoPreview.layer.addSublayer(videoLayer)
        videoPreview.layer.cornerRadius = 10.0
        videoPreview.layer.masksToBounds = true
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        videoLayer.frame = videoPreview.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        codeReader.startReading { [weak self] (code) in
            self?.fetchString(for: code)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        codeReader.stopReading()
    }
    
}

extension ViewController {
    
    func fetchString(for code: String) {
        if lastScannedLabel.text != code || lastScanTime.addingTimeInterval(3) < Date()  {
            lastScannedLabel.text = code
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            //Saving code in the database
            let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
            let newCode: ReadCode = ReadCode(context: appDelegate.persistentContainer.viewContext)
            newCode.code = code
            newCode.readingDate = NSDate()
            
            do {
                try appDelegate.persistentContainer.viewContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
                
            lastScanTime = Date()
        }
    }
    
}

