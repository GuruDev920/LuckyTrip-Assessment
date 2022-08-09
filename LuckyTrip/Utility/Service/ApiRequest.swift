//
//  ApiRequest.swift
//  LuckyTrip
//
//  Created by Li on 2022/8/9.
//

import Foundation
import Alamofire
import SwiftyJSON
import Reachability

class ApiRequest: NSObject {
    let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    var dataTask: URLSessionDataTask?
    
    class func requestGet(URL:String, params: [String: String], headers: [String: String] = [:], completion:@escaping (_ result: JSON?, _ error: String?) -> Void)
    {
        let reachable = try! Reachability()
        if reachable.connection != .unavailable {
            let urlComp = NSURLComponents(string: URL)
            var items = [URLQueryItem]()
            for (key,value) in params {
                items.append(URLQueryItem(name: key, value: value))
            }
            items = items.filter{!$0.name.isEmpty}
            if !items.isEmpty {
                urlComp!.queryItems = items
            }
            
            let session = URLSession.shared
            var request = URLRequest(url: urlComp!.url!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 60)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
            request.httpMethod = "GET"
            let httpTask = session.dataTask(with: request as URLRequest) {
                data, response, error in
                
                if data != nil {
                    guard let result = try? JSON(data: data!) else {
                        completion(nil, "Error format data")
                        return
                    }
                    completion(result, nil)
                } else {
                    completion(nil, "Error data.")
                }
            }
                
            httpTask.resume()
            
        } else {
            completion(nil, "Network not found")
        }
    }
    
    class func requestPost(URL:String ,parameters: [String: AnyObject], completion:@escaping (_ result: JSON?, _ error: String?) -> Void)
    {
        let reachable = try! Reachability()
        if reachable.connection != .unavailable {
            let session = URLSession.shared
            let request = NSMutableURLRequest(url : NSURL(string: URL)! as URL)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.timeoutInterval = 60
            request.httpMethod = "POST"
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                request.httpBody = jsonData
            } catch {
                completion(nil, error.localizedDescription)
            }
            
            let httpTask = session.dataTask(with: request as URLRequest) {
                data, response, error in
            
                if data != nil {
                    guard let result = try? JSON(data: data!) else {
                        completion(nil, "Error format data")
                        return
                    }
                    completion(result, nil)
                } else {
                    completion(nil, "Error data.")
                }
            }
            httpTask.resume()
        } else {
            completion(nil, "Network not found")
        }
    }
}

