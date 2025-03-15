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
    
    var repositories: [Repository] = []
    private var filteredRepositories: [Repository] = []
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
    }
    
    private func initViewController() {
        repositoryTableView.delegate = self
        repositoryTableView.dataSource = self
        repositoryTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        setupSearchBar()
        fetchRepositories(page: currentPage)
    }

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
    
    func fetchRepositories(page: Int) {
        guard !isFetching else { return }
        isFetching = true
        
        let url = "https://api.github.com/repositories?since=\(page * 30)"
        
        AF.request(url).responseDecodable(of: [Repository].self) { response in
            switch response.result {
            case .success(let repos):
                if self.currentPage == 1 {
                    self.repositories = repos
                } else {
                    self.repositories.append(contentsOf: repos)
                }
                self.repositoryTableView.reloadData()
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
            self.isFetching = false
        }
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
        filteredRepositories = repositories.filter { repo in
            return repo.name.lowercased().contains(text)
        }

        repositoryTableView.reloadData()
    }
    
    // MARK: - Buttons
    @IBAction func btnLogout(_ sender: Any) {
        viewModel?.input.logoutButtonTriggered.send()
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredRepositories.count : repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let repository = isSearching ? filteredRepositories[indexPath.row] : repositories[indexPath.row]
        cell.textLabel?.text = repository.name
        return cell
    }
   
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == repositories.count - 5 {
            currentPage += 1
            fetchRepositories(page: currentPage)
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


struct Repository: Decodable {
    let name: String
    let description: String?
    let html_url: String
}
/*
 func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
     if indexPath.row == repositories.count - 5 {
         currentPage += 1
         fetchRepositories(page: currentPage)
     }
 }
 */
