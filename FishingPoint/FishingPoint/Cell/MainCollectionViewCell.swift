//
//  MainCollectionViewCell.swift
//  FishingPoint
//
//  Created by Fury on 24/05/2019.
//  Copyright © 2019 Fury. All rights reserved.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MainCollectionViewCell"
    
    let collectionImage: UIImageView = {
        let collectionImage = UIImageView()
        collectionImage.translatesAutoresizingMaskIntoConstraints = false
        return collectionImage
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionImage.contentMode = .scaleAspectFit
        addContentView()
        autoLayout()
    }
    
    private func addContentView() {
        contentView.addSubview(collectionImage)
    }
    
    private func autoLayout() {
        NSLayoutConstraint.activate([
            collectionImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

