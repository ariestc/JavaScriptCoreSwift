//
//  MovieCell.swift
//  JavaScriptCoreSwift
//
//  Created by wangliang on 2017/12/27.
//  Copyright © 2017年 wangliang. All rights reserved.
//

import UIKit

class MovieCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    //struct
    var movieCellData: MovieCellData? {
    
        didSet{
            
            guard let movieCellData = movieCellData else {
                return
            }

            
            nameLabel.text=movieCellData.name;
            priceLabel.text="$\(movieCellData.price)";
            
            let imageUrl = URL(string: movieCellData.imageUrl)
            
            downloadImageWithUrl(url: imageUrl)
        }
        
    }
    
    func downloadImageWithUrl(url: URL?) {
        
        guard let imageUrl = url else {
            
            print("\(String(describing: url))"+"url Invalid")
            
            return
        }
        
        URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in

            guard let image=UIImage(data: data!) else {
                return
            }

            OperationQueue.main.addOperation {

                self.imageView?.image=image
            }

        }.resume()
    }
}
