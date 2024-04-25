//
//  CoreDataManager.swift
//  ContactsDemoTwo
//
//  Created by Daniil Polenskii on 20.04.2024.
//

import UIKit
import CoreData

public final class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
    
    public func createContact(title: String, number: String) {
        guard let contactEntityDescription = NSEntityDescription.entity(forEntityName: "CoreDataContact", in: context) else  {
            return
        }
        let coreDataContact = CoreDataContact(entity: contactEntityDescription, insertInto: context)
        coreDataContact.number = number
        coreDataContact.title = title
        
        appDelegate.saveContext()
    }
    
    public func fetchContacts() -> [CoreDataContact] {
        
        //запрос к базе данных
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataContact")
        do {
            return (try? context.fetch(fetchRequest) as? [CoreDataContact]) ?? []
        }
    }
    
    public func updateContact(with title: String, number: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataContact")
        do {
            guard let coreDataContacts = try? context.fetch(fetchRequest) as? [CoreDataContact],
                  let coreDataContact = coreDataContacts.first(where: {$0.number == number}) else {
                return
            }
            coreDataContact.title = title
            coreDataContact.number = number
        }
        appDelegate.saveContext()
    }
    
    public func deleteAllContacts() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataContact")
        do {
            let contacts = try? context.fetch(fetchRequest) as? [CoreDataContact]
            contacts?.forEach { context.delete($0) }
        }
        appDelegate.saveContext()
    }
    
    public func deleteOneContact(with title: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataContact")
        do {
            let contacts = try? context.fetch(fetchRequest) as? [CoreDataContact]
            
            guard let contacts = try? context.fetch(fetchRequest) as? [CoreDataContact],
                  let contact = contacts.first(where: {$0.title == title}) else { return }
            context.delete(contact)
        }
        appDelegate.saveContext()
    }
    
}
