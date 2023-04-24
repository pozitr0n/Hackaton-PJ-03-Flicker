//
//  ImageDetailsViewController.swift
//  Hackaton-PJ-03-Flicker
//
//  Created by Raman Kozar on 23/04/2023.
//

import UIKit

class ImageDetailsViewController: UIViewController {

    var currentImage: UIImage
    
    let flickerImage: UIImageView = {
        
        let flickerImage = UIImageView()
        flickerImage.frame = CGRect(x: 0, y: 0, width: 300.0, height: 300.0)
        flickerImage.translatesAutoresizingMaskIntoConstraints = false
        
        return flickerImage
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupLayout()
        configureUI()
        setImage()
        
    }
    
    init(currentImage: UIImage) {
        self.currentImage = currentImage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
     
        view.backgroundColor = .lightGray
        view.addSubview(flickerImage)
        
    }
    
    func configureUI() {
        
        NSLayoutConstraint.activate(
            [flickerImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
             flickerImage.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
    }
    
    func setImage() {
        flickerImage.image = currentImage
    }

}
