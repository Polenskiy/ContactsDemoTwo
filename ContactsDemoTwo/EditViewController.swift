//
//  DetailViewController.swift
//  CardsRepeat
//
//  Created by Daniil Polenskii on 13.03.2024.
//

import UIKit

class EditViewController: UIViewController {
    
    weak var delegate: EditContactDelegate?
    var indexPath: IndexPath?
    
    private let firstTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите текст"
        textField.backgroundColor = .white
        textField.font = UIFont.systemFont(ofSize: 28)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let secondTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите текст"
        textField.backgroundColor = .white
        textField.font = UIFont.systemFont(ofSize: 28)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Main")
        configureTextField()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        
        let backButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(goBack))
        backButton.tintColor = UIColor.black
        navigationItem.rightBarButtonItem = backButton
    }
    
    @objc func goBack() {
        guard let newTitle = firstTextField.text,
              let newNumber = secondTextField.text else { return }
        guard let indexPath = indexPath else { return }
        let editedContact = Contact(title: newTitle, number: newNumber)
        delegate?.didEditContact(editedContact, at: indexPath)
        navigationController?.popViewController(animated: true)
     }
    
    init(with contact: Contact) {
        super.init(nibName: nil, bundle: nil)
        
        firstTextField.text = contact.title
        secondTextField.text = contact.number
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) gas not been implemented")
    }
}

extension EditViewController {
    
    func configureTextField() {
            view.addSubview(firstTextField)
            view.addSubview(secondTextField)
            NSLayoutConstraint.activate([
                firstTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                firstTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                firstTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                firstTextField.heightAnchor.constraint(equalToConstant: 40),
                
                secondTextField.topAnchor.constraint(equalTo: firstTextField.bottomAnchor, constant: 20),
                secondTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                secondTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                secondTextField.heightAnchor.constraint(equalToConstant: 40)
            ])
        }
    
}
