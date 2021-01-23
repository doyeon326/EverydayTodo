//
//  TodoAddCell.swift
//  EverydayTodo
//
//  Created by laohanme on 23/01/2021.
//

import UIKit

class TodoAddCollectionViewCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        layer.borderColor = UIColor.systemBlue.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 10
    }
}
