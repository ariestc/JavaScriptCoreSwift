//
//  Movie.swift
//  JavaScriptCoreSwift
//
//  Created by wangliang on 2017/12/27.
//  Copyright © 2017年 wangliang. All rights reserved.
//

import UIKit
import JavaScriptCore

@objc protocol MovieJSExports: JSExport {
    
    var title: String { get set}
    var price: String {get set}
    var imageUrl: String {get set}
    
    static  func movieWith(title:String,price: String,imageUrl:String) -> Movie
}

class Movie: NSObject,MovieJSExports {
    
    dynamic var title: String
    dynamic var price: String
    dynamic var imageUrl: String
    
    init(title: String,price: String,imageUrl: String) {
        
        self.title=title
        self.price=price
        self.imageUrl=imageUrl
    }

    
    class func movieWith(title:String,price: String,imageUrl:String) -> Movie
    {
            return Movie(title: title, price: price, imageUrl: imageUrl)
    }
    
//    static let movieBuilder: @convention(block) ([[String: String]]) -> [Movie] = { object in
//
//        return object.map { dict in
//
//            guard let title = dict["title"],
//                  let price = dict["price"],
//                let imageUrl = dict["imageUrl"] else {
//
//                    print("unable to parse Movie Objects")
//                    fatalError()
//            }
//
//            return Movie(title: title, price: price, imageUrl: imageUrl)
//        }
//    }
}
