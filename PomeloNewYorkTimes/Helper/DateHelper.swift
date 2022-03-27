//
//  DateHelper.swift
//  PomeloNewYorkTimes
//
//  Created by Chaiyatat Saiphin on 25/3/2565 BE.
//

import Foundation

struct DateHelper {
    static func convertDate(source: String,
                            sourceFormat: String,
                            destinationFormat: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = sourceFormat
        guard let date = dateFormatter.date(from: source) else { return nil }
        dateFormatter.dateFormat = destinationFormat
        return dateFormatter.string(from: date)
    }
}
