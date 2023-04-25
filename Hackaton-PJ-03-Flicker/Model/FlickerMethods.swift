//
//  FlickerMethods.swift
//  Hackaton-PJ-03-Flicker
//
//  Created by Raman Kozar on 24/04/2023.
//

import SwiftyJSON
import Alamofire

// Data Source for collection view
var imageURLs = [URL]()

// Unique API Flickr key
let apiKey = "de35d9de9fe9db7246ab00a85372e8df"

// NSCache to cache all downloaded images
var imageCache: NSCache<AnyObject, AnyObject> = NSCache()

enum CustomError: Error {

    // Throw when an expected resource is not found
    case notFound

}

class FlickerAPI {

    func createRequestURL(text: String) -> URL {
        
        var componentsURL = URLComponents()
        
        componentsURL.scheme = "https"
        componentsURL.host = "api.flickr.com"
        componentsURL.path = "/services/rest"
        componentsURL.queryItems = [URLQueryItem]()
        
        let queryKeyParameter = URLQueryItem(name: "api_key", value: apiKey)
        let queryMethodParameter = URLQueryItem(name: "method", value: "flickr.photos.search")
        let queryFormatParameter = URLQueryItem(name: "format", value: "json")
        let queryTextParameter = URLQueryItem(name: "text", value: text)
        let queryExtraParameter = URLQueryItem(name: "extras", value: "url_l")
        let queryNojsoncallbackParameter = URLQueryItem(name: "nojsoncallback", value: "1")
        let queryPageParameter = URLQueryItem(name: "page", value: "1")

        componentsURL.queryItems!.append(queryKeyParameter)
        componentsURL.queryItems!.append(queryMethodParameter)
        componentsURL.queryItems!.append(queryFormatParameter)
        componentsURL.queryItems!.append(queryTextParameter)
        componentsURL.queryItems!.append(queryExtraParameter)
        componentsURL.queryItems!.append(queryNojsoncallbackParameter)
        componentsURL.queryItems!.append(queryPageParameter)
        
        return componentsURL.url!
        
    }
    
    func downloadDataUsingAPI(_ requestURL: URL, completion: @escaping (_ data: NSDictionary?, _ error: Error?) -> Void) {
        
        AF.request(requestURL).validate().responseJSON { data in
            
            if let json = try? data.result.get() {
                completion(json as? NSDictionary, nil)
            } else {
                completion(nil, CustomError.notFound)
                return
            }
            
        }
        
    }
    
    func getImageByURL(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func parsingJSON_DuringSearch(_ searchText: String, _ json: NSDictionary) -> [URL] {
        
        let finalJSON = JSON(json)
        
        var imageURLs = [URL]()
        let photoArray = finalJSON["photos"]["photo"].arrayValue
        
        for count in 0 ..< photoArray.count where imageURLs.count < 1000 {
            
            let urlString = photoArray[count]["url_l"].stringValue
            
            if let currentURL = URL(string: urlString) {
                imageURLs.append(currentURL)
            }
            
        }
        
        return imageURLs
        
    }
    
}

// For each error type return the appropriate description
extension CustomError: CustomStringConvertible {
   
    public var description: String {
        switch self {
        case .notFound:
            return "The specified item could not be found."
        }
    }
    
}

// For each error type return the appropriate localized description
extension CustomError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .notFound:
            return NSLocalizedString(
                "The specified item could not be found.",
                comment: "Resource Not Found"
            )
        }
        
    }
    
}
