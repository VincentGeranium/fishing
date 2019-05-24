//
//  MainContentsView.swift
//  FishingPoint
//
//  Created by Fury on 24/05/2019.
//  Copyright © 2019 Fury. All rights reserved.
//

import UIKit

protocol MainContentsViewDelegate: class {
    func presentMapView(_ pointName: String) -> Void
}

class MainContentsView: UIView {
    
    weak var delegate: MainContentsViewDelegate?
    
    let pointName: UILabel = {
        let pointName = UILabel()
        pointName.translatesAutoresizingMaskIntoConstraints = false
        pointName.text = "장소"
        pointName.font = UIFont.systemFont(ofSize: 20)
        pointName.textColor = .black
        
        return pointName
    }()
    
    let pointBtn: UILabel = {
        let pointBtn = UILabel()
        pointBtn.translatesAutoresizingMaskIntoConstraints = false
        pointBtn.font = UIFont.systemFont(ofSize: 20)
        pointBtn.textColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        pointBtn.numberOfLines = 0
        return pointBtn
    }()
    
    let reelLabel: UILabel = {
        let reelName = UILabel()
        reelName.translatesAutoresizingMaskIntoConstraints = false
        reelName.text = "릴"
        reelName.font = UIFont.systemFont(ofSize: 20)
        reelName.textColor = .black
        return reelName
    }()
    
    let reelName: UILabel = {
        let reelName = UILabel()
        reelName.translatesAutoresizingMaskIntoConstraints = false
        reelName.font = UIFont.systemFont(ofSize: 20)
        reelName.textColor = .black
        reelName.numberOfLines = 0
        return reelName
    }()
    
    let rodLabel: UILabel = {
        let rodName = UILabel()
        rodName.translatesAutoresizingMaskIntoConstraints = false
        rodName.text = "로드"
        rodName.font = UIFont.systemFont(ofSize: 20)
        rodName.textColor = .black
        return rodName
    }()
    
    let rodName: UILabel = {
        let rodName = UILabel()
        rodName.translatesAutoresizingMaskIntoConstraints = false
        rodName.font = UIFont.systemFont(ofSize: 20)
        rodName.textColor = .black
        return rodName
    }()
    
    let lureLabel: UILabel = {
        let lureName = UILabel()
        lureName.translatesAutoresizingMaskIntoConstraints = false
        lureName.text = "루어"
        lureName.font = UIFont.systemFont(ofSize: 20)
        lureName.textColor = .black
        return lureName
    }()
    
    let lureName: UILabel = {
        let lureName = UILabel()
        lureName.translatesAutoresizingMaskIntoConstraints = false
        lureName.font = UIFont.systemFont(ofSize: 20)
        lureName.textColor = .black
        return lureName
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        addSubContentView()
        autoLayout()
    }
    
    private func configure() {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(pointBtnDidTap(_:)))
        pointBtn.isUserInteractionEnabled = true
        pointBtn.addGestureRecognizer(singleTap)
    }
    
    @objc func pointBtnDidTap(_ sender: UILabel) {
        delegate?.presentMapView(pointBtn.text!)
    }
    
    private func addSubContentView() {
        self.addSubview(pointName)
        self.addSubview(pointBtn)
        self.addSubview(rodLabel)
        self.addSubview(rodName)
        self.addSubview(reelLabel)
        self.addSubview(reelName)
        self.addSubview(lureLabel)
        self.addSubview(lureName)
    }
    
    private func autoLayout() {
        let margin: CGFloat = 10
        NSLayoutConstraint.activate([
            
            // 포인트
            pointName.topAnchor.constraint(equalTo: self.topAnchor, constant: margin),
            pointName.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            
            pointBtn.topAnchor.constraint(equalTo: self.topAnchor, constant: margin),
            pointBtn.leadingAnchor.constraint(equalTo: pointName.trailingAnchor),
            pointBtn.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            pointBtn.widthAnchor.constraint(equalTo: pointName.widthAnchor, multiplier: 3),
            pointBtn.centerYAnchor.constraint(equalTo: pointName.centerYAnchor),
            
            // 로드
            rodLabel.topAnchor.constraint(equalTo: pointName.bottomAnchor, constant: margin),
            rodLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            
            rodName.topAnchor.constraint(equalTo: pointBtn.bottomAnchor, constant: margin),
            rodName.leadingAnchor.constraint(equalTo: rodLabel.trailingAnchor),
            rodName.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            rodName.widthAnchor.constraint(equalTo: rodLabel.widthAnchor, multiplier: 3),
            rodName.centerYAnchor.constraint(equalTo: rodLabel.centerYAnchor),
            
            
            // 릴
            reelLabel.topAnchor.constraint(equalTo: rodLabel.bottomAnchor, constant: margin),
            reelLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            
            reelName.topAnchor.constraint(equalTo: rodName.bottomAnchor, constant: margin),
            reelName.leadingAnchor.constraint(equalTo: reelLabel.trailingAnchor),
            reelName.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            reelName.widthAnchor.constraint(equalTo: reelLabel.widthAnchor, multiplier: 3),
            reelName.centerYAnchor.constraint(equalTo: reelLabel.centerYAnchor),
            
            
            // 루어
            lureLabel.topAnchor.constraint(equalTo: reelLabel.bottomAnchor, constant: margin),
            lureLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            lureLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            lureName.topAnchor.constraint(equalTo: reelName.bottomAnchor, constant: margin),
            lureName.leadingAnchor.constraint(equalTo: lureLabel.trailingAnchor),
            lureName.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            lureName.widthAnchor.constraint(equalTo: lureLabel.widthAnchor, multiplier: 3),
            lureName.centerYAnchor.constraint(equalTo: lureLabel.centerYAnchor),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
