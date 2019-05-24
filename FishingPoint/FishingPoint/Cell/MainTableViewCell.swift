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
    
    weak var delegate: MainTableViewCellDelegate?
    
    let actionButton: UIButton = {
        let actionButton = UIButton()
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.setImage(UIImage(named: "more"), for: .normal)
        return actionButton
    }()
    
    let collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .white
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.identifier)
        return collection
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
        collection.dataSource = self
        collection.delegate = self
        collection.isPagingEnabled = true
        collection.showsHorizontalScrollIndicator = false
        actionButton.addTarget(self, action: #selector(moreButtonDidTap(_:)), for: .touchUpInside)
    }
    
    private func addContentView() {
        contentView.addSubview(actionButton)
        contentView.addSubview(collection)
        contentView.addSubview(mainContentsView)
    }
    
    private func autoLayout() {
        let margin: CGFloat = 10
        NSLayoutConstraint.activate([
            actionButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin),
            actionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin),
            actionButton.widthAnchor.constraint(equalToConstant: 20),
            actionButton.heightAnchor.constraint(equalToConstant: 20),
            
            collection.topAnchor.constraint(equalTo: actionButton.bottomAnchor),
            collection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collection.heightAnchor.constraint(equalToConstant: 300),
            
            mainContentsView.topAnchor.constraint(equalTo: collection.bottomAnchor),
            mainContentsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin * 2),
            mainContentsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin * 2),
            mainContentsView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin),
            ])
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MainTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collection = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.identifier, for: indexPath) as! MainCollectionViewCell
        print("[Order Log] collectionView Item Called")
        if imageCollection == nil {
            print("[Log] Collection Image - nil")
        } else {
            collection.collectionImage.sd_setImage(with: imageCollection!)
            print("[Log] Collection Image - \(imageCollection!)")
        }
        
        
        return collection
    }
}

extension MainTableViewCell: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: contentView.frame.width, height: collectionView.frame.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        
        return 0
    }
    
    //셀 사이의 간격
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        
        return 0
    }
}
