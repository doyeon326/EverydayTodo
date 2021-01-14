//
//  ViewController.swift
//  EverydayTodo
//
//  Created by Tony Jung on 2020/12/14.
//

import UIKit
import CoreData
import Lottie

class TodoViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let todoListViewModel = TodoViewModel()
    let profileViewModel = ProfileViewModel()
    let animationView = AnimationView()

    override func viewDidLoad() {
        super.viewDidLoad()
      //  setupAnimation()
        //setupLongGestureRecognizerOnCollection()
        todoListViewModel.loadTasks()
        profileViewModel.fetchProfile()
       
        
    }
}

extension TodoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return todoListViewModel.todos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodoCell", for: indexPath) as? TodoCollectionViewCell else { return UICollectionViewCell() }
        
        if todoListViewModel.todos[indexPath.row].isDone == true {

            cell.backgroundColor = profileViewModel.color.rgb
            cell.checkMark.isHidden = false
        }
        else{
            cell.backgroundColor = profileViewModel.color.unselected
            cell.checkMark.isHidden = true
        }
            //[UIColor.red, UIColor.blue, UIColor.yellow, UIColor.white].randomElement()
        cell.layer.cornerRadius = 10.0
//        cell.layer.shadowColor = UIColor.gray.cgColor
//        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
//        cell.layer.shadowRadius = 3.0
//        cell.layer.shadowOpacity = 0.5
//        cell.layer.masksToBounds = false
//        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        let todo = self.todoListViewModel.todos[indexPath.row]
        cell.detail.text = todo.detail
        cell.day.text = todo.date?.getDay()
        cell.date.text = todo.date?.getDate()
        cell.month.text = todo.date?.getMonthString()
        
        //cell.date.text = todo.date?.toString()
        return cell
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
            //[question: How to implement the code below?]
//            headerView.addTaskButton = UIButton(type: .system, primaryAction: UIAction(handler: { (_) in
//                self.showModal()
//                self.todoListViewModel.updateMode(.write)
//            }))
            return headerView
        default:
            assert(false, "dd")
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        todoListViewModel.todos[indexPath.row].isDone = !todoListViewModel.todos[indexPath.row].isDone
        todoListViewModel.saveToday()
        collectionView.reloadData()
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
extension TodoViewController {
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
    func setupAnimation(){
        animationView.frame = view.bounds
        animationView.backgroundColor = .clear
        animationView.animation = Animation.named("32585-fireworks-display")
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
        let context = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (action) -> UIMenu? in
            
            let edit = UIAction(title: "Edit", image: UIImage(systemName: "square.and.pencil"), identifier: nil, discoverabilityTitle: nil, state: .off) { (_) in
                print("edit button clicked")
                self.todoListViewModel.updateMode(.edit)
                self.showModal(index: index as NSNumber)

            }
            let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), identifier: nil, discoverabilityTitle: nil,attributes: .destructive, state: .off) { (_) in
                print("delete button clicked")
                //TodoManager.shared.deleteTodo(self.items?[index] ?? Todo() )
                self.todoListViewModel.deleteTodo(self.todoListViewModel.todos[index])
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(self.todoListViewModel.todos[index].detail ?? "")"])
                self.fetchTasks()
            }
            
            return UIMenu(title: "Options", image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: [edit,delete])
            
        }
        return context
    }
    
}
