//
//  CustomDateFormatter.swift
//  TravelSchedule
//
//  Created by Owi Lover on 7/14/25.
//

import OpenAPIRuntime
import Foundation

struct CustomDateTranscoder: DateTranscoder {
    public func encode(_ date: Date) throws -> String { ISO8601DateFormatter().string(from: date) }

    public func decode(_ dateString: String) throws -> Date {
        print("date about to decode: \(dateString)")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "Europe/Moscow")
        
        guard let date = dateFormatter.date(from: dateString) else { throw DecodingError.dataCorrupted(
            .init(codingPath: [], debugDescription: "Expected date string can't be formatted.")
        ) }

        return date
    }
}
