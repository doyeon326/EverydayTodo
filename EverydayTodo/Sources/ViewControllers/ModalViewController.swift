//
//  ModalViewController.swift
//  EverydayTodo
//
//  Created by Tony Jung on 2020/12/19.
//

import UIKit

class ModalViewController: UIViewController {
    
    @IBOutlet weak var modalTF: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    var modalViewModel = TodoViewModel()
    var todos: Todo?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    func updateUI(){
        modalTF.text = todos?.detail
    }
}
//MARK: ACTIONS
extension ModalViewController{
    @IBAction func closeButtonTapped(_ sender: Any) {
        //[TODO: is there any nice way to put it? ]
        modalViewModel.updateMode(.write)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        switch modalViewModel.fetchMode() {
        case .write:
            modalViewModel.addTodo(detail: modalTF.text!, date: datePicker.date, id: 1, isDone: false)
    
        case .edit:
            todos?.detail = modalTF.text
            todos?.date = datePicker.date
            todos?.id = 1
            todos?.isDone = false
            modalViewModel.updateTodo(todos ?? Todo())
        }
        
//        print(modalTF.text ?? 0)
//        let date = datePicker.date.toString()
//        print("0000000\(date)")

        if let vc = presentingViewController as? TodoViewController {
            vc.fetchTasks()
            vc.todoListViewModel.updateMode(.write)
        }
        dismiss(animated: true, completion: nil)
    }

}
