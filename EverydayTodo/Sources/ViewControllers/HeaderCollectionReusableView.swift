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
    @IBOutlet weak var slider: SliderView!
    @IBOutlet weak var profileImage: UIImageView!
    var uiViewController: UIViewController! 
    
    func configure(){
        //do UISetups
    }
}
