//
//  ViewController.swift
//  Photo Gallery
//
//  Created by Ignat Urbanovich on 24.01.22.
//

import UIKit
import SafariServices

class ViewController: UIViewController {

    
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    let reuseIdentifier = "ImageCell"
    var credits: [(String, Credit)] = []
    var images: Dictionary<String,UIImage> = [:]
    
    lazy var lastPosition: CGFloat = {
        myCollectionView.contentOffset.x
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.isUserInteractionEnabled = true
        createCollectionView()
        createButtons()
        RequestManager.shared.loadCredits() { credits in
            self.credits = credits.sorted {
                $0.value.user_name ?? "" < $1.value.user_name ?? ""
            }
            self.myCollectionView.reloadData()
            DispatchQueue.global(qos: .userInteractive).async {
                var count = 0
                for (key, _) in self.credits {
                    RequestManager.shared.getImage(named: key) {[count, key] image  in
                        DispatchQueue.main.async {
                            self.images[key] = image
                            print(self.images.count)
                            let cell = self.myCollectionView!.cellForItem(at: IndexPath(item: count, section: 0))

                            if let cell = cell {
                                (cell as! ImageCell).image = image
                            }
                        }
                    }
                    count += 1
                }
            }
        }
    }
    
    func createButtons() {
        var buttonFrame = CGRect()
        buttonFrame.origin.x = 0
        buttonFrame.origin.y = 0
        buttonFrame.size.width = 100
        buttonFrame.size.height = 30
        let profileButton = UIButton(text: "Profile", action: #selector(self.goToProfile(sender:)), target: self, frame: buttonFrame, textAligment: .left)
        self.view.addSubview(profileButton)
        NSLayoutConstraint.activate([
            profileButton.topAnchor.constraint(equalTo: myCollectionView.bottomAnchor, constant: 20),
            profileButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            profileButton.widthAnchor.constraint(equalToConstant: 100),
            profileButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        let imageButton = UIButton(text: "Image", action: #selector(self.goToImage(sender:)), target: self, frame: buttonFrame, textAligment: .right)
        self.view.addSubview(imageButton)
        NSLayoutConstraint.activate([
            imageButton.topAnchor.constraint(equalTo: myCollectionView.bottomAnchor, constant: 20),
            imageButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageButton.widthAnchor.constraint(equalToConstant: 100),
            imageButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    func createCollectionView() {
        myCollectionView.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        myCollectionView.isPagingEnabled = true
        myCollectionView.contentMode = .scaleToFill
        
        NSLayoutConstraint.activate([
            myCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            myCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            myCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            myCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 75)
        ])
    }

}




//MARK: UICollectionView: Delegate, DataSource and DelegateFlowLayout
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.credits.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImageCell
        cell.label?.text = credits[indexPath.item].1.user_name
        cell.image = images[credits[indexPath.item].0]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width*0.9, height: collectionView.bounds.height*0.8)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView.frame.width*0.1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: collectionView.frame.height*0.1, left: collectionView.frame.width*0.05, bottom: collectionView.frame.height*0.1, right: collectionView.frame.width*0.05)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var count  = 1
        for cell in myCollectionView.visibleCells {
            
            let cellX = cell.frame.origin.x
            let COX = myCollectionView.contentOffset.x
            let width = cell.frame.width
            
            
            
            print("cellX(\(count))=\(cellX)")
            print("COX(\(count))=\(COX)")
            print("width(\(count))=\(width)")
           // print("currentScale(\(count))=\(currentScale)")
            print("")
            
            
            //print("cellX-COX(\(count))=\(cellX-COX)")
            //print("COX%width(\(count))=\(COX.truncatingRemainder(dividingBy: width))")
            //print("cellX%width(\(count))=\(cellX.truncatingRemainder(dividingBy: width))")
            print("")
            //print("huita(\(count))=\((COX.truncatingRemainder(dividingBy: width) / width))")
            count+=1
            
            let scaleDif = 0.1 * (COX.truncatingRemainder(dividingBy: width) / width)
            print("scaleDif(\(count))=\(scaleDif)")
            var newScale = CGFloat(1)
            switch true {
//            case COX<(cellX+myCollectionView.frame.origin.x):
//                newScale = newScale - 0.1 + scaleDif
            case COX>(cellX+myCollectionView.frame.origin.x-COX.truncatingRemainder(dividingBy: width) ):
                newScale = newScale - scaleDif
            default: break
            }
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransform(scaleX: newScale, y: newScale)
            })
            print("----------------------------------------------------------------------------------------")
            
        }
        
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollView.backgroundColor = .none
        }
        
        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            scrollView.backgroundColor = .none
        }
}


//MARK: ACTIONS
extension ViewController {
    @objc func goToProfile(sender: UIButton) {
        let index = myCollectionView.indexPath(for: myCollectionView.visibleCells[0])?.item
        if let index = index {
            if index<self.credits.count {
                if let url = URL(string: self.credits[index].1.user_url ?? "") {
                    let config = SFSafariViewController.Configuration()
                    config.entersReaderIfAvailable = true
                    
                    let vc = SFSafariViewController(url: url, configuration: config)
                    present(vc, animated: true)
                }
            }
        }
    }
    
    @objc func goToImage(sender: UIButton) {
        let index = myCollectionView.indexPath(for: myCollectionView.visibleCells[0])?.item
        if let index = index {
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
    
}
