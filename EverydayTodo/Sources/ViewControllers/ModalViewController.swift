//
//  ModalViewController.swift
//  EverydayTodo
//
//  Created by Tony Jung on 2020/12/19.
//

import UIKit

class ModalViewController: UIViewController {

    @IBOutlet weak var inputViewBottom: NSLayoutConstraint!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var modalTF: UITextField!
    @IBOutlet weak var alertButton: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    var modalViewModel = TodoViewModel()
    var profileViewModel = ProfileViewModel()
    var todos: Todo?


    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
        updateUI()
        view.layoutIfNeeded()
    }
    func updateUI(){
        profileViewModel.fetchColor()
        submitButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        if modalViewModel.fetchMode() == .edit {
            submitButton.setTitle("SAVE", for: .normal)
        }
        else {
            submitButton.setTitle("ADD", for: .normal)
        }
        submitButton.backgroundColor = profileViewModel.color.rgb
        modalTF?.text = todos?.detail
        datePicker.date = todos?.date ?? Date()
        alertButton.onTintColor = profileViewModel.color.rgb
        guard let statusOfAlarm = todos?.isAlarmOn else { return }
        alertButton.isOn = statusOfAlarm
     
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
            modalViewModel.addTodo(detail: modalTF.text!, date: datePicker.date, id: 1, isDone: false, isalarmOn: alertButton.isOn)
    
        case .edit:
            todos?.detail = modalTF.text
            todos?.date = datePicker.date
            todos?.id = 1
            todos?.isDone = false
            todos?.isAlarmOn = alertButton.isOn
            modalViewModel.updateTodo(todos ?? Todo())
        }
        if alertButton.isOn {
            scheduleLocalNotification()
        }
        else{
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(modalTF.text ?? "")"])
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
    func scheduleLocalNotification(){
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus == UNAuthorizationStatus.authorized{
                
                DispatchQueue.main.async {
                    let content = UNMutableNotificationContent()
                    content.title = "Complete your todo"
                    guard let text = self.modalTF.text else { return }
                    content.body = text
                    content.sound = UNNotificationSound.default
            
                    //content.userInfo = [ modalTF.text : "any information"]

                    let dateInfo = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: self.datePicker.date)
                    
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)
                    
                    //create the request
                   // let uuidString = UUID().uuidString
                    //알림 요청이 여러개 일때, 알림들을 구분할수 있게 해주는 식별자.
                    let request = UNNotificationRequest(identifier: self.modalTF.text ?? "0", content: content, trigger: trigger)
                    
                    // Schedule the request with the system
                    let notificationCenter = UNUserNotificationCenter.current()
                    notificationCenter.add(request) { (error) in
                        if error != nil{
                            print("error in notification! ")
                        }
                    }
                }
            }
            else{
                print("user denied")
            }
        }

    }
}


