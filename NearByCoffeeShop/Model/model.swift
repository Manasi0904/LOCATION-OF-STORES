//
//  model.swift
//  NearByCoffeeShop
//
//  Created by Kumari Mansi on 20/01/25.
//


import Foundation
struct StoreResponse: Codable {
    let timeStamp: Int
    let stores: [stores]
}

struct stores: Codable {
    let storeOid: Int
    let storeName: String
    let storeAddress: String
    let storeImagePath: String
    let latitude: String
    let longitude: String
    let businessHours: [BusinessHour]
  
}

struct BusinessHour: Codable {
    let day: String
    let isHoliday: Bool
    let isAvalilable247: Bool
   let storeTimings: [StoreTiming]?

}

struct StoreTiming: Codable {
    let openTime: String
    let closeTime: String
}
