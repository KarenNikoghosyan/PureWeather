//
//  DateFormatter+Extensions.swift
//  PureWeather
//
//  Created by Karen Nikoghosyan on 23/09/2021.
//

import Foundation

extension DateFormatter {
    func dateFormatter(unixTime: Double) -> (DateFormatter, Date) {
        let dateFormatter = DateFormatter()
        let epochTime = TimeInterval(unixTime)
        let date = Date(timeIntervalSince1970: epochTime)
        dateFormatter.locale = Locale(identifier: "en_US")
        return (dateFormatter, date)
    }
}
