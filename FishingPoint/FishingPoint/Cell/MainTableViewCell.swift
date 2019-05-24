//
//  MainTableViewCell.swift
//  FishingPoint
//
//  Created by Fury on 24/05/2019.
//  Copyright © 2019 Fury. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

protocol MainTableViewCellDelegate: class {
    func alertActionSheet(_ num: Int) -> Void
}

class MainTableViewCell: UITableViewCell {
    
    static let identifier = "MainTableViewCell"
    
    var imageCollection: StorageReference!
    
    let feedDataManager = FeedDataManager.shard
    
    weak var delegate: MainTableViewCellDelegate?
    
    let actionButton: UIButton = {
        let actionButton = UIButton()
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.setImage(UIImage(named: "more"), for: .normal)
        return actionButton
    }()
    
    let collectionImage: UIImageView = {
        let collectionImage = UIImageView()
        collectionImage.translatesAutoresizingMaskIntoConstraints = false
        return collectionImage
    }()
    
    let mainContentsView: MainContentsView = {
        let mainContentsView = MainContentsView()
        mainContentsView.translatesAutoresizingMaskIntoConstraints = false
        return mainContentsView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
        addContentView()
        autoLayout()
    }
    
    @objc private func moreButtonDidTap(_ sender: UIButton) {
        delegate?.alertActionSheet(sender.tag)
    }
    
    private func configure() {
        actionButton.addTarget(self, action: #selector(moreButtonDidTap(_:)), for: .touchUpInside)
    }
    
    private func addContentView() {
        contentView.addSubview(actionButton)
        contentView.addSubview(collectionImage)
        contentView.addSubview(mainContentsView)
    }
    
    private func autoLayout() {
        let margin: CGFloat = 10
        NSLayoutConstraint.activate([
            actionButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin),
            actionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin),
            actionButton.widthAnchor.constraint(equalToConstant: 20),
            actionButton.heightAnchor.constraint(equalToConstant: 20),
            
            collectionImage.topAnchor.constraint(equalTo: actionButton.bottomAnchor),
            collectionImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionImage.heightAnchor.constraint(equalToConstant: 300),
            
            mainContentsView.topAnchor.constraint(equalTo: collectionImage.bottomAnchor),
            mainContentsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin * 2),
            mainContentsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin * 2),
            mainContentsView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
