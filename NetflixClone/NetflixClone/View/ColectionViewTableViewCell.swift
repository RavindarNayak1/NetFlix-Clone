//
//  ColectionViewTableViewCell.swift
//  NetflixClone
//
//  Created by Ravindar Nayak on 09/09/23.
//

import UIKit
protocol ColectionViewTableViewCellDelegate: AnyObject{
    func ColectionViewTableViewCellDidtapCell(_ cell: ColectionViewTableViewCell, viewModel: TitlesPreviewViewModel)
}

class ColectionViewTableViewCell: UITableViewCell {
    static let identifier = "ColectionViewTableViewCell"
    
    weak var delegate: ColectionViewTableViewCellDelegate?
    private var titles: [Movie] = [Movie]()
    
    private let collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
        
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemPink
        contentView.addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    public func configure(with titles: [Movie]) {
        self.titles = titles
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    func downloadTitleAt(indexPath: IndexPath){
        
        DataPersisstanceMannager.shared.downloadTitleWith(Model: titles[indexPath.row]){
            resuit in
            
            switch resuit{
                
            case .success():
                NotificationCenter.default.post(name: NSNotification.Name("Downloaded"), object: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
}
extension ColectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else{
            return UICollectionViewCell()
        }
        guard let model = titles[indexPath.row].poster_path else {
            return UICollectionViewCell()
        }
        cell.configure(with: model )
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.media_name else{
            return
        }
        APICaller.shared.getMovie(with: titleName + "trailer"){ [weak self] result in
            switch result{
               
                
            case .success(let videoElememt):
                
                guard let titleOverview = title.overview else{
                    return
                }
                let title = self?.titles[indexPath.row]
                let viewModel = TitlesPreviewViewModel(title: titleName , youtubeVideo: videoElememt, titleOverview: titleOverview)
                
                guard let stongfSelf = self else{ return}
                
                self?.delegate?.ColectionViewTableViewCellDidtapCell(stongfSelf, viewModel: viewModel)
                
            case .failure( let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
//        let config = UIContextMenuConfiguration(
//            identifier: nil,
//            previewProvider: nil) {[weak self ] _ in
//                let downloadAction = UIAction(title: "Download", subtitle: nil,image: nil, identifier: nil,
//                    discoverabilityTitle: nil, state: .off) { _ in
////                    print("downloded")
//                    self?.downloadTitleAt(indexPath: indexPath )
//                }
//                return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
//            }
//        return config
//    }
    
//    private func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
//        let config = UIContextMenuConfiguration(
//            identifier: nil,
//            previewProvider: nil) { [weak self] _ in
////
//                let downloadAction = UIAction(title: "Download",subtitle: nil,image: nil, state: .off) { _ in
//                print("Download tapped")
//                self?.downloadTitleAt(indexPath: indexPath)
//                }
//                return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
//            }
//        return config
//    }
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
    let config = UIContextMenuConfiguration(identifier: nil, previewProvider:nil) { [weak self] _ in

    // guard let self = self else { return}
    let downloadAction = UIAction(title: "Download",subtitle: nil,image: nil, state: .off) { _ in
    print("Download tapped")
    self?.downloadTitleAt(indexPath: indexPath)
    }
    return UIMenu(title: "", options: .displayInline,children: [downloadAction])
    }

    return config
    }

    
    
}
