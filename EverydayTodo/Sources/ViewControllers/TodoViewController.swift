//
//  ViewController.swift
//  EverydayTodo
//
//  Created by Tony Jung on 2020/12/14.
//

import UIKit
import CoreData
import Lottie
import GoogleMobileAds
import AdSupport
import AppTrackingTransparency

class TodoViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    let todoListViewModel = TodoViewModel()
    let profileViewModel = ProfileViewModel()
    let animationView = LottieAnimationView()
    private var interstitialAd: GADInterstitialAd?

    override func viewDidLoad() {
        super.viewDidLoad()
        todoListViewModel.loadTasks()
        profileViewModel.fetchProfile()
        
    
       
        DispatchQueue.main.async {
            self.createAd()
        }
  
    
      
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            layout.sectionHeadersPinToVisibleBounds = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if Core.shared.isNewUser() {
            // show onboarding
            let sb = UIStoryboard(name: "Welcome", bundle: nil)
            let vc = sb.instantiateViewController(identifier: "welcome") as! WelcomeViewController
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
    }
}

extension TodoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return todoListViewModel.todos.count  //+ 1 // add + 1 for AddCell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodoCell", for: indexPath) as? TodoCollectionViewCell else { return UICollectionViewCell() }

        if indexPath.row < todoListViewModel.todos.count {
            cell.todoListData = todoListViewModel.todos[indexPath.row]
            return cell
        }
        else{
            guard let addCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddCell", for: indexPath) as? TodoAddCollectionViewCell else { return TodoAddCollectionViewCell()}
            addCell.profileViewModel = profileViewModel
            return addCell
        }
    }
    
    //Header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerView", for: indexPath) as? HeaderCollectionReusableView else { return UICollectionReusableView() }
  
            //animation
         
            
            //[TODO: 정리하기! ]
            let percentage = todoListViewModel.calculatePercentage()
            
            headerView.progressView.setProgress(Float(percentage) / 100, animated: true)
            headerView.progressView.progressTintColor = profileViewModel.color.rgb
            if percentage == 100 {
                setupAnimation()
            }
            headerView.profileImage.makeRounded() //profile radius
            let convertedImage = profileViewModel.profile.last?.profileImg
            if convertedImage != nil {
                headerView.profileImage.image = UIImage(data: convertedImage ?? Data())
            }
            else {
                headerView.profileImage.image = UIImage(systemName: "person.fill")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
            }
            headerView.nickName.text = profileViewModel.profile.last?.nickName
            headerView.uiViewController = self //할수잇는방법2개 1. 현재의 정보를 보내기, 2. actionhandler구현해서 사용하기.
            headerView.percentage.text = "\(percentage)%"
            headerView.addTaskButton.addTarget(self, action: #selector(showModal), for: .touchUpInside)
            headerView.changeProfileButton.addTarget(self, action: #selector(changeProfile), for: .touchUpInside)
            headerView.archiveButton.addTarget(self, action: #selector(showArchiveList), for: .touchUpInside)
        
            headerView.adButton.addTarget(self, action: #selector(didTapAdButton), for: .touchUpInside)
            
            headerView.adButton.isHidden = false
            headerView.adButton.isEnabled = true
            //[question: How to implement the code below?]
//            headerView.addTaskButton = UIButton(type: .system, primaryAction: UIAction(handler: { (_) in
//                self.showModal()
//                self.todoListViewModel.updateMode(.write)
//            })
            return headerView
        default:
            assert(false, "dd")
        }
        return UICollectionReusableView()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
  
        if indexPath.row < todoListViewModel.todos.count {
            todoListViewModel.todos[indexPath.row].isDone = !todoListViewModel.todos[indexPath.row].isDone
            todoListViewModel.saveToday()
            collectionView.reloadData()
        }
        else {
            showModal(index: indexPath.row as NSNumber)
        }
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
//MARK: action events
extension TodoViewController: GADFullScreenContentDelegate {//
    @objc func showModal(index: NSNumber?){
        let vc = self.storyboard?.instantiateViewController(identifier: "ModalViewController") as! ModalViewController
        vc.modalTransitionStyle = .crossDissolve
        vc.modalViewModel = todoListViewModel
        if todoListViewModel.fetchMode() == .edit{
            vc.todos = todoListViewModel.todos[index as! Int]
        }
        present(vc, animated: true, completion: nil)
    }
    
    func fetchTasks(){
        todoListViewModel.loadTasks()
        profileViewModel.fetchProfile()
        self.collectionView.reloadData()
    }
    
    
    
    @objc func changeProfile(){
        guard let vc = (self.storyboard?.instantiateViewController(identifier: "EditProfileViewController") as? EditProfileViewController) else { return }
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
        
    }
    
    @objc func showArchiveList() {
        guard let vc = (self.storyboard?.instantiateViewController(withIdentifier: ArchiveViewController.identifier) as? ArchiveViewController) else { return }
        
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)
        
    }
    
    @objc func didTapAdButton() {
        
        if #available(iOS 14, *) {
                   ATTrackingManager.requestTrackingAuthorization { (status) in
       //                switch status {
       //                case .authorized:
       //                case .denied:
       //                case .notDetermined:
       //                case .restricted
       //                }
                   }
               }
//        let aa = ASIdentifierManager()
//
//        print("id: \(aa.advertisingIdentifier)")
//
//
                      
        let x = Int.random(in: 0..<10)
        if x % 2 == 0 {
            if interstitialAd != nil {
                interstitialAd!.present(fromRootViewController: self)
            } else {
              print("Ad wasn't ready")
            }
        }


    }

    private func createAd() {
            let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: Constants.unitAdId, request: request) { [self] ad, error in
                if let error = error {
                    print("Failed to load interstitial ad with error \(error.localizedDescription)")
                    return
                }
                self.interstitialAd = ad
                self.interstitialAd?.fullScreenContentDelegate = self
            }

    }

    /// Tells the delegate that the ad failed to present full screen content.
     func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
       print("Ad did fail to present full screen content.")
     }

     /// Tells the delegate that the ad will present full screen content.
     func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
       print("Ad will present full screen content.")
     }

     /// Tells the delegate that the ad dismissed full screen content.
     func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
         DispatchQueue.main.async {
             self.createAd()

         }
                print("Ad did dismiss full screen content.")
     }

    
    func setupAnimation(){
        animationView.frame = view.bounds
        animationView.backgroundColor = .clear
        animationView.animation = LottieAnimation.named("32585-fireworks-display")
        animationView.contentMode = .scaleAspectFit
        //animationView.loopMode = .loop
        animationView.isUserInteractionEnabled = false
        animationView.frame = CGRect(x: 50, y: 80, width: 150, height: 150)
        view.addSubview(animationView)
        animationView.play()
    }
    

}
//MARK: Context Menu
//TODO: try to make it somewhere else to reuse it just in case.
extension TodoViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        configureContextMenu(index: indexPath.row)
    }
 
    func configureContextMenu(index: Int) -> UIContextMenuConfiguration{
        if index < todoListViewModel.todos.count {
            let context = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (action) -> UIMenu? in
                let edit = UIAction(title: "Edit", image: UIImage(systemName: "square.and.pencil"), identifier: nil, discoverabilityTitle: nil, state: .off) { (_) in
                    print("edit button clicked")
                    self.todoListViewModel.updateMode(.edit)
                    self.showModal(index: index as NSNumber)
                }
                let delete = UIAction(title: "Archive", image: UIImage(systemName: "archivebox.fill"), identifier: nil, discoverabilityTitle: nil,attributes: .destructive, state: .off) { (_) in
                    print("archive button clicked")
                    //TodoManager.shared.deleteTodo(self.items?[index] ?? Todo() )
//                    self.todoListViewModel.deleteTodo(self.todoListViewModel.todos[index])
                    let todo = self.todoListViewModel.todos[index]
         
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(self.todoListViewModel.todos[index].detail ?? "")"])
                    todo.isArchive = true
                    self.todoListViewModel.updateTodo(todo)
//
//
                    self.fetchTasks()
                }
                
                return UIMenu(title: "Options", image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: [edit,delete])
            }
            return context
        }
        else {
            return UIContextMenuConfiguration()
        }
    }
    

}
