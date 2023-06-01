//
//  ArchiveViewController.swift
//  EverydayTodo
//
//  Created by doyeon kim on 2023/05/29.
//

import UIKit

class ArchiveViewController: UIViewController {
    static let identifier = "ArchiveViewController"
    private let archiveViewModel = ArchiveViewModel()
    private let profileViewModel = ProfileViewModel()
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - ACTION
    
    @IBAction func closeBtnTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @objc func deleteArchive(_ sender: UIButton) {
        let index = sender.tag
        
        let deleteTodo = archiveViewModel.archiveTodos[index]
        archiveViewModel.deleteArchive(todo: deleteTodo)
  
        self.fetchTasks()
        
    }
    
    @objc func restoreTodo(_ sender: UIButton) {
        let index = sender.tag
        
        let restoreData = archiveViewModel.archiveTodos[index]
        
        
        if restoreData.isAlarmOn {
            scheduleLocalNotification(todo: restoreData)
        }
        
        archiveViewModel.restoreTodo(todo: restoreData)
        
        self.fetchTasks()
        
        if let vc = presentingViewController as? TodoViewController {
            vc.fetchTasks()
        }
        
    }
    
    func fetchTasks() {
        archiveViewModel.loadTasks()
        profileViewModel.fetchProfile()
        self.tableview.reloadData()
    }
    
    
    func scheduleLocalNotification(todo: Todo) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            
            if settings.authorizationStatus == UNAuthorizationStatus.authorized {
                DispatchQueue.main.async {
                    let content = UNMutableNotificationContent()
                    content.title = "Complete your todo"
                    content.body = todo.detail ?? ""
                    content.sound = UNNotificationSound.default
                    
                    let dateInfo = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: todo.date!)
                    
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)
                    
                    let request = UNNotificationRequest(identifier: todo.detail ?? "0", content: content, trigger: trigger)
                    
                    let notificationCenter = UNUserNotificationCenter.current()
                    notificationCenter.add(request) { error in
                        if error != nil {
                            print("error in notification")
                        }
                    }
                        
                    
                }
                
            } else {
                print("user denided")
            }
        }
    }
    
    
}


extension ArchiveViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return archiveViewModel.archiveTodos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArchiveTableViewCell.identifier, for: indexPath) as? ArchiveTableViewCell else { return UITableViewCell() }
        cell.trashButton.tag = indexPath.row
    
        cell.restoreButton.tag = indexPath.row
        cell.archiveData = archiveViewModel.archiveTodos[indexPath.row]
        
        cell.trashButton.addTarget(self, action: #selector(deleteArchive(_ :)), for: .touchUpInside)
     
        cell.restoreButton.addTarget(self, action: #selector(restoreTodo(_ :)), for: .touchUpInside)
        
        
        return cell
    }
    
    
    
    
}
