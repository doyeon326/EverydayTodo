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

    func addTodo(detail: String, date: Date, id: Int, isDone: Bool, isAlarmOn: Bool, isArchive: Bool){
        let newTodo = Todo(context: self.context)
        newTodo.detail = detail
        newTodo.date = date
        newTodo.isDone = isDone
        newTodo.id = Int64(id)
        newTodo.isAlarmOn = isAlarmOn
        newTodo.isArchive = isArchive
        saveTodo()
    }
    
    func deleteTodo(_ todo: Todo){
        self.context.delete(todo)
        saveTodo()
    }
    
    func updateTodo(_ todo: Todo){
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

