//
//  TodoDetailsViewController.swift
//  OsonTask
//
//  Created by Abdulloh Murodilloyev on 26/02/25.
//

import UIKit

class TodoDetailsViewController: UIViewController {
    let todo: TodosModel
    let user: UserModel?

    init(todo: TodosModel, user: UserModel?) {
        self.todo = todo
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        print(todo)
        print(user)
        title = "Details"
        let label = UILabel()
        label.text = "Todo: \(todo.title)\nUser: \(user?.name ?? "Unknown")"
        label.numberOfLines = 0
        view.addSubview(label)
        label.frame = view.bounds
    }
}
