//
//  ViewController.swift
//  JavaScriptCoreSwift
//
//  Created by wangliang on 2017/12/27.
//  Copyright © 2017年 wangliang. All rights reserved.
//

import UIKit

let ReuseID = "MovieCellID"

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var inputPrice: UITextField!
    
    let movieService = MovieService();
    
    var movies: [Movie]? {
        
        didSet{
            
            OperationQueue.main.addOperation {
                
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource=self
        
        collectionView.register(UINib(nibName: "MovieCell", bundle:nil), forCellWithReuseIdentifier: ReuseID)
 
        movieService.loadMoviesWith(limit: 80) { [weak self] movies in
        
            self?.movies=movies
        }
    }
}

extension ViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return movies?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let movie=movies![indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  ReuseID, for: indexPath) as! MovieCell
        
      
        cell.movieCellData=MovieCellData(name: movie.title, price: movie.price, imageUrl: movie.imageUrl)
       
        return cell
    }
    
}

//extension ViewController: UITextFieldDelegate
//{
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField)
//    {
//        guard let priceText = textField.text, let price = Double(priceText) else {
//            return
//        }
//
//        movieService.loadMoviesWith(limit: price)
//        { [weak self] movies in
//
//            self?.movies = movies
//        }
//    }
//}

