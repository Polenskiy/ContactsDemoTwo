//
//  CoreDataContact+CoreDataProperties.swift
//  ContactsDemoTwo
//
//  Created by Daniil Polenskii on 20.04.2024.
//
//

import Foundation
import CoreData


@objc(CoreDataContact)
public class CoreDataContact: NSManagedObject {

}

extension CoreDataContact {

    @NSManaged public var title: String?
    @NSManaged public var number: String?

}

extension CoreDataContact : Identifiable {

}
