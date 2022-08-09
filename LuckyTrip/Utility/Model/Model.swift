//
//  Model.swift
//  LuckyTrip
//
//  Created by Li on 2022/8/9.
//

import Foundation
import SwiftyJSON

enum SearchType: String {
    case none = "none"
    case city = "city"
    case country = "country"
    case city_or_country = "city_or_country"
}

class Destination: NSObject {
    var id = Int()
    var city = String()
    var country_name = String()
    var airport_name = String()
    var country_code = String()
    var latitude = Double()
    var longitude = Double()
    var iata_code = String()
    var is_enabled = Bool()
    var image = String()
    var video = String()
    var descr = String()
    
    init(_ json: JSON) {
        self.id = json["id"].intValue
        self.city = json["city"].stringValue
        self.country_name = json["country_name"].stringValue
        self.airport_name = json["airport_name"].stringValue
        self.country_code = json["country_code"].stringValue
        self.latitude = json["latitude"].doubleValue
        self.longitude = json["longitude"].doubleValue
        self.iata_code = json["iata_code"].stringValue
        self.is_enabled = json["is_enabled"].boolValue
        self.image = json["thumbnail"]["image_url"].stringValue
        self.video = json["destination_video"]["url"].stringValue
        self.descr = json["descr"].stringValue
    }
}