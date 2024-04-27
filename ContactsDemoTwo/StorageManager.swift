//
//  CoreDataManager.swift
//  ContactsDemoTwo
//
//  Created by Daniil Polenskii on 20.04.2024.
//

import UIKit
import CoreData


///Этот менеджер лучше сделать абстрактным и назвать его StorageManager
final class StorageManager {
    
    static let shared = StorageManager()
    
    private var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    //глобальная память
    private lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "CoreData")
        
        container.loadPersistentStores { description, error in
            if let error {
                print(error.localizedDescription)
            }
        }
        return container
    }()
    
    private init() {}

    //слепок с этой базы данных, с которыми мы можем быстро взаимодействать
    private func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func createContact(title: String, number: String) {
        guard let contactEntityDescription = NSEntityDescription.entity(forEntityName: "CoreDataContact", in: context) else  {
            return
        }
        let coreDataContact = CoreDataContact(entity: contactEntityDescription, insertInto: context)
        coreDataContact.number = number
        coreDataContact.title = title
        
        saveContext()
    }
    
    func fetchContacts() -> [CoreDataContact] {
        
        //запрос к базе данных
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataContact")
        do {
            return (try? context.fetch(fetchRequest) as? [CoreDataContact]) ?? []
        }
    }
    
    func updateContact(with title: String, number: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataContact")
        do {
            guard let coreDataContacts = try? context.fetch(fetchRequest) as? [CoreDataContact],
                  let coreDataContact = coreDataContacts.first(where: {$0.number == number}) else {
                return
            }
            coreDataContact.title = title
            coreDataContact.number = number
        }
        saveContext()
    }
    
    func deleteOneContact(with title: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataContact")
        do {
            let contacts = try? context.fetch(fetchRequest) as? [CoreDataContact]
            
            guard let contacts = try? context.fetch(fetchRequest) as? [CoreDataContact],
                  let contact = contacts.first(where: {$0.title == title}) else { return }
            context.delete(contact)
        }
        saveContext()
    }
    
}
