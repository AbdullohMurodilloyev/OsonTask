//
//  TodosViewController.swift
//  OsonTask
//
//  Created by Abdulloh Murodilloyev on 26/02/25.
//

import UIKit

class TodosViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: TodosViewModel
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    
    // MARK: - Initializer
    init(viewModel: TodosViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchTodos()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white
        
        setupSearchBar()
        setupTableView()
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search todos..."
        navigationItem.titleView = searchBar
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TodoCell")
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Data Fetching
    private func fetchTodos() {
        viewModel.fetchData { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension TodosViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredTodos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        let todo = viewModel.filteredTodos[indexPath.row]
        let userName = viewModel.users.first { $0.id == todo.userId }?.name ?? "Unknown"
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = "id\(todo.id)\n\(todo.title)\nBy: \(userName)"
        cell.textLabel?.textColor = .black
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard searchBar.text?.isEmpty == true else { return }
        if indexPath.row == viewModel.filteredTodos.count - 1 {
            viewModel.loadMore { [weak self] in
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todo = viewModel.filteredTodos[indexPath.row]
        let user = viewModel.users.first { $0.id == todo.userId }
        let detailsVC = TodoDetailsViewController(todo: todo, user: user)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension TodosViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.search(query: searchText)
        tableView.reloadData()
    }
}
