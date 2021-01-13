//
//  Profile.swift
//  EverydayTodo
//
//  Created by Tony Jung on 2021/01/10.
//

import UIKit
import CoreData

class ProfileManager {
    static let shared = ProfileManager()
    var profile: [Profile] = []

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func setUpProfile(nickName: String, profileImg: Data){
        if profile.count > 0 {
            profile.last?.nickName = nickName
            profile.last?.profileImg = profileImg
            saveProfile()
        }
        else {
            let profileInstace = Profile(context: context)
            profileInstace.profileImg = profileImg
            profileInstace.nickName = nickName
            saveProfile()
        }
    }
    
    func fetchProfile() {
        do{
            self.profile = try context.fetch(Profile.fetchRequest())
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    func saveProfile(){
        do{
            try context.save()
        }
        catch{
            print(error.localizedDescription)
        }
    }
}

