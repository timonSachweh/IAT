//
//  ReadCode+CoreDataClass.swift
//  IAT-QRReader
//
//  Created by Timon Sachweh on 11.12.17.
//  Copyright © 2017 Timon Sachweh. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ReadCode)
public class ReadCode: NSManagedObject {
    
    convenience init(currentDate: Date, codeToPersist: String) {
        self.init()
        
        self.readingDate = currentDate as NSDate
        self.code = codeToPersist
    }

}
