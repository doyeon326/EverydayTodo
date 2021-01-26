//  TodoAddCell.swift
//  EverydayTodo
//
//  Created by laohanme on 23/01/2021.
//
import UIKit

class TodoAddCollectionViewCell: UICollectionViewCell {

    var profileViewModel: ProfileViewModel!{
        didSet{
            layer.borderColor = profileViewModel.color.rgb.cgColor
            layer.borderWidth = 3
            layer.cornerRadius = 10
        }
    }
    
    override func awakeFromNib() {
     
    }
}
