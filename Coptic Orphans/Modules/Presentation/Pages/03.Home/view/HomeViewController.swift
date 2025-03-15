//
//  HomeViewController.swift
//  Coptic Orphans
//
//  Created by Mina Emad on 14/03/2025.
//

import UIKit
import Combine
import Alamofire

class HomeViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var btnLogoutOutlet: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var repositoryTableView: UITableView!
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    private var viewModel: HomeViewModelProtocol?
    
    var repositories: [GitRepositoryDomain] = []
    private var filteredRepositories: [GitRepositoryDomain] = []
    private var isSearching = false
    var currentPage = 1
    var isFetching = false
    
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
        initViewController()
        setupViews()
        bindHomeViewModel()
    }
    
    // MARK: - Functions
    private func setupViews() {
        self.navigationItem.hidesBackButton = true
        topView.layer.cornerRadius = 16
        btnLogoutOutlet.layer.cornerRadius = 8
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.layer.cornerRadius = 8
            textField.layer.masksToBounds = true
            textField.backgroundColor = .white
        }

        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchBar.isTranslucent = true
    }
    
    private func initViewController() {
        initTableView()
        setupSearchBar()
        getAllPublicRepositories()
    }
    
    
    private func getAllPublicRepositories(){
        guard !isFetching else { return }
        isFetching = true
        viewModel?.getAllPublicRepositories(page: currentPage)
    }
   

    // MARK: - Setup-SearchBar
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.searchTextField.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
    }
        
    @objc private func searchTextChanged() {
        guard let text = searchBar.text?.lowercased(), !text.isEmpty else {
            isSearching = false
            repositoryTableView.reloadData()
            return
        }

        isSearching = true
        
        filteredRepositories = self.repositories.filter { repo in
            return repo.name?.lowercased().contains(text) ?? false
        }

        repositoryTableView.reloadData()
    }
    
    // MARK: - Buttons
    @IBAction func btnLogout(_ sender: Any) {
        viewModel?.input.logoutButtonTriggered.send()
    }
}


// MARK: - Setup-TableView
extension HomeViewController: UITableViewDataSource, UITableViewDelegate{
    
    private func initTableView() {
        repositoryTableView.delegate = self
        repositoryTableView.dataSource = self
        repositoryTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredRepositories.count : repositories.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let repository = isSearching ? filteredRepositories[indexPath.row] : repositories[indexPath.row]
        cell.textLabel?.text = repository.name
        cell.selectionStyle = .none
        
        return cell
    }
   
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            if indexPath.row == repositories.count - 5 {
                currentPage += 1
                viewModel?.getAllPublicRepositories(page: currentPage)
            }
        }

}


// MARK: - UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        isSearching = false
        repositoryTableView.reloadData()
        searchBar.resignFirstResponder()
    }
}


//MARK: - BINDING-VIEW-MODEL
private extension HomeViewController {
    func bindHomeViewModel() {
        bindReloadView()
    }
     
    func bindReloadView() {
        viewModel?.output.reloadView
            .receive(on: DispatchQueue.main)
            .sink{[weak self] repos in
                guard let self else { return }
                if self.currentPage == 1 {
                    self.repositories = repos
                } else {
                    self.repositories.append(contentsOf: repos)
                }
                self.repositoryTableView.reloadData()
                self.isFetching = false
            }
            .store(in: &cancellables)
    }
    
}
