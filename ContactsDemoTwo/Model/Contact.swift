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
    
    private var storage = UserDefaults.standard
    
    private var keyForStorage: String = "contacts"
    
    private enum ContactKey: String {
        case title//0
        case phone//1
    }
    
    func load() -> [ContactProtocol] {
        var resultContact: [ContactProtocol] = []
        
        // [[+79109569265: Daniil], [+7435r843095r: Popov], [+7284334234: Rotew]]
        let contactFromStorage = storage.array(forKey: keyForStorage) as? [[String:String]] ?? []
        
        for contact in contactFromStorage {
            
            guard let title = contact[ContactKey.title.rawValue],
                  let phone = contact[ContactKey.phone.rawValue] else {
                continue
            }
            resultContact.append(Contact(title: title, number: phone))
        }
        return resultContact
    }
    
    func save(contacts: [ContactProtocol]) {
        var contactsForStorage: [[String:String]] = []
        
        contacts.forEach { contact in
            var newElementForStorage: Dictionary<String,String> = [:]
            
            newElementForStorage[ContactKey.title.rawValue] = contact.title
            newElementForStorage[ContactKey.phone.rawValue] = contact.number
            contactsForStorage.append(newElementForStorage)
        }
        storage.set(contactsForStorage, forKey: keyForStorage)
    }
}
