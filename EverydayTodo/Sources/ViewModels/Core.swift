//
//  Core.swift
//  EverydayTodo
//
//  Created by Tony Jung on 2021/01/17.
//

import Foundation


class Core {
    static let shared = Core()
    
    func isNewUser() -> Bool {
        return !UserDefaults.standard.bool(forKey: "isNewUser")
    }
    
    
    func setIsNotNewUser() {
        UserDefaults.standard.set(true, forKey: "isNewUser")
    }
}


