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
    
//    private lazy var boardManager: BLTNItemManager = {
//        let item = BLTNPageItem(title: "Push Notifications")
//        item.image = UIImage(named: "doyeon")
//        item.actionButtonTitle = "Continue"
//        item.descriptionText = "Would you like to say in the loop and get notifications?"
//
//
//        item.actionHandler = { _ in
//            self.didTapBoardContinue()
//        }
//
//        item.alternativeHandler = { _ in
//            self.didTapBoardSkip()
//        }
//
//       return BLTNItemManager(rootItem: item)
//    }()
    
//    @IBAction func didTapButton(_ sender: Any) {
//       // boardManager.showBulletin(above: uiViewController) //새로생성하는거여서 없다.
//        //target 설정.. !
//    }

//    func didTapBoardContinue(){
//        print("did tapped")
//
//    }
//    func didTapBoardSkip(){
//        print("did tapped")
//    }
    
    
}
