//
//  ViewController.swift
//  CardsRepeat
//
//  Created by Daniil Polenskii on 05.03.2024.
//

import UIKit

protocol ContactProtocol {
    var title: String { get set }
    var number: String { get set }
}

protocol ContactStorageProtocol {
    func save(contacts: [ContactProtocol])
    func load() -> [ContactProtocol]
}

struct Contact: ContactProtocol {
    var title: String
    var number: String
    
}

class ContactStorage: ContactStorageProtocol {
    
    private var storage = StorageManager.shared
    
    private enum ContactKey: String {
        case title//0
        case phone//1
    }
    
    func load() -> [ContactProtocol] {
        var resultContact: [ContactProtocol] = []
        
        let contacts = storage.fetchContacts()
        for contact in contacts {
                let title = contact.title ?? ""
                let number = contact.number ?? ""
                resultContact.append(Contact(title: title, number: number))
            }
        return resultContact
    }
    
    func createC(title: String, number: String ) {
        storage.createContact(title: title, number: number)
    }
    
    func save(contacts: [ContactProtocol]) {
        var contactsForStorage: [[String:String]] = []
        
        contacts.forEach { contact in
            var newElementForStorage: Dictionary<String,String> = [:]
            
            newElementForStorage[ContactKey.title.rawValue] = contact.title
            newElementForStorage[ContactKey.phone.rawValue] = contact.number
            contactsForStorage.append(newElementForStorage)
        }
        
        contactsForStorage.forEach { contact in
            let title = contact[ContactKey.title.rawValue] ?? ""
            let number = contact[ContactKey.phone.rawValue] ?? ""
            storage.createContact(title: title, number: number)
        }
    }
}
