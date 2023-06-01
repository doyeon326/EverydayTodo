//
//  ArchiveViewModel.swift
//  EverydayTodo
//
//  Created by doyeon kim on 2023/05/29.
//

import Foundation

class ArchiveViewModel {
    private let manager = TodoManager.shared
    
    var archiveTodos: [Todo] {
        return manager.todos.filter{ $0.isArchive == true }
    }
    
    func deleteArchive(todo: Todo) {
        manager.deleteTodo(todo)
    }
    
    func restoreTodo(todo: Todo) {
        todo.isArchive = false
        manager.updateTodo(todo)
        
    }
    
    func loadTasks() {
        manager.retrieveTodo()
    
    }
    //deleteTodo
    //restoreTodo
    
}
