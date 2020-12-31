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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
//        print(modalTF.text ?? 0)
//        let date = datePicker.date.toString()
//        print("0000000\(date)")

        TodoManager.shared.addTodo(detail: modalTF.text!, date: datePicker.date, id: 1, isDone: false)
        
        if let vc = presentingViewController as? TodoViewController {
            vc.fetchTasks()
        }
        dismiss(animated: true, completion: nil)
    }
}
