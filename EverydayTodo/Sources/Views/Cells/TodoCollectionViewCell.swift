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
    @IBOutlet weak var checkMark: UIImageView!
    
    let profileViewModel = ProfileViewModel()

     var todoListData: Todo! {
         didSet {
            profileViewModel.fetchColor()
             if todoListData.isDone == true {
                self.backgroundColor = profileViewModel.color.rgb
                 checkMark.isHidden = false
             }
             else{
                self.backgroundColor = profileViewModel.color.unselected
                checkMark.isHidden = true
             }

             detail.text = todoListData.detail
            day.text = todoListData.date?.toString(formatType: .day)
            date.text = todoListData.date?.toString(formatType: .date)
            month.text = todoListData.date?.toString(formatType: .month)
         }
     }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //재사용되기전
        //[TODO: 찾아보기! ]
    
        backgroundColor = nil
    }
    
    override func awakeFromNib() {
    
         layer.cornerRadius = 10.0
     }
}
