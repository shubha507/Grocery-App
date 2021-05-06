//
//  DataManager.swift
//  Grocery App
//
//  Created by Shubha Sachan on 03/05/21.
//

import UIKit

let imageCache = NSCache<AnyObject,AnyObject>()

class DataManager {
    
    let activityIndicator = UIActivityIndicatorView()
    
    func getImageFrom(url: String?, imageView : UIImageView){
        
        activityIndicator.color = .blue
        imageView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerX(inView: imageView)
        activityIndicator.centerY(inView: imageView)
        
        
        guard let posterUrl = url else {return}
        guard let posterImageUrl = URL(string: posterUrl) else {return}
        
            imageView.image = nil
        
        if let imageSavedCache = imageCache.object(forKey: posterImageUrl as AnyObject) as? UIImage {
            imageView.image = imageSavedCache
            activityIndicator.stopAnimating()
            return
        }
        
            URLSession.shared.dataTask(with: posterImageUrl) { (data, response, error) in
                if let error = error {
                    print("DataTask error: \(error.localizedDescription)")
                    DispatchQueue.main.async(execute: {
                                       self.activityIndicator.stopAnimating()
                                   })
                    return
                }
                guard let data = data else{
                    print("Empty data")
                    return
                }
                DispatchQueue.main.async {
                    if let image = UIImage(data : data){
                        imageCache.setObject(image, forKey: posterImageUrl as AnyObject )
                        imageView.image = image
                       // print(imageCache.description)
                        
                    }
                    self.activityIndicator.stopAnimating()
                }
    
            }.resume()
        }
    
    
}


