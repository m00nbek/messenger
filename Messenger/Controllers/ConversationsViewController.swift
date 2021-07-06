//
//  ViewController.swift
//  Messenger
//
//  Created by Oybek on 7/4/21.
//

import UIKit
import Firebase
class ConversationsViewController: UIViewController {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAuth()
    }
    
    // MARK: - Properties
    // MARK: - Selectors
    // MARK: - API
    // MARK: - Functions
    private func validateAuth() {
        if Auth.auth().currentUser == nil {
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false)
        }
    }
    
    
}

