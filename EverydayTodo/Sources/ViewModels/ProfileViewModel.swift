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
            //[STUDY : Color]
            switch self {
            case .marigold: return UIColor(red: 255/255.0, green: 173/255.0, blue: 74/255.0, alpha: 1)
            case .coraulean: return UIColor(red: 152/255.0, green: 180/255.0, blue: 216/255.0, alpha: 1)
            case .greenAsh: return UIColor(red: 159/255.0, green: 219/255.0, blue: 173/255.0, alpha: 1)
            case .BurntCoral: return UIColor(red: 233/255.0, green: 137/255.0, blue: 126/255.0, alpha: 1)
            }
        }
        var unselected: UIColor{
            switch self {
            case .marigold: return UIColor(red: 255/255.0, green: 224/255.0, blue: 169/255.0, alpha: 1) //255,240,212
            case .coraulean: return UIColor(red: 201/255.0, green: 216/255.0, blue: 232/255.0, alpha: 1)
            case .greenAsh: return UIColor(red: 200/255.0, green: 234/255.0, blue: 208/255.0, alpha: 1) //218, 241, 223
            case .BurntCoral: return UIColor(red: 244/255.0, green: 195/255.0, blue: 190/255.0, alpha: 1)
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
    func fetchColor() {
        let color = CurrentColor(rawValue: "\(manager.getThemeColor())")
        updateColor(color ?? .marigold)
    }
}
