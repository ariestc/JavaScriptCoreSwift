//
//  MovieService.swift
//  JavaScriptCoreSwift
//
//  Created by wangliang on 2017/12/27.
//  Copyright © 2017年 wangliang. All rights reserved.
//

import UIKit
import JavaScriptCore

let movieUrl = "https://itunes.apple.com/us/rss/topmovies/limit=50/json"

class MovieService{
    
    //懒加载context
    lazy var context: JSContext? = {
        
        let context=JSContext()
       
        guard let commonJSPath=Bundle.main.path(forResource: "common", ofType: "js") , let addtionsJSPath=Bundle.main.path(forResource: "additions", ofType: "js") else {


            print("Unable to load Resources file")
            return nil;
        }
        
        do{
          let common=try String(contentsOfFile: commonJSPath, encoding: String.Encoding.utf8)
            
          let addtions=try String(contentsOfFile: addtionsJSPath, encoding: String.Encoding.utf8)
            
            context?.setObject(Movie.self, forKeyedSubscript: "Movie" as (NSCopying & NSObjectProtocol)!)

            _=context?.evaluateScript(common)
            _=context?.evaluateScript(addtions)

        }catch(let error){

            print("Error while processing script file: \(error)")
        }
       
        return context
    }()

    //请求网络数据
    func loadMoviesWith(limit:Double,onComplete complete: @escaping([Movie]) ->())
    {
        
        guard let url=URL(string: movieUrl) else {
            
            print("Invalid Url format: \(movieUrl)");
            return;
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            
            guard let jsonString = String(data: data!, encoding: String.Encoding.utf8) else {
                
                print("Error while parsing the response data")
                return
            }
            
            let movies = self.parse(response: jsonString, withLimit: limit)
    
            complete(movies)
            
        }.resume()
    }
    
    //解析Json数据
    func parse(response: String, withLimit limit: Double) -> [Movie] {
        
        guard let context = context else {
            
            print("JSContext not found")
            
            return []
        }
       
        let parseFunction = context.objectForKeyedSubscript("parseJson")
        
        guard let parsed = parseFunction?.call(withArguments: [response]).toArray() else {
            
            print("Unable to parse Json")
            
            return []
        }
        
        let filterFunction = context.objectForKeyedSubscript("filterByLimit")
        
        let filtered = filterFunction?.call(withArguments: [parsed,limit]).toArray()
        
        let mapFunction = context.objectForKeyedSubscript("mapToNative")
        
        guard let movies=mapFunction?.call(withArguments: [filtered!]).toArray() as? [Movie] else {
            
            return []
        }
        
        return movies
        

//        let builderBlock = unsafeBitCast(Movie.movieBuilder, to: AnyObject.self)
//
//        context.setObject(builderBlock, forKeyedSubscript: "movieBuilder" as (NSCopying & NSObjectProtocol)!)
//        let builder = context.evaluateScript("movieBuilder")
//
//        guard let movies=builder?.call(withArguments: [filtered!]).toArray() as? [Movie] else {
//
//            print("Error while processing movies.")
//            return[]
//        }

    }
}
