//
//  NSDateFormatter+Extensions.swift
//  EverydayTodo
//
//  Created by Tony Jung on 2020/12/30.
//


import Foundation

extension Date{
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
        formatter.locale = .current
        return formatter.string(from: self)
    }
    func getDate() -> String{
        return ""
    }
    func getDay() -> String{
        return ""
    }
    func getMonth() -> String{
        return ""
    }
}


