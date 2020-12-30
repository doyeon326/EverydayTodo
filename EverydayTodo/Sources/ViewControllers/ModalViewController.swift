//
//  ModalViewController.swift
//  EverydayTodo
//
//  Created by Tony Jung on 2020/12/19.
//

import UIKit
import CoreData

class ModalViewController: UIViewController {
//TODO: 궁금증, 왜 IBAction은 extension 엔 불가?
    
    @IBOutlet weak var modalTF: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    //TODO: make it in somewhere else to share!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        print(modalTF.text ?? 0)
        let date = datePicker.date.toString()
        print("0000000\(date)")

        /*
         ISO 8601 YYYY-MM-DD'T'HH-mm-ss+Z
         Date:"12/12/2011"
         formatter.date(from: data)
         */
        
        // TODO: Create a Todo object
        let newTodo = Todo(context: self.context)
        newTodo.detail = modalTF.text
        newTodo.date = date
        newTodo.isDone = false
        newTodo.id = 1
        // TODO: Save the data
        do{
            try self.context.save()
        }
        catch{
            
        }
        
        if let vc = presentingViewController as? TodoViewController {
            vc.fetchTasks()
        }
        dismiss(animated: true, completion: nil)
    }
}
