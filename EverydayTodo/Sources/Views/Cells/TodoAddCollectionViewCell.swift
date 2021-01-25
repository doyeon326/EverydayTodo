//  TodoAddCell.swift
//  EverydayTodo
//
//  Created by laohanme on 23/01/2021.
//
import UIKit

class TodoAddCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        layer.borderColor = UIColor.tertiarySystemFill.cgColor
        layer.borderWidth = 3
        layer.cornerRadius = 10
    }
}
