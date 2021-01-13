//
//  ProfileViewModel.swift
//  EverydayTodo
//
//  Created by Tony Jung on 2021/01/13.
//

import UIKit

class ProfileViewModel {
    enum CurrentColor: String, CaseIterable{
        case marigold
        case coraulean
        case greenAsh
        case BurntCoral
        
        var rgb: UIColor{
            switch self {
            case .marigold: return UIColor(red: 255/255.0, green: 173/255.0, blue: 74/255.0, alpha: 1)
            case .coraulean: return UIColor(red: 48/255.0, green: 120/255.0, blue: 180/255.0, alpha: 1)
            case .greenAsh: return UIColor(red: 159/255.0, green: 219/255.0, blue: 173/255.0, alpha: 1)
            case .BurntCoral: return UIColor(red: 233/255.0, green: 137/255.0, blue: 126/255.0, alpha: 1)
            }
        }
    }
    
    private let manager = ProfileManager.shared
    private (set) var color: CurrentColor = .marigold
    
    var profile : [Profile] {
        return manager.profile
    }
    func setUpProfile(nickName: String, profileImg: Data){
        manager.setUpProfile(nickName: nickName, profileImg: profileImg, themeColor: color.rawValue)
    }
    func fetchProfile(){
        manager.fetchProfile()
        let color = CurrentColor(rawValue: "\(manager.getThemeColor())")
        updateColor(color ?? .marigold)
    }
    func updateColor(_ type: CurrentColor){
        self.color = type
    }
}
