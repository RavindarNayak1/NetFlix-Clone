//
//  DownloadsViewController.swift
//  NetflixClone
//
//  Created by Ravindar Nayak on 08/09/23.
//

import UIKit

class DownloadsViewController: UIViewController {
    
    private var titles: [TitlesItem] = [TitlesItem]()
    
    private let downloadTable: UITableView = {
        let table = UITableView()
        table.register(TitlesTableViewCell.self, forCellReuseIdentifier: TitlesTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        downloadTable.delegate = self
        downloadTable.dataSource = self
        fetchLocalStorageForDownload()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("Downloaded"), object: nil, queue: nil ){
             _ in
            self.fetchLocalStorageForDownload()
        }
        view.addSubview(downloadTable)
        
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadTable.frame = view.bounds
    }
    
    
    private func fetchLocalStorageForDownload(){
        DataPersisstanceMannager.shared.fetchingDataFromDtataBase { [weak self] result in
            switch result{
                
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.downloadTable.reloadData()
                }
                
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitlesTableViewCell.identifier, for: indexPath) as? TitlesTableViewCell else {
            return UITableViewCell() }
        let title = titles [indexPath.row]
        cell.configure(with: TitlesViewModel(titleName: (title.original_title ?? title.original_name) ?? "Unknown title name", posterURL: title.poster_path ?? ""))
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
//            tableView.deleteRows(at: [indexPath], with: .fade)
            DataPersisstanceMannager.shared.deleteTitleWith(model: titles[indexPath.row]){ [weak self] result in
                switch result{
                case .success():
                    print("Deleted from the Database")
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self?.titles.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            }
        default:
            break;
        }
        
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
