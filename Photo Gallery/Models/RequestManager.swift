//
//  RequestManager.swift
//  Photo Gallery
//
//  Created by Ignat Urbanovich on 19.12.21.
//

import Foundation
import UIKit

class RequestManager {
    
    let base = "http://dev.bgsoft.biz/task"
    
    let credits = "/credits.json"
    
    let decoder = JSONDecoder()
    
    static var shared: RequestManager = {
        let instance = RequestManager()
        
        return instance
    }()
    
    private init() {
        
    }
    
    func loadCredits(completion: @escaping (_ credits: Dictionary<String, Credit>)->Void) {
        let url = URL(string: base+credits)
//        let session = URLSession(configuration: .default)
        
//        let downTask = session.downloadTask(with: url!) {(urlFile,response,error) in
//            guard let urlFile = urlFile else {
//                return
//            }
            let path = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]+"/credits.json"

            let urlPath = URL(fileURLWithPath: path)

            try? FileManager.default.copyItem(at: url!, to: urlPath)

            let data = try? Data(contentsOf: url!)
            
            if data == nil {
                return
            }
            do {
                var creditsArray: Dictionary<String, Credit> = [:]
                creditsArray = try self.decoder.decode(Dictionary<String, Credit>.self, from: data!)
                completion(creditsArray)
            } catch {
                print(error)
            }
            
            
//        }
//        downTask.resume()
    }
    
    func getImage(named name: String, number: Int, completion: @escaping (UIImage, Int, String) -> ()) {
        let imageURL = URL(string: "\(base)/\(name).jpg")
        if let imageURL = imageURL {
            URLSession.shared.dataTask(with: imageURL, completionHandler: { data, error, response in
                if let data = data {
                    let image = UIImage(data: data)
                    if let image = image {
                        completion(image, number, name)
                    }
                }
            }).resume()
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
