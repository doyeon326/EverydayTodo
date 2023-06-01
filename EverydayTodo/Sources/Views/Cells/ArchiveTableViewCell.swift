//
//  ArchiveTableViewCell.swift
//  EverydayTodo
//
//  Created by doyeon kim on 2023/05/29.
//

import UIKit

class ArchiveTableViewCell: UITableViewCell {
    static let identifier = "ArchiveTableViewCell"

    @IBOutlet weak var archiveView: UIView!
    @IBOutlet weak var checkmark: UIImageView!
    @IBOutlet weak var trashButton: UIButton!
    @IBOutlet weak var restoreButton: UIButton!

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var archiveContent: UILabel!
    
    let profileViewModel = ProfileViewModel()
    
    var archiveData: Todo! {
        didSet {
            profileViewModel.fetchColor()
            if archiveData.isDone == true {
               archiveView.backgroundColor = profileViewModel.color.rgb
                checkmark.isHidden = false
            }
            else{
                archiveView.backgroundColor = profileViewModel.color.unselected
                checkmark.isHidden = true
            }
            archiveContent.text = archiveData.detail
            date.text = "\(archiveData.date?.toString(formatType: .month) ?? "") \(archiveData.date?.toString(formatType: .date) ?? "")"


        }
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
