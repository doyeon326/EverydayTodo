//
//  ViewController.swift
//  EverydayTodo
//
//  Created by Tony Jung on 2020/12/14.
//

import UIKit
import CoreData

class TodoViewController: UIViewController, UIGestureRecognizerDelegate {
    //[TODO] progressbar 계산
    // add UI개선
    // 프로파일과 이름 바꾸기!
    // 색 바꾸기 [customize color?]
    // 날짜 계산
    @IBOutlet weak var collectionView: UICollectionView!
    let todoListViewModel = TodoViewModel()
    let profileViewModel = ProfileViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
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
            cell.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1) //끝났을때
            cell.checkMark.isHidden = false
        }
        else{
            cell.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1) //안끝났을때
            cell.checkMark.isHidden = true
        }
        
        
            //[UIColor.red, UIColor.blue, UIColor.yellow, UIColor.white].randomElement()
        cell.layer.cornerRadius = 10.0
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
  
            //[TODO: 정리하기! ]
            let percentage = todoListViewModel.calculatePercentage()
            
            headerView.progressView.setProgress(Float(percentage) / 100, animated: true)

            headerView.profileImage.makeRounded() //profile radius
            let convertedImage = profileViewModel.profile.last?.profileImg
            headerView.profileImage.image = UIImage(data: convertedImage ?? Data())
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
            self.collectionView.reloadData()
    }
    
    //Long gesture recognizer
    private func setupLongGestureRecognizerOnCollection() {
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
                 lpgr.minimumPressDuration = 0.5
                 lpgr.delaysTouchesBegan = true
                 lpgr.delegate = self
                 self.collectionView.addGestureRecognizer(lpgr)
    }
    
    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        
        guard gestureReconizer.state != .began else { return }
        let point = gestureReconizer.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: point)
        if let index = indexPath{
            let cell = self.collectionView.cellForItem(at: index)
            cell?.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.15)
            print(index.row)
            }
        else{
            print("Could not find index path")
            }
    }
    
    @objc func changeProfile(){
        guard let vc = (self.storyboard?.instantiateViewController(identifier: "EditProfileViewController") as? EditProfileViewController) else { return }
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
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
                self.fetchTasks()
            }
            
            return UIMenu(title: "Options", image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: [edit,delete])
            
        }
        return context
    }
    
}
