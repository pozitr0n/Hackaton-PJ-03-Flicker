//
//  ImageTableViewCell.swift
//  Hackaton-PJ-03-Flicker
//
//  Created by Raman Kozar on 23/04/2023.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    static let identifier = "ImageCellID"

    let flickerImageFirst: UIImageView = {
        
        let flickerImageFirst = UIImageView()
        flickerImageFirst.translatesAutoresizingMaskIntoConstraints = false
        
        return flickerImageFirst
        
    }()
    
    let flickerImageSecond: UIImageView = {
        
        let flickerImageSecond = UIImageView()
        flickerImageSecond.translatesAutoresizingMaskIntoConstraints = false
        
        return flickerImageSecond
        
    }()
    
    let flickerImageThird: UIImageView = {
       
        let flickerImageThird = UIImageView()
        flickerImageThird.translatesAutoresizingMaskIntoConstraints = false
        
        return flickerImageThird
        
    }()
    
    let stackViewMain: UIStackView = {
       
        let stackViewMain = UIStackView()
        stackViewMain.axis = .horizontal
        stackViewMain.alignment = .fill
        stackViewMain.distribution = .fillEqually
        stackViewMain.spacing = 40
        stackViewMain.translatesAutoresizingMaskIntoConstraints = false
        
        return stackViewMain
        
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        
        contentView.backgroundColor = .lightGray
        
        stackViewMain.addArrangedSubview(flickerImageFirst)
        stackViewMain.addArrangedSubview(flickerImageSecond)
        stackViewMain.addArrangedSubview(flickerImageThird)
        
        contentView.addSubview(stackViewMain)
        
    }
    
    func configureUI() {
        
        NSLayoutConstraint.activate(
            [stackViewMain.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 0),
             stackViewMain.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 0),
             stackViewMain.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: 0),
             stackViewMain.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        ])
        
    }
    
    func setFirstImage(image: UIImage) {
        setTheImage(type: "first", imageData: image)
    }
    
    func setSecondImage(image: UIImage) {
        setTheImage(type: "second", imageData: image)
    }
    
    func setThirdImage(image: UIImage) {
        setTheImage(type: "third", imageData: image)
    }
    
    func setTheImage(type: String, imageData: UIImage) {
     
        if type == "first" {
            flickerImageFirst.image = imageData
        }
        
        if type == "second" {
            flickerImageSecond.image = imageData
        }
        
        if type == "third" {
            flickerImageThird.image = imageData
        }
        
    }

}
