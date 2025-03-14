//
//  HomeViewController.swift
//  Coptic Orphans
//
//  Created by Mina Emad on 14/03/2025.
//

import UIKit
import Combine

class HomeViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var btnLogoutOutlet: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var repositoryTableview: UITableView!
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    private var viewModel: HomeViewModelProtocol?
    
    //MARK: - INITIALIZER
    init(viewModel: HomeViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle-Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }


    private func setupViews() {
        self.navigationItem.hidesBackButton = true
        topView.layer.cornerRadius = 16
        btnLogoutOutlet.layer.cornerRadius = 8
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.layer.cornerRadius = 8
            textField.layer.masksToBounds = true
            textField.backgroundColor = .white // Ensure visibility of the rounded corners
        }

        // Remove the search bar's default background
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchBar.isTranslucent = true
    }
    
    
    
    // MARK: - Buttons
    @IBAction func btnLogout(_ sender: Any) {
        
    }
}
