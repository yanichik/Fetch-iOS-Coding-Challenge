//
//  MenuItemCell.swift
//  Fetch_Challenge_Desert-Recipes
//
//  Created by Yan Brunshteyn on 7/15/24.
//

import UIKit

class MenuItemCell: UITableViewCell {
    
    let menuImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let menuTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(menuImageView)
        addSubview(menuTitleLabel)
        
        NSLayoutConstraint.activate([
            menuImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            menuImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            menuImageView.widthAnchor.constraint(equalToConstant: 50),
            menuImageView.heightAnchor.constraint(equalToConstant: 50),
            
            menuTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            menuTitleLabel.leadingAnchor.constraint(equalTo: menuImageView.trailingAnchor, constant: 15),
            menuTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
        ])
    }
    
    func configure(with menuItem: MenuItem) async {
        Task {
            if let image = try await NetworkManager.shared.loadImage(from: menuItem.imageName) {
                DispatchQueue.main.async {
                    self.menuImageView.image = image
                }
            }
        }
        menuTitleLabel.text = menuItem.title
    }
}

