//
//  SearchViewController.swift
//  NetflixClone
//
//  Created by Ravindar Nayak on 08/09/23.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var titles: [Movie] = [Movie]()
    
    private let discoverTable: UITableView = {
        let table = UITableView()
        table.register(TitlesTableViewCell.self, forCellReuseIdentifier: TitlesTableViewCell.identifier)
        return table
    }()
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: searchResultViewController())
        controller.searchBar.placeholder = "content thorough"
        controller.searchBar.searchBarStyle = .minimal
        return controller
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.backgroundColor = .systemBackground
        
        view.addSubview(discoverTable)
        discoverTable.delegate = self
        discoverTable.dataSource = self
        fetchDiscoverMovies()
        
        searchController.searchResultsUpdater = self
        
        navigationItem.searchController = searchController
        
        // Do any additional setup after loading the view.
    }
    
    
    private func fetchDiscoverMovies(){
        APICaller.shared.getDiscoverMovies { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.discoverTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
    }
    
    
    
}
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell  = tableView.dequeueReusableCell(withIdentifier: TitlesTableViewCell.identifier, for: indexPath) as? TitlesTableViewCell else{
            return UITableViewCell()
        }
        let title = titles[indexPath.row]
        let model = TitlesViewModel(titleName: (title.original_title ?? title.original_name) ?? "Unkown", posterURL: title.poster_path ?? "unkown")
        cell.configure(with: model)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name else {return}
        APICaller.shared.getMovie(with: titleName){ [weak self] result in
            switch result{
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = TitlesPreviewViewController()
                    vc.configure(with: TitlesPreviewViewModel(title: titleName, youtubeVideo: videoElement, titleOverview: title.overview ?? ""))
                    self?.navigationController?.pushViewController(vc, animated: true)
                    
                    
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
}
extension SearchViewController: UISearchResultsUpdating, searchResultViewControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        let searBar = searchController.searchBar
        
        guard let query = searBar.text,
              !query.trimmingCharacters(in: .whitespaces) .isEmpty,
              query.trimmingCharacters(in: .whitespaces) .count >= 1,
              let resultsController = searchController.searchResultsController as? searchResultViewController else{
            return }
        resultsController.delegate = self
        APICaller.shared.search(with: query){ result  in
            DispatchQueue.main.async {
                switch result{
                case .success(let titles):
                    resultsController.titles = titles
                    resultsController.searchResultsCollectonview.reloadData()
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        }
        }
    
    func searchResultViewControllerDidTapItem(_ viewModel: TitlesPreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlesPreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
