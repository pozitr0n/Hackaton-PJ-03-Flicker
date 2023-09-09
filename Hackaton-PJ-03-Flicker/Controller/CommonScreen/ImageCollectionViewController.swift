//
//  ImageCollectionViewController.swift
//  Hackaton-PJ-03-Flicker
//
//  Created by Raman Kozar on 23/04/2023.
//

import UIKit
import SwiftyJSON

// Main view controller
//
class ImageCollectionViewController: UIViewController {
    
    private var collectionView: UICollectionView?
    
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

    func setupLayout() {
        
        view.backgroundColor = .lightGray
        title = "All Flickers"
        
        let barHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight), collectionViewLayout: getFlowLayout(displayWidth))
        
        guard let collectionView = collectionView else {
            return
        }
        
        setAllThePropertiesForCollectionView(collectionView)
        searchField.delegate = self
        
        configureUI(collectionView)
        
    }
    
    func setAllThePropertiesForCollectionView(_ collectionView: UICollectionView) {
        
        collectionView.backgroundColor = .lightGray
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)

        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    func getFlowLayout(_ displayWidth: CGFloat) -> UICollectionViewFlowLayout {
    
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 3.3
        layout.minimumInteritemSpacing = 3.3
        layout.itemSize = CGSize(width: (displayWidth / 3.3) - 4, height: (displayWidth / 3.3) - 4)
        
        return layout
        
    }
    
    func configureUI(_ collectionView: UICollectionView) {
        
        view.addSubview(searchField)
        view.addSubview(collectionView)
        
        let margins = view.layoutMarginsGuide

        NSLayoutConstraint.activate([

            searchField.topAnchor.constraint(equalTo: margins.topAnchor, constant: 10.0),
            searchField.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            searchField.trailingAnchor.constraint(equalTo: margins.trailingAnchor),

            collectionView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 20.0),
            collectionView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: margins.bottomAnchor)

        ])
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        DispatchQueue.main.async {

            collectionView.deselectItem(at: indexPath, animated: true)
            
            let currentURL = imageURLs[indexPath.row]
            
            guard let cachedImage = imageCache.object(forKey: currentURL as AnyObject) as? UIImage else {
                return
            }

            let imageDetailsViewController = ImageDetailsViewController(currentImage: cachedImage)
            self.navigationController?.pushViewController(imageDetailsViewController, animated: true)

        }
        
    }
   
}

extension ImageCollectionViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == searchField && !textField.text!.isEmpty {
            
            let searchText = textField.text!
            
            let requestURL = FlickerAPI().createRequestURL(text: searchText)
            
            FlickerAPI().downloadDataUsingAPI(requestURL) { json, error in
                
                guard let json = json else {
                    print("failed to download data from Flickr, error: \(String(describing: error?.localizedDescription))")
                    return
                }
                
                let allTheURLs = FlickerAPI().parsingJSON_DuringSearch(searchText, json)
                imageURLs = allTheURLs
                
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
                
            }
            
            DispatchQueue.main.async {
                self.searchField.resignFirstResponder()
            }
            
            return true
            
        }
        
        DispatchQueue.main.async {
            self.searchField.resignFirstResponder()
        }
        
        return false
        
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        imageURLs.removeAll()
        
        DispatchQueue.main.async {
            self.searchField.resignFirstResponder()
            self.collectionView?.reloadData()
        }
        
        return true
        
    }

}

extension ImageCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.setTheImage(urlToImage: imageURLs[indexPath.row])
        
        return cell
        
    }
    
}
