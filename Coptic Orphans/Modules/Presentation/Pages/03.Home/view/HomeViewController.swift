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
    @IBOutlet weak var repositoryTableview: UITableView!
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    private var viewModel: HomeViewModelProtocol?
    
    var repositories: [Repository] = []
    var currentPage = 1
    var isFetching = false
    var searchQuery = ""
    
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
        repositoryTableview.delegate = self
        repositoryTableview.dataSource = self
        searchBar.delegate = self
        fetchRepositories(page: currentPage)
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
    
    func fetchRepositories(page: Int) {
        guard !isFetching else { return }
        isFetching = true
        
        var url = "https://api.github.com/repositories?since=\(page * 30)"
        if !searchQuery.isEmpty {
            url = "https://api.github.com/search/repositories?q=\(searchQuery)&page=\(page)"
        }
        
        AF.request(url).responseDecodable(of: [Repository].self) { response in
            switch response.result {
            case .success(let repos):
                if self.currentPage == 1 {
                    self.repositories = repos
                } else {
                    self.repositories.append(contentsOf: repos)
                }
                self.repositoryTableview.reloadData()
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
            self.isFetching = false
        }
    }
    
    
    
    // MARK: - Buttons
    @IBAction func btnLogout(_ sender: Any) {
        viewModel?.input.logoutButtonTriggered.send()
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepoCell", for: indexPath)
        let repo = repositories[indexPath.row]
        cell.textLabel?.text = repo.name
        cell.detailTextLabel?.text = repo.description ?? "No description"
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == repositories.count - 5 {
            currentPage += 1
            fetchRepositories(page: currentPage)
        }
    }
    
    
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.text, !query.isEmpty {
            searchQuery = query
            currentPage = 1
            repositories.removeAll()
            fetchRepositories(page: currentPage)
        }
        searchBar.resignFirstResponder()
    }
}

struct Repository: Decodable {
    let name: String
    let description: String?
    let html_url: String
}
