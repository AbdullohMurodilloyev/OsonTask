//
//  TodoDetailsViewController.swift
//  OsonTask
//
//  Created by Abdulloh Murodilloyev on 26/02/25.
//

import UIKit

class TodoDetailsViewController: UIViewController {
    private let todo: TodosModel
    private let user: UserModel?
    
    private let detailsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init(todo: TodosModel, user: UserModel?) {
        self.todo = todo
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "Details"
        
        view.addSubview(detailsLabel)
        
        NSLayoutConstraint.activate([
            detailsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            detailsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            detailsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        detailsLabel.text = """
        📝 Todo:
        - Title: \(todo.title)
        - Completed: \(todo.completed ? "✅ Yes" : "❌ No")
        - ID: \(todo.id)
        
        👤 User:
        - Name: \(user?.name ?? "Unknown")
        - Email: \(user?.email ?? "N/A")
        - Phone: \(user?.phone ?? "N/A")
        - City: \(user?.address.city ?? "N/A")
        - Street: \(user?.address.street ?? "N/A")
        """
    }
}
