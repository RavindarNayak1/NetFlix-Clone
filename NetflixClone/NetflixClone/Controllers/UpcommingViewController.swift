//
//  UpcommingViewController.swift
//  NetflixClone
//
//  Created by Ravindar Nayak on 08/09/23.
//

import UIKit

class UpcommingViewController: UIViewController {
    
    
    private var titles: [Movie] = [Movie]()
    
    private let upComingTable: UITableView = {
        let table = UITableView()
        table.register(TitlesTableViewCell.self, forCellReuseIdentifier: TitlesTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(upComingTable)
        upComingTable.delegate = self
        upComingTable.dataSource = self
        fetchUpcomming()
        
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upComingTable.frame = view.bounds
    }
    
    private func fetchUpcomming(){
        APICaller.shared.getUpComingMovies { [weak self] result in
            switch result{
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.upComingTable.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                
                
            }
        }
        
        
    }
}
extension UpcommingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitlesTableViewCell.identifier, for: indexPath) as? TitlesTableViewCell else{
            return UITableViewCell()
        }
        let title = titles[indexPath.row]
        cell.configure(with: TitlesViewModel(titleName: (title.original_title ?? title.original_name) ?? "Unkown", posterURL: title.poster_path ?? "unkown"))
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
