//
//  ImageCell.swift
//  Photo Gallery
//
//  Created by Ignat Urbanovich on 26.01.22.
//

import UIKit

class ImageCell: UICollectionViewCell {

    var image: UIImage? {
        get {return imageView?.image ?? nil}
        set {
            if let newValue = newValue {
                createImageView(image: newValue)
            }
        }
    }
    @IBOutlet private weak var shadowView: UIImageView!
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    var label: UILabel?
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicator.startAnimating()
        
        self.clipsToBounds = false
        
        label = UILabel(text: "", frame: self.frame)
        if let label = label {
        self.addSubview(label)
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            label.heightAnchor.constraint(equalToConstant: 100)
        ])
        }
    }

    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = nil
        shadowView.isHidden = true
        activityIndicator.startAnimating()
        label?.textColor = .black
    }
    
    func createImageView(image: UIImage) {
        label?.textColor = .white
        activityIndicator.stopAnimating()
        
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        
        
        shadowView.isHidden = false
        shadowView.clipsToBounds = false
        shadowView.layer.shadowColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        shadowView.layer.shadowRadius = 7
        shadowView.layer.shadowOpacity = 0.8
        shadowView.layer.shadowOffset = CGSize(width: 3, height: 3)

        let cgPath = UIBezierPath(roundedRect: imageView.frame, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: 10, height: 10)).cgPath
        shadowView.layer.shadowPath = cgPath
        
    
        
    }
    
    
    func resizeImage(image: UIImage, to frame: CGRect) -> UIImage? {
        var coef = CGFloat(1)
        if image.size.width/frame.width >= image.size.height/frame.height {
            coef = (image.size.width/frame.width)
        } else {
            coef = (image.size.height/frame.height)
        }
        let imageSize = CGSize(width: image.size.width/coef, height: image.size.height/coef)
        
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 1.0)
        image.draw(in: CGRect(origin: .zero, size: imageSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
