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
    
    //TODO: do it in extension
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        //formatter.dateStyle = .short
        //formatter.timeStyle = .short
        formatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
        formatter.locale = .current
        return formatter
    }() //do it in extention
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        print(modalTF.text ?? 0)
        let date = formatter.string(from: datePicker.date)
        print(formatter.string(from: datePicker.date))
        /*
         ISO 8601 YYYY-MM-DD'T'HH-mm-ss+Z
         Date:"12/12/2011"
         formatter.date(from: data)
         */
        // TODO: Create a person object
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
        
        // TODO: re-fetch the data
        if let vc = presentingViewController as? TodoViewController {
           // vc.fetchTasks()
            print("ye? ")
            vc.fetchTasks()
        }
        dismiss(animated: true, completion: nil)
    }
}
