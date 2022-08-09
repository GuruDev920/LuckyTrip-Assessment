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
}
