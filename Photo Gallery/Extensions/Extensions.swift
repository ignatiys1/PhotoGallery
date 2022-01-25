//
//  Extensions.swift
//  Photo Gallery
//
//  Created by Ignat Urbanovich on 25.01.22.
//

import Foundation
import UIKit

//MARK: Array extension
extension Array where Element == (key: String, value: Credit) {
    
    func getDictionary() -> Dictionary<String, Credit> {
        var dict: Dictionary<String, Credit> = [:]
        self.forEach() {
            dict[$0.0] = $0.1
        }
        return dict
    }
    
}

//MARK: UILabel extension
extension UILabel {
    
    convenience init(text: String, frame: CGRect) {
        self.init(frame: frame)
        
        self.text = text
        self.textColor = .black
        self.font = UIFont.init(name: "Avenir Next Demi Bold", size: 20)!
        self.textAlignment = .center
        self.adjustsFontSizeToFitWidth = true
        self.translatesAutoresizingMaskIntoConstraints = false
        //self.backgroundColor = .red
    }
}

//MARK: UIButton extension
extension UIButton {
    
    convenience init(text: String, action: Selector, target: ViewController, frame: CGRect, textAligment: ContentHorizontalAlignment) {
        self.init(frame: frame)
        
        self.setTitle(text, for: .normal)
        self.setTitleColor(.blue, for: .normal)
        self.titleLabel?.font = UIFont.init(name: "Avenir Next Demi Bold", size: 20)!
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.contentHorizontalAlignment = textAligment
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .none
    
        self.addTarget(target, action: action, for: .touchUpInside)
    }
}
