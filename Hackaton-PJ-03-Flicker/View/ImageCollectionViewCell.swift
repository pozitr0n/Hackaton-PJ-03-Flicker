//
//  ImageCollectionViewCell.swift
//  Hackaton-PJ-03-Flicker
//
//  Created by Raman Kozar on 23/04/2023.
//

import UIKit
import SDWebImage

// Main class for collection view cell
//
class ImageCollectionViewCell: UICollectionViewCell {

    static let identifier = "ImageCollectionViewCellID"

    let flickerImage: UIImageView = {

        let flickerImage = UIImageView()
        flickerImage.translatesAutoresizingMaskIntoConstraints = false
        flickerImage.contentMode = .scaleAspectFit
        flickerImage.clipsToBounds = true
        return flickerImage

    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        flickerImage.image = nil
        
    }

    func setupLayout() {

        contentView.backgroundColor = .lightGray
        contentView.clipsToBounds = true
        contentView.addSubview(flickerImage)

    }

    func configureUI() {

        NSLayoutConstraint.activate([
            flickerImage.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 0),
            flickerImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 0),
            flickerImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: 0),
            flickerImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        ])

    }

    public func setTheImage(urlToImage: URL) {
        
        if let cachedImage = imageCache.object(forKey: urlToImage as AnyObject) as? UIImage {
            flickerImage.image = cachedImage
        } else {
            
            FlickerAPI().getImageByURL(from: urlToImage) { data, response, error in
                
                guard let data = data , error == nil else {
                    
                    print("failed downloading image by URK: \(urlToImage)")
                    return
                    
                }
                
                DispatchQueue.main.async {
                    
                    let downloadedImage = UIImage(data: data)
                    
                    self.flickerImage.sd_setImage(with: urlToImage,
                                             placeholderImage: UIImage(named: "logo_error"),
                                             options: [.continueInBackground, .progressiveLoad],
                                             completed: nil)
                    
                    imageCache.setObject(downloadedImage!, forKey: urlToImage as AnyObject)
                    
                }
            
            }
            
        }
    
    }

}
