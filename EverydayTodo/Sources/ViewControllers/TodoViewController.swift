//
//  ViewController.swift
//  EverydayTodo
//
//  Created by Tony Jung on 2020/12/14.
//

import UIKit
import BLTNBoard

class TodoViewController: UIViewController {
    
    private lazy var boardManager: BLTNItemManager = {
        let item = BLTNPageItem(title: "Push Notifications")
        item.image = UIImage(systemName: "plus")
        item.actionButtonTitle = "Continue"
        item.descriptionText = "Would you like to say in the loop and get notifications?"
        item.alternativeButtonTitle = "maybe later"
        
        //textfield added
        
        
        item.actionHandler = { _ in
            self.didTapBoardContinue()
        }
        
        item.alternativeHandler = { _ in
            self.didTapBoardSkip()
        }
        
       return BLTNItemManager(rootItem: item)
    }()

    
    func didTapBoardContinue(){
        print("did tapped")
        
    }
    func didTapBoardSkip(){
        print("did tapped")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension TodoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodoCell", for: indexPath) as? TodoCollectionViewCell else { return UICollectionViewCell() }
        
        cell.backgroundColor = [UIColor.red, UIColor.blue, UIColor.yellow, UIColor.white].randomElement()
        print("called")
        //셀 재사용 원치 않을떄? 
        //.randomelement
        
        cell.layer.cornerRadius = 10.0
        return cell
        
    }
    //Header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerView", for: indexPath) as? HeaderCollectionReusableView else { return UICollectionReusableView() }
  
            //[TODO: 정리하기! ]
            headerView.slider.value = 0.6
            headerView.profileImage.makeRounded() //profile radius
            headerView.uiViewController = self //할수잇는방법2개 1. 현재의 정보를 보내기, 2. actionhandler구현해서 사용하기.
            headerView.addTaskButton.addTarget(self, action: #selector(didTappedHeaderViewButton), for: .touchUpInside)
            return headerView
        default:
            assert(false, "dd")
        }
    }
    @objc func didTappedHeaderViewButton(){
        //Manager
        boardManager.showBulletin(above: self)
    }

}
extension TodoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //TODO: 가로모드와 세로모드의 셀 사이징이 다름. 
        let margin: CGFloat = 10
        let itemSpacing: CGFloat = 10
        let width: CGFloat = (collectionView.bounds.width - margin * 2 - itemSpacing)/2
        let height: CGFloat = width
        return CGSize(width: width, height: height)
    }
    
    
}


