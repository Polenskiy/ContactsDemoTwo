//
//  DetailViewController.swift
//  CardsRepeat
//
//  Created by Daniil Polenskii on 13.03.2024.
//

import UIKit

class EditViewController: UIViewController {
    
    private let textField: UITextField = {
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
        configureTextFieldFirst()
    }
    
    init(with contact: Contact) {
        super.init(nibName: nil, bundle: nil)
        
        textField.text = contact.title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) gas not been implemented")
    }
}

extension EditViewController {
    
    func configureTextFieldFirst() {
        view.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textField.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15)
        ])
    }
    
}
