//
//  HeaderCollectionReusableView.swift
//  EverydayTodo
//
//  Created by Tony Jung on 2020/12/17.
//

import UIKit


class HeaderCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var addTaskButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nickName: UILabel!
    var uiViewController: UIViewController!
    @IBOutlet weak var progressView: ProgressView!
    @IBOutlet weak var percentage: UILabel!
    @IBOutlet weak var changeProfileButton: UIButton!
    @IBOutlet weak var archiveButton: UIButton!
    @IBOutlet weak var adButton: UIButton!
    func configure(){
        //do UISetups
    }
}
