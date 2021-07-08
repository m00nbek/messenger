//
//  NewConversationViewController.swift
//  Messenger
//
//  Created by Oybek on 7/4/21.
//

import UIKit
import JGProgressHUD

class NewConversationViewController: UIViewController {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        searchBar.delegate = self
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.setRightBarButton(UIBarButtonItem(title: "Cancel",
                                                        style: .done,
                                                        target: self,
                                                        action: #selector(dismissSelf)), animated: true)
        searchBar.becomeFirstResponder()
    }
    // MARK: - Properties
    private let spinner = JGProgressHUD(style: .dark)
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search for users..."
        return searchBar
    }()
    private let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    private let noResultsLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "No Users found"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()
    // MARK: - Selectors
    @objc private func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
    // MARK: - API
    // MARK: - Functions
}

// MARK: - UISearchBarDelegate
extension NewConversationViewController: UISearchBarDelegate {
    
}
