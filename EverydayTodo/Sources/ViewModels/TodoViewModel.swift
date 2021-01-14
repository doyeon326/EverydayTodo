//
//  TodoViewModel.swift
//  EverydayTodo
//
//  Created by Tony Jung on 2021/01/07.
//

import Foundation

class TodoViewModel{
    enum CurrentMode: Int, CaseIterable {
        case edit
        case write
        
        var title: String{
            switch self {
            case .edit: return "edit"
            case .write: return "write"
            }
        }
    }
    private (set) var mode: CurrentMode = .write
    private let manager = TodoManager.shared
    
    var todos: [Todo] {
        return manager.todos
    }
    
    var completeTodos: [Todo] {
        return todos.filter { $0.isDone == true }
    }
    
    func addTodo(detail: String, date: Date, id: Int, isDone: Bool, isalarmOn: Bool){
        manager.addTodo(detail: detail, date: date, id: id, isDone: isDone, isAlarmOn: isalarmOn)
    }
    func deleteTodo(_ todo: Todo){
        manager.deleteTodo(todo)
    }
    func updateTodo(_ todo: Todo){
        manager.updateTodo(todo)
    }
    func loadTasks() {
        manager.retrieveTodo()
    }
    func updateMode(_ mode: CurrentMode){
        self.mode = mode
    }
    func fetchMode() -> CurrentMode {
        return mode
    }
    func saveToday(){
        manager.saveTodo()
    }
    func calculatePercentage() -> Int {
        let completed = todos.filter { $0.isDone == true }
        if (completed.count > 0){
            return completed.count * 100 / todos.count
        }
        else { return 0 }
       
    }
 
}
