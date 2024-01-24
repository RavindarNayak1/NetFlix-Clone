//
//  TitlesTableViewCell.swift
//  NetflixClone
//
//  Created by Ravindar Nayak on 12/09/23.
//

import UIKit

class TitlesTableViewCell: UITableViewCell {
    
    static let identifier = "TitlesTableViewCell"
    
    private let playTitleButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40))
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        return button
    }()
    
    private let titlesPosterUIImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titlesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titlesPosterUIImageView)
        contentView.addSubview(titlesLabel)
        contentView.addSubview(playTitleButton)
        applkyConstraints()
    }
    
    private func applkyConstraints(){
        let titlesPosterUIImageViewConstraints = [
            titlesPosterUIImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titlesPosterUIImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titlesPosterUIImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            titlesPosterUIImageView.widthAnchor.constraint(equalToConstant: 100 )
        ]
        let titlesLabelConstraints = [
            titlesLabel.leadingAnchor.constraint(equalTo: titlesPosterUIImageView.trailingAnchor, constant: 20),
            titlesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -70),
            titlesLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        let playTitleButtonConstreaints = [
            playTitleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:  -20),
            playTitleButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        NSLayoutConstraint.activate(titlesPosterUIImageViewConstraints)
        NSLayoutConstraint.activate(titlesLabelConstraints)
        NSLayoutConstraint.activate(playTitleButtonConstreaints)
    }
    public func configure(with model: TitlesViewModel ){
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else {
            return
        }
        titlesPosterUIImageView.sd_setImage(with: url , completed: nil )
        titlesLabel.text = model.titleName
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}
