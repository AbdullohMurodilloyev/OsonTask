//
//  TodosViewController.swift
//  OsonTask
//
//  Created by Abdulloh Murodilloyev on 26/02/25.
//

import UIKit

class TodosViewController: UIViewController {
    
    private var viewModel: TodosViewModel
    
    
    init(viewModel: TodosViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchData {
            print("ISHLADI")
        }
        
    }
    

    
}
