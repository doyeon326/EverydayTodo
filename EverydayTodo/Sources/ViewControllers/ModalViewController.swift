//
//  ModalViewController.swift
//  EverydayTodo
//
//  Created by Tony Jung on 2020/12/19.
//

import UIKit

class ModalViewController: UIViewController {
    
    @IBOutlet weak var inputViewBottom: NSLayoutConstraint!
    @IBOutlet weak var modalTF: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    var modalViewModel = TodoViewModel()
    var todos: Todo?


    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        updateUI()
    }
    func updateUI(){
        modalTF?.text = todos?.detail 
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

        if let vc = presentingViewController as? TodoViewController {
            vc.fetchTasks()
            vc.todoListViewModel.updateMode(.write)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapBG(_ sender: Any) {
        modalTF.resignFirstResponder()
    }
    
    @objc private func adjustInputView(noti: Notification) {
        guard let userInfo = noti.userInfo else { return }
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        if noti.name == UIResponder.keyboardWillShowNotification {
            let adjustmentHeight = keyboardFrame.height - view.safeAreaInsets.bottom
            inputViewBottom.constant = adjustmentHeight
        }
        else {
            inputViewBottom.constant = 0
        }
        //print("\(keyboardFrame)")
    }
}


