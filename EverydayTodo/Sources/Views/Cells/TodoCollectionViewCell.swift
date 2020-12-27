//
//  TodoCollectionViewCell.swift
//  EverydayTodo
//
//  Created by Tony Jung on 2020/12/14.
//

import UIKit

class TodoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var detail: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //재사용되기전
        //[TODO: 찾아보기! ]
    
        backgroundColor = nil
    }
}
