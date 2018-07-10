//
//  CafeModel.swift
//  CafeSearch
//
//  Created by EthanLin on 2018/5/3.
//  Copyright © 2018年 EthanLin. All rights reserved.
//

import Foundation

struct Cafe:Codable {
    var id:String?
    var name:String?
    var city:String?
    var wifi:Double?
    var seat:Double?
    var quiet:Double?
    var tasty:Double?
    var cheap:Double?
    var music:Double?
    var url:String?
    var address:String?
    var latitude:String?
    var longitude:String?
    var limitedTime:String?
    var socket:String?
    var standingDesk:String?
    var mrt:String?
    var openTime:String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case city = "city"
        case wifi = "wifi"
        case seat = "seat"
        case quiet = "quiet"
        case tasty = "tasty"
        case cheap = "cheap"
        case music = "music"
        case url = "url"
        case address = "address"
        case latitude = "latitude"
        case longitude = "longitude"
        case limitedTime = "limited_time"
        case socket = "socket"
        case standingDesk = "standing_desk"
        case mrt = "mrt"
        case openTime = "open_time"
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try? valueContainer.decode(String.self, forKey: CodingKeys.id)
        self.name = try? valueContainer.decode(String.self, forKey: CodingKeys.name)
        self.city = try? valueContainer.decode(String.self, forKey: CodingKeys.city)
        self.wifi = try? valueContainer.decode(Double.self, forKey: CodingKeys.wifi)
        self.seat = try? valueContainer.decode(Double.self, forKey: CodingKeys.seat)
        self.quiet = try? valueContainer.decode(Double.self, forKey: CodingKeys.quiet)
        self.tasty = try? valueContainer.decode(Double.self, forKey: CodingKeys.tasty)
        self.cheap = try? valueContainer.decode(Double.self, forKey: CodingKeys.cheap)
        self.music = try? valueContainer.decode(Double.self, forKey: CodingKeys.music)
        self.url = try? valueContainer.decode(String.self, forKey: CodingKeys.url)
        self.address = try? valueContainer.decode(String.self, forKey: CodingKeys.address)
        self.latitude = try? valueContainer.decode(String.self, forKey: CodingKeys.latitude)
        self.longitude = try? valueContainer.decode(String.self, forKey: CodingKeys.longitude)
        self.limitedTime = try? valueContainer.decode(String.self, forKey: CodingKeys.limitedTime)
        self.socket = try? valueContainer.decode(String.self, forKey: CodingKeys.socket)
        self.standingDesk = try? valueContainer.decode(String.self, forKey: CodingKeys.standingDesk)
        self.mrt = try? valueContainer.decode(String.self, forKey: CodingKeys.mrt)
        self.openTime = try? valueContainer.decode(String.self, forKey: CodingKeys.openTime)
    }
}



