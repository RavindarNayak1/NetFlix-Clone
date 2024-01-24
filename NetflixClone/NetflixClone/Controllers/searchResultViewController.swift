//
//  searchResultViewController.swift
//  NetflixClone
//
//  Created by Ravindar Nayak on 12/09/23.
//

import UIKit
protocol searchResultViewControllerDelegate : AnyObject{
    func searchResultViewControllerDidTapItem(_ viewModel: TitlesPreviewViewModel)
}

class searchResultViewController: UIViewController {
    
    var titles: [Movie] = [Movie]()
    public weak var delegate: searchResultViewControllerDelegate?
    
    public let searchResultsCollectonview: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width:100, height: 200)
        layout.minimumLineSpacing = 0
        
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(searchResultsCollectonview)
        
        searchResultsCollectonview.dataSource = self
        searchResultsCollectonview.delegate = self

        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultsCollectonview.frame = view.bounds
    }

    
    

}
extension searchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else{ return UICollectionViewCell()}
        
        let title = titles[indexPath.row]
        cell.configure(with: title.poster_path ?? "unkown")
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {indexPath
        collectionView.deselectItem(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        let titleName = title.original_title ?? ""
        APICaller.shared.getMovie(with: titleName){ [weak self] result in
            switch result{
            case .success(let videoElement):
                self?.delegate?.searchResultViewControllerDidTapItem(TitlesPreviewViewModel(title: title.original_title ?? "", youtubeVideo: videoElement , titleOverview: title.overview ?? ""))
                
            case .failure(let error):
                    print(error.localizedDescription)
                }
            
            }
       
        
       
    }
    
    
}
