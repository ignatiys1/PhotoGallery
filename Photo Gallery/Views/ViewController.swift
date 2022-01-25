//
//  ViewController.swift
//  Photo Gallery
//
//  Created by Ignat Urbanovich on 24.01.22.
//

import UIKit
import SafariServices

class ViewController: UIViewController {

    var myScrollView = UIScrollView()
    
    var credits: [(String, Credit)] = []
    var images: Dictionary<String,UIImage> = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createScrollView()
        
        RequestManager.shared.loadCredits() { credits in
            self.credits  = credits.sorted {
                $0.value.user_name ?? "" < $1.value.user_name ?? ""
            }
            self.myScrollView.contentSize = CGSize(width: self.myScrollView.frame.width*CGFloat(self.credits.count), height: self.myScrollView.frame.height)
            DispatchQueue.global(qos: .userInteractive).async {
                var count = 0
                for (key, _) in self.credits {
                    DispatchQueue.main.async { [count] in
                        var labelFrame = CGRect()
                        labelFrame.origin.x = self.myScrollView.bounds.width * CGFloat(count)
                        labelFrame.origin.y = self.myScrollView.bounds.origin.y+self.myScrollView.bounds.size.height-100
                        labelFrame.size.width = self.myScrollView.bounds.size.width
                        labelFrame.size.height = 90
                        self.myScrollView.addSubview(UILabel(text: self.credits[count].1.user_name ?? "", frame: labelFrame))

                        var profileButtonFrame = CGRect()
                        profileButtonFrame.origin.x = self.myScrollView.bounds.width * CGFloat(count)
                        profileButtonFrame.origin.y = self.myScrollView.frame.origin.y
                        profileButtonFrame.size.width = 100
                        profileButtonFrame.size.height = 30
                        self.myScrollView.addSubview(UIButton(text: "Profile", action: #selector(self.goToProfile(sender:)), target: self, frame: profileButtonFrame, textAligment: .left))
                        
                        var profileImageFrame = CGRect()
                        profileImageFrame.origin.x = self.myScrollView.bounds.width * CGFloat(count+1)-100
                        profileImageFrame.origin.y = self.myScrollView.frame.origin.y
                        profileImageFrame.size.width = 100
                        profileImageFrame.size.height = 30
                        self.myScrollView.addSubview(UIButton(text: "Image", action: #selector(self.goToImage(sender:)), target: self, frame: profileImageFrame, textAligment: .right))
                    }
                    RequestManager.shared.getImage(named: key, number: count) { image, number, key in
                        DispatchQueue.main.async {
                            self.images[key] = image
                            
                            var thisImgFrame = self.myScrollView.bounds
                            thisImgFrame.origin.x = thisImgFrame.width * CGFloat(number)
                            thisImgFrame.origin.y += 100
                            thisImgFrame.size.height -= 200
                            self.myScrollView.addSubview(self.imageToView(image: image, frame: thisImgFrame))
                        }
                    }
                    count += 1
                }
            }
        }
        
        
        
        
        
    }
    

    
    fileprivate func createScrollView() {
        myScrollView = UIScrollView(frame: CGRect(x: 20, y: 50, width: self.view.bounds.width-40, height: self.view.bounds.height-50))
        myScrollView.delegate = self
        myScrollView.isPagingEnabled = true
        myScrollView.alpha = 1
        myScrollView.showsVerticalScrollIndicator = false
        myScrollView.bounces = false
        myScrollView.alwaysBounceHorizontal = true
        view.addSubview(myScrollView)
        
    }

    func imageToView(image: UIImage, frame: CGRect)->UIImageView {
        let imageView = UIImageView(frame: frame)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
    

}




//MARK: UIScrollViewDelegate
extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.myScrollView.alpha = 0.5
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.myScrollView.alpha = 1
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.myScrollView.alpha = 1
    }
    
}


//MARK: ACTIONS
extension ViewController {
    @objc func goToProfile(sender: UIButton) {
        let index = Int(round(sender.frame.origin.x/self.myScrollView.bounds.width))
        
        if index<self.credits.count {
            if let url = URL(string: self.credits[index].1.user_url ?? "") {
                let config = SFSafariViewController.Configuration()
                config.entersReaderIfAvailable = true
                
                let vc = SFSafariViewController(url: url, configuration: config)
                present(vc, animated: true)
            }
        }
    }
    
    @objc func goToImage(sender: UIButton) {
        let index = Int(round((sender.frame.origin.x+100)/self.myScrollView.bounds.width))-1
        
        if index<self.credits.count {
            if let url = URL(string: self.credits[index].1.photo_url ?? "") {
                let config = SFSafariViewController.Configuration()
                config.entersReaderIfAvailable = true
                
                let vc = SFSafariViewController(url: url, configuration: config)
                present(vc, animated: true)
            }
        }
    }
}
