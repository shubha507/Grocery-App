//
//  DataManager.swift
//  Grocery App
//
//  Created by Shubha Sachan on 03/05/21.
//

import UIKit


class DataManager {
    
    func getImageFrom(url: String?, imageView : UIImageView){
        guard let posterUrl = url else {return}
        guard let posterImageUrl = URL(string: posterUrl) else {return}
               imageView.image = nil

            URLSession.shared.dataTask(with: posterImageUrl) { (data, response, error) in
                if let error = error {
                    print("DataTask error: \(error.localizedDescription)")
                    return
                }
                guard let data = data else{
                    print("Empty data")
                    return
                }
                DispatchQueue.main.async {
                    if let image = UIImage(data : data){
                        imageView.image = image
                    }
    
                }
    
            }.resume()
        }
    
    
}


