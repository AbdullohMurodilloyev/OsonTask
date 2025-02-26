//
//  TodosViewModel.swift
//  OsonTask
//
//  Created by Abdulloh Murodilloyev on 26/02/25.
//

import UIKit
import Alamofire

class TodosViewModel {
    var todos: [TodosModel] = []
    var users: [UserModel] = []
    var filteredTodos: [TodosModel] = []
    
    let pageSize = 20

    func fetchData(completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        NetworkService.request(endpoint: "todos", method: .get) { (result: Result<[TodosModel], CustomError>) in
            switch result {
            case .success(let todos):
                self.todos = todos
                print("TODOS == ",todos)
            case .failure:
                print(" TODOS ERRORR")
            }
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        NetworkService.request(endpoint: "users", method: .get) { (result: Result<[UserModel], CustomError>) in
            switch result {
            case .success(let users):
                self.users = users
                print("USERS == ",users)
            case .failure:
                print(" USERS ERRORR")
            }
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) {
            self.filteredTodos = Array(self.todos.prefix(self.pageSize))
            completion()
        }
    }
}
