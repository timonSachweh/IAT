//
//  ReadCode+CoreDataProperties.swift
//  IAT-QRReader
//
//  Created by Timon Sachweh on 11.12.17.
//  Copyright © 2017 Timon Sachweh. All rights reserved.
//
//

import Foundation
import CoreData


extension ReadCode {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ReadCode> {
        return NSFetchRequest<ReadCode>(entityName: "ReadCode")
    }

    @NSManaged public var code: String?
    @NSManaged public var readingDate: NSDate?

}
