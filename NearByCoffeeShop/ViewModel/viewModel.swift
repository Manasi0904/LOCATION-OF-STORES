//
//  viewModel.swift
//  NearByCoffeeShop
//
//  Created by Kumari Mansi on 20/01/25.
//


import Foundation

class StoreViewModel {
    
    private var store: stores
    var storeName: String {
        return store.storeName
    }
    
    var storeAddress: String {
        return store.storeAddress
    }

    var storeImagePath: URL? {
        return URL(string: store.storeImagePath)
    }
    var businessHours: String? {
        let currentDay = getTodayDay()
        if let todayBusinessHour = store.businessHours.first(where: { $0.day.uppercased() == currentDay }) {
            if todayBusinessHour.isAvalilable247 {
                return "Open 24/7"
            } else {
                guard let timings = todayBusinessHour.storeTimings?.first else { return nil }
                let openTime = formatToAMPM(timings.openTime)
                let closeTime = formatToAMPM(timings.closeTime)
                return "\(openTime) - \(closeTime)"
            }
        }
        
        return nil
    }


    init(store: stores) {
        self.store = store
    }
    func getTodayDay() -> String {
        return fetchCurrentDay()
    }
    private func fetchCurrentDay() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: Date()).uppercased()
    }
    private func formatToAMPM(_ time: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        if let date = dateFormatter.date(from: time) {
            dateFormatter.dateFormat = "h:mm a"
            return dateFormatter.string(from: date)
            
        }
        return time
    }
}

