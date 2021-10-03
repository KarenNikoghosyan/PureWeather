//
//  Double+Extensions.swift
//  PureWeather
//
//  Created by Karen Nikoghosyan on 03/10/2021.
//

import Foundation

extension Double {
    var unixTimeToDate: String {
        let tuple = DateFormatter().dateFormatter(unixTime: self)
        let dateFormatter = tuple.0
        let date = tuple.1
        dateFormatter.dateFormat = "dd/MM"
        return dateFormatter.string(from: date)
    }
    
    var unixTimeToTime: String {
        let tuple = DateFormatter().dateFormatter(unixTime: self)
        let dateFormatter = tuple.0
        let date = tuple.1
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: date)
    }
}
