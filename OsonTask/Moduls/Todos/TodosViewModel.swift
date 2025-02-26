//
//  TodosViewModel.swift
//  OsonTask
//
//  Created by Abdulloh Murodilloyev on 26/02/25.
//

import UIKit
import Alamofire

class TodosViewModel {
    private(set) var todos: [TodosModel] = []
    private(set) var users: [UserModel] = []
    private(set) var filteredTodos: [TodosModel] = []
    
    private let pageSize = 20
    
    func fetchData(completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        fetchTodos { dispatchGroup.leave() }
        
        dispatchGroup.enter()
        fetchUsers { dispatchGroup.leave() }
        
        dispatchGroup.notify(queue: .main) {
            self.filteredTodos = Array(self.todos.prefix(self.pageSize))
            completion()
        }
    }
    
    private func fetchTodos(completion: @escaping () -> Void) {
        NetworkService.request(endpoint: "todos", method: .get) { (result: Result<[TodosModel], CustomError>) in
            switch result {
            case .success(let todos):
                self.todos = todos
                DataBaseHelper.shared.saveTodosToCoreData(todos: todos)
            case .failure(let error) where error == .noInternetConnection:
                self.todos = DataBaseHelper.shared.fetchTodosFromCoreData().getOrDefault([])
                print("❗ Internet yo‘q, cache’dan yuklandi:", self.todos)
            default: break
            }
            completion()
        }
    }
    
    private func fetchUsers(completion: @escaping () -> Void) {
        NetworkService.request(endpoint: "users", method: .get) { (result: Result<[UserModel], CustomError>) in
            switch result {
            case .success(let users):
                self.users = users
                DataBaseHelper.shared.saveUsersToCoreData(users: users)
            case .failure(let error) where error == .noInternetConnection:
                self.users = DataBaseHelper.shared.fetchUsersFromCoreData().getOrDefault([])
                print("❗ Internet yo‘q, cache’dan yuklandi:", self.users)
            default: break
            }
            completion()
        }
    }
    
    func loadMore(completion: @escaping () -> Void) {
        let startIndex = filteredTodos.count
        let endIndex = min(startIndex + pageSize, todos.count)
        
        guard startIndex < endIndex else { return }
        
        filteredTodos.append(contentsOf: todos[startIndex..<endIndex])
        completion()
    }
    
    func search(query: String) {
        filteredTodos = query.isEmpty ?
            Array(todos.prefix(pageSize)) :
            todos.filter { todo in
                let userName = users.first(where: { $0.id == todo.userId })?.name ?? ""
                return todo.title.lowercased().contains(query.lowercased()) ||
                       userName.lowercased().contains(query.lowercased())
            }
    }
}

// 🔹 Qo'shimcha helper funksiyasi
extension Result {
    func getOrDefault(_ defaultValue: Success) -> Success {
        switch self {
        case .success(let value): return value
        case .failure: return defaultValue
        }
    }
}
