//
//  ViewController.swift
//  CardsRepeat
//
//  Created by Daniil Polenskii on 04.03.2024.
//

import UIKit

protocol EditContactDelegate: AnyObject {
    func didEditContact(_ contact: Contact, at indexPath: IndexPath)
}

class ContactsViewController: UIViewController {
    
    private var tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "ContactCell")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private lazy var addContactButon: UIButton = {
        let button = UIButton()
        button.setTitle("Add contact", for: .normal)
        button.backgroundColor = .systemOrange
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.systemGray, for: .highlighted)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(onAddNewContact), for: .touchUpInside)
        return button
    }()
    
    private var storage: ContactStorageProtocol = ContactStorage()
    
    private var coreData = StorageManager.shared
    
    private var contacts = [ContactProtocol]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Main")
        configureTableView()
        configureAddContactButton()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contacts = storage.load()
    }
    
    @objc private func onAddNewContact() {
        showNewContactAlert()
    }
    
    private func showNewContactAlert() {
        
        let alertController = UIAlertController(title: "Cоздайте новый контакт", message: "Введите имя и телефон", preferredStyle: .alert)
        
        alertController.addTextField {textField in
            textField.placeholder = "Имя"
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Номер телефона"
        }
        
        let createButton = UIAlertAction(title: "Create", style: .default) { _ in
            guard let contactName = alertController.textFields?[0].text,
                  let contactPhone = alertController.textFields?[1].text
            else {
                return
            }
            self.coreData.createContact(title: contactName, number: contactPhone)
            
            let contact = Contact(title: contactName, number: contactPhone)
            self.contacts.append(contact)
            self.tableView.reloadData()
        }
        let cancelButton = UIAlertAction(title: "Сancel", style: .cancel)
        
        alertController.addAction(createButton)
        alertController.addAction(cancelButton)
        
        present(alertController, animated: true, completion: nil)
    }
}

extension ContactsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
      
        var configuration = cell.defaultContentConfiguration()
        var backgroundConfiguration = cell.defaultBackgroundConfiguration()
        backgroundConfiguration.backgroundColor = .white
        backgroundConfiguration.cornerRadius = 10
        backgroundConfiguration.backgroundInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        configuration.text = contacts[indexPath.row].title
        configuration.secondaryText = contacts[indexPath.row].number
        cell.contentConfiguration = configuration
        cell.backgroundConfiguration = backgroundConfiguration
        
        return cell
    }
    
    //Этот метод предназначен для обработки перемещения строк в таблице
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let contact = contacts[sourceIndexPath.row]
        contacts.remove(at: sourceIndexPath.row)
        contacts.insert(contact, at: destinationIndexPath.row)
//        tableView.reloadRows(at: [destinationIndexPath, sourceIndexPath], with: .automatic)
    }
}

//т.к класс ViewController является делегатом для
//табличного представления, то его необходимо подписать на
//cпециальный протокол
extension ContactsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionDelegate = UIContextualAction(style: .destructive, title: "Удалить") {_,_,_ in
            let deleteContact = self.contacts.remove(at: indexPath.row)
            self.coreData.deleteOneContact(with: deleteContact.title)
            tableView.reloadData()
        }
        let actions = UISwipeActionsConfiguration(actions: [actionDelegate])
        return actions
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let contact = contacts[indexPath.row] as? Contact {
            
            let editVC = EditViewController(with: contact)
            editVC.delegate = self
            editVC.indexPath = indexPath
            navigationController?.pushViewController(editVC, animated: true)
        }
    }
    
}

private extension ContactsViewController {
    
    func setupNavigationBar() {
        
        let editAction = UIAction { _ in
            self.tableView.isEditing.toggle()
            if !self.tableView.isEditing {
                self.tableView.reloadData()
            }
        }
        navigationItem.title = "Сontacts"
        navigationController?.navigationBar.barTintColor = UIColor(named: "Main")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .edit, primaryAction: editAction, menu: nil)
        navigationItem.rightBarButtonItem?.tintColor = .black
        
        let backButton = UIBarButtonItem(title: "Сancel", style: .plain, target: nil, action: nil)
        backButton.tintColor = .black
        navigationItem.backBarButtonItem = backButton
    }
    
    func configureTableView() {
        tableView.backgroundColor = UIColor(named: "Table")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    func configureAddContactButton() {
        view.addSubview(addContactButon)
        NSLayoutConstraint.activate([
            addContactButon.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 250),
            addContactButon.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addContactButon.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            addContactButon.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}

extension ContactsViewController: EditContactDelegate {
    func didEditContact(_ contact: Contact, at indexPath: IndexPath) {
        contacts[indexPath.row] = contact
        coreData.updateContact(with: contact.title, number: contact.number)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

