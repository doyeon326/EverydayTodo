//
//  NSDateFormatter+Extensions.swift
//  EverydayTodo
//
//  Created by Tony Jung on 2020/12/30.
//  ref : https://www.zerotoappstore.com/get-year-month-day-from-date-swift.html


import Foundation

extension Date {

    enum DateFormatType: String {
        case full
        case date
        case day
        case month
        
        var dateFormatString: String {
            switch self {
            case .full: return "MM/dd/yyyy HH:mm:ss"
            case .date: return "dd"
            case .day: return "E"
            case .month: return "MMM"
            }
        }
    }
    
    func toString(formatType: DateFormatType, timeZone: TimeZone = .current, locale: Locale = .current) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        
        formatter.dateFormat = formatType.dateFormatString
        formatter.locale = Locale(identifier: "en_US") //for the mean time.. 
        return formatter.string(from: self)
    }
}


