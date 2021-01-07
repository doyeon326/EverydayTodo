//
//  NSDateFormatter+Extensions.swift
//  EverydayTodo
//
//  Created by Tony Jung on 2020/12/30.
//


import Foundation

extension Date{
    //[] i dont know how to make it better. 
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
        formatter.locale = .current
        return formatter.string(from: self)
    }
    func getDate() -> String{
        //return Calendar.current.component(.day, from: self)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter.string(from: self)
    }
    func getDay() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter.string(from: self)
    }
    func getMonthString() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.string(from: self)
    }
}


