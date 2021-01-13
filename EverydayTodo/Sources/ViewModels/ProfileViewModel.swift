//
//  ProfileViewModel.swift
//  EverydayTodo
//
//  Created by Tony Jung on 2021/01/13.
//

import Foundation

class ProfileViewModel {
    private let manager = ProfileManager.shared
    
    var profile : [Profile] {
        return manager.profile
    }
    func setUpProfile(nickName: String, profileImg: Data){
        manager.setUpProfile(nickName: nickName, profileImg: profileImg)
    }
    func fetchProfile(){
        manager.fetchProfile()
  
        
    }
}
