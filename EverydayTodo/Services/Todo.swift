//
//  Todo.swift
//  EverydayTodo
//
//  Created by Tony Jung on 2020/12/29.
//

import UIKit
import CoreData

class TodoManager {
    static let shared = TodoManager()
    var todos: [Todo] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    func addTodo(detail: String, date: Date, id: Int, isDone: Bool){
        let newTodo = Todo(context: self.context)
        
        newTodo.detail = detail
        newTodo.date = date
        newTodo.isDone = isDone
        newTodo.id = Int64(id)
        saveTodo()
    }
    
    func deleteTodo(_ todo: Todo){
        self.context.delete(todo)
        saveTodo()
    }
    
    func updateTodo(_ todo: Todo){
        //todos = todo
        //print("update todo! \(todo.detail)")
        saveTodo()
    }
    
    func saveTodo(){
        do{
            try self.context.save()
            print("[Saved] successfully saved data!")
        }
        catch{
            print(error.localizedDescription)
        }
    }
    func retrieveTodo(){
        do{
            self.todos = try context.fetch(Todo.fetchRequest())
        }
        catch{
            print(error.localizedDescription)
        }
    }
}

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
    
    func addTodo(detail: String, date: Date, id: Int, isDone: Bool){
        manager.addTodo(detail: detail, date: date, id: id, isDone: isDone)
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
 
}
