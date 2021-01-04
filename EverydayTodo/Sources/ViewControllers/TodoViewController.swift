//
//  ViewController.swift
//  EverydayTodo
//
//  Created by Tony Jung on 2020/12/14.
//

import UIKit
import CoreData

class TodoViewController: UIViewController, UIGestureRecognizerDelegate {
    //[TODO] keyboard 가리지않게 올라오는거조정!

    @IBOutlet weak var collectionView: UICollectionView!
    let todoListViewModel = TodoViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        //setupLongGestureRecognizerOnCollection()
        todoListViewModel.loadTasks()
        print("--> todolistViewmodel data: \(todoListViewModel.todos.count)")
    }
}

extension TodoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return todoListViewModel.todos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodoCell", for: indexPath) as? TodoCollectionViewCell else { return UICollectionViewCell() }
        
        if todoListViewModel.todos[indexPath.row].isDone == true {
            cell.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        }
        else{
            cell.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        }
        
        
            //[UIColor.red, UIColor.blue, UIColor.yellow, UIColor.white].randomElement()
        cell.layer.cornerRadius = 10.0
        let todo = self.todoListViewModel.todos[indexPath.row]
        cell.detail.text = todo.detail
        return cell
    }
    //Header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerView", for: indexPath) as? HeaderCollectionReusableView else { return UICollectionReusableView() }
  
            //[TODO: 정리하기! ]
            headerView.progressView.setProgress(1.0, animated: true)

            headerView.profileImage.makeRounded() //profile radius
            headerView.uiViewController = self //할수잇는방법2개 1. 현재의 정보를 보내기, 2. actionhandler구현해서 사용하기.
            headerView.addTaskButton.addTarget(self, action: #selector(showModal), for: .touchUpInside)
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
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
    
        if todoListViewModel.todos[indexPath.row].isDone == false {
            cell.contentView.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
            
        }
        else{
            cell.contentView.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        }
        todoListViewModel.todos[indexPath.row].isDone = !todoListViewModel.todos[indexPath.row].isDone
        todoListViewModel.saveToday()
        
        
        //[TODO]CoreData에다가 뭐가 저장이 되었고 안되었는지 저장해야함!
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
            //[TODO] 처음 눌렸을때만 색이면함
            //mode: editing 으로 바꾸기!
            //완료 될시, mode = default
            cell?.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.15)
            
            print(index.row)
            }
        else{
            print("Could not find index path")
            }
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
