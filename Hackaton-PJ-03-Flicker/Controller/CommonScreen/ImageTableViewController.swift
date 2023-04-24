//
//  ImageTableViewController.swift
//  Hackaton-PJ-03-Flicker
//
//  Created by Raman Kozar on 23/04/2023.
//

import UIKit

class ImageTableViewController: UIViewController {

    let searchField: UITextField = {
        
        let searchField = UITextField()
        
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.font = UIFont.systemFont(ofSize: 20)
        searchField.backgroundColor = .gray
        searchField.textColor = .white
        searchField.borderStyle = UITextField.BorderStyle.roundedRect
        searchField.autocorrectionType = UITextAutocorrectionType.no
        searchField.keyboardType = UIKeyboardType.default
        searchField.returnKeyType = UIReturnKeyType.done
        searchField.clearButtonMode = UITextField.ViewMode.whileEditing
        searchField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        searchField.placeholder = "What are you looking for?"
        
        return searchField
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(ImageDetailsViewController(), animated: true)
        }
        
    }
    
    func setupLayout() {
        
        view.backgroundColor = .lightGray
        title = "All Flickers"
        
        let barHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        let tableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
       
        tableView.backgroundColor = .lightGray
        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableView.register(ImageTableViewCell.self, forCellReuseIdentifier: ImageTableViewCell.identifier)

        tableView.dataSource = self
        tableView.delegate = self
        searchField.delegate = self
        
        view.addSubview(searchField)
        view.addSubview(tableView)
        
        configureUI(tableView)
        
    }
    
    func configureUI(_ tableView: UITableView) {
        
        let margins = view.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
         
            searchField.topAnchor.constraint(equalTo: margins.topAnchor, constant: 10.0),
            searchField.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            searchField.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 20.0),
            tableView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
            
        ])
        
    }
    
}

extension ImageTableViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        searchField.resignFirstResponder()
        return true
        
    }

}

extension ImageTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ImageTableViewCell.identifier, for: indexPath) as? ImageTableViewCell
        else {
            return UITableViewCell()
        }
        
        return cell
    }
    
}


