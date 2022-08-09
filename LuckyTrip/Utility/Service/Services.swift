//
//  Services.swift
//  LuckyTrip
//
//  Created by Li on 2022/8/9.
//

import Foundation
import SwiftyJSON

class Services: NSObject {
    static func getUrl() -> String {
        let baseURL = "https://devapi.luckytrip.co.uk/api/2.0/test/destinations"
        return baseURL
    }
    
    class func getDestinations(type: SearchType, value: String, completion: @escaping (_ result: JSON?, _ error: String?) -> Void) {
        let url = getUrl()
        let params = ["search_type": type.rawValue, "search_value": value]
        ApiRequest.requestGet(URL: url, params: params) {(result, error) in
            completion(result, error)
        }
    }
}
