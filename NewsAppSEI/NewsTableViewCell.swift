//
//  NewsTableViewCell.swift
//  NewsAppSEI
//
//  Created by David Walitza on 26.06.2021.
//

import UIKit

class NewsTableViewCellModel{
    let title: String
    let subtitle: String
    let imageURL: URL?
    var imageData: Data? = nil
    
    init( title: String,
     subtitle: String,
     imageURL: URL?
     ) {
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
    }
}

class NewsTableViewCell: UITableViewCell {

    static let identifier = "NewsTableViewCell"
    
    let storyTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 24, weight: .medium)
        return label
    }()
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .light)
        return label
    }()
    
    let newsImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.backgroundColor = .gray
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(storyTitle)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(newsImage)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        storyTitle.frame = CGRect(x: 10, y: 0, width: contentView.frame.size.width - 180, height: 70)
        subtitleLabel.frame = CGRect(x: 10, y: 70, width: contentView.frame.size.width - 180, height: contentView.frame.size.height/2)
        newsImage.frame = CGRect(x: contentView.frame.size.width - 160, y: 5, width: 150 , height: contentView.frame.size.height - 10)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        storyTitle.text = nil
        newsImage.image = nil
        subtitleLabel.text = nil
    }
    
    func configure(with viewModel: NewsTableViewCellModel){
        storyTitle.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        
        if let data = viewModel.imageData{
            newsImage.image = UIImage(data: data)
        } else if let url = viewModel.imageURL {
            URLSession.shared.dataTask(with: url){ data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self.newsImage.image = UIImage(data: data)
                }
            }.resume()
            
        }
    }
    
}
