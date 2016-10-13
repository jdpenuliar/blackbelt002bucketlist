//
//  Notes+CoreDataProperties.swift
//  blackbelt002
//
//  Created by JD Penuliar on 8/2/16.
//  Copyright © 2016 JD Penuliar. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Notes {

    @NSManaged var notes: String?
    @NSManaged var date: Date?

}
