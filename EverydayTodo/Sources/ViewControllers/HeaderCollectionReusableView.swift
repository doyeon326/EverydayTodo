//
//  HeaderCollectionReusableView.swift
//  EverydayTodo
//
//  Created by Tony Jung on 2020/12/17.
//

import UIKit
import BLTNBoard


class HeaderCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var addTaskButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    var uiViewController: UIViewController!
    @IBOutlet weak var progressView: ProgressView!
    
    func configure(){
        //do UISetups
    }
}
