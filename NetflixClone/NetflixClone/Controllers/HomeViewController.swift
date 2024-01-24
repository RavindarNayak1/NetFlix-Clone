//
//  HomeViewController.swift
//  NetflixClone
//
//  Created by Ravindar Nayak on 08/09/23.
//

import UIKit

enum sections: Int{
    case TrendingMovies = 0
    case TrendingTvs = 1
    case UpComingMovies = 2
    case PopularMovies = 3
    case TopratedMovies = 4
}

class HomeViewController: UIViewController, UITableViewDelegate {
    private var RandomTrendingMovie: Movie?
    private var headerView: HeroHeaderUIView?
    
    let sectionTitles: [String] = ["Trending Movies","Popular", "Trending Tv", "Upcoming Movies","Top Rated"]
    
    private let homeFeedTable:UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(ColectionViewTableViewCell.self, forCellReuseIdentifier: ColectionViewTableViewCell.identifier)
        return table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemIndigo
        view.addSubview(homeFeedTable)
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        configureNavbar()
        
        //        getTrendingMovies()
        //        getUpComingMovies()
        //        getTrendingTvs()
        //        getTopratedMovies()
        //        getPopularMovies()
        
        
        configureHeroHeaderView()
        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeFeedTable.tableHeaderView = headerView
        
        
        // Do any additional setup after loading the view.
    }
    
    
    private func configureHeroHeaderView(){
        APICaller.shared.getTopratedMovie { [weak self] result in
            switch result{
                
            case .success(let titles):
                let selectedTitles = titles.randomElement()
                self?.RandomTrendingMovie = selectedTitles
                self?.headerView?.configure(with: TitlesViewModel(titleName: selectedTitles?.original_title ?? "", posterURL: selectedTitles?.poster_path ?? ""))
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
            
    }
    
    
    private func configureNavbar() { // read this carefully
        var image = UIImage(named: "appstore" )
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        
        let targetSize = CGSize(width: 60, height: 60)

        let widthScaleRatio = targetSize.width / image!.size.width
        let heightScaleRatio = targetSize.height / image!.size.height

        let scaleFactor = min(widthScaleRatio, heightScaleRatio)

        let scaledImageSize = CGSize(
        width: image!.size.width * scaleFactor,
        height: image!.size.height * scaleFactor
        )

        let renderer = UIGraphicsImageRenderer(size: scaledImageSize)
        var scaledImage = renderer.image { _ in
        image!.draw(in: CGRect(origin: .zero, size: scaledImageSize))
        }
            scaledImage = scaledImage.withRenderingMode(.alwaysOriginal)
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: scaledImage, style: .done, target: self, action: nil)

        //        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
//        navigationController?.navigationBar.tintColor = .white
        
        
        
    }


    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
}

//private func getTrendingMovies(){
//    APICaller.shared.getTrendingMovie{ data in
//        print(data)
//    }
//    APICaller.shared.getTrendingMovie { result in
//        print(result)
//        switch result {
//        case.success(let title):
//            print(title)
//        case .failure(let error):
//            print(error)
//        }
//    }
//
//}

//private func getUpComingMovies(){
//        APICaller.shared.getUpComingMovies { result in
//            print(result)
//            switch result {
//            case.success(let title):
//                print(title)
//            case .failure(let error):
//                print(error)
//            }
//        }
//
//    }




// private func getTrendingTvs(){
//         APICaller.shared.getTrendingTv { result in
//             print(result)
//             switch result {
//             case.success(let title):
//                 print(title)
//             case .failure(let error):
//                 print(error)
//             }
//         }
//
//     }


//private func getTopratedMovies(){
//        APICaller.shared.getTopratedMovie { result in
//            print(result)
//            switch result {
//            case.success(let title):
//                print(title)
//            case .failure(let error):
//                print(error)
//            }
//        }
//
//    }


//private func getPopularMovies(){
//    APICaller.shared.getPopularMovie { result in
//        print(result)
//        switch result {
//        case.success(let title):
//            print(title)
//        case .failure(let error):
//            print(error)
//        }
//    }
//
//}



extension HomeViewController:  UITabBarDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ColectionViewTableViewCell.identifier, for: indexPath) as? ColectionViewTableViewCell else{
            return UITableViewCell()
        }
        cell.delegate = self
        switch indexPath.section{
        case sections.TrendingMovies.rawValue:
            APICaller.shared.getTrendingMovie { result in
                   print(result)
                   switch result {
                   case.success(let titles):
                       cell.configure(with : titles )
                   case .failure(let error):
                       print(error.localizedDescription)
                   }
               }
            
        case sections.TrendingTvs.rawValue:
            APICaller.shared.getTrendingTv { result in
                   print(result)
                   switch result {
                   case.success(let titles):
                       cell.configure(with : titles )
                   case .failure(let error):
                       print(error.localizedDescription)
                   }
               }

        case sections.UpComingMovies.rawValue:
            APICaller.shared.getUpComingMovies { result in
                   print(result)
                   switch result {
                   case.success(let titles):
                       cell.configure(with : titles )
                   case .failure(let error):
                       print(error.localizedDescription)
                   }
               }

        case sections.PopularMovies.rawValue:
            APICaller.shared.getPopularMovie { result in
                   print(result)
                   switch result {
                   case.success(let titles):
                       cell.configure(with : titles )
                   case .failure(let error):
                       print(error.localizedDescription)
                   }
               }

        case sections.TopratedMovies.rawValue:
            
            APICaller.shared.getTopratedMovie { result in
                   print(result)
                   switch result {
                   case.success(let titles):
                       cell.configure(with : titles )
                   case .failure(let error):
                       print(error.localizedDescription)
                   }
               }

        default:
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else{ return }
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.lowercased()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultSet = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultSet
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    
}
extension HomeViewController: ColectionViewTableViewCellDelegate {
    func ColectionViewTableViewCellDidtapCell(_ cell: ColectionViewTableViewCell, viewModel: TitlesPreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc  = TitlesPreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}
