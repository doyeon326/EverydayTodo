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
    
    func updateTodo(){
        
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
        
    }
}

class TodoViewModel{
    enum Mode: Int, CaseIterable {
        case edit
        case write
        
        var currentMode: String{
            switch self {
            case .edit: return "edit"
            case .write: return "write"
            }
        }
    }
    
    private let manager = TodoManager.shared
    
    var todos: [Todo] {
        return manager.todos
    }
    
    var completeTodos: [Todo] {
        return todos.filter { $0.isDone == true }
    }
    
    func addTodo(_ todo: Todo){
      //  manager.addTodo(detail: <#T##String#>, date: <#T##Date#>, id: <#T##Int#>, isDone: <#T##Bool#>)
    }
    func deleteTodo(_ todo: Todo){
        manager.deleteTodo(todo)
    }
    func updateTodo(_ todo: Todo){
        manager.updateTodo()
    }
    func loadTasks() {
        manager.retrieveTodo()
    }
 
}
