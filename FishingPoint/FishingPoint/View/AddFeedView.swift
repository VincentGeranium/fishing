//
//  AddFeedView.swift
//  FishingPoint
//
//  Created by Fury on 24/05/2019.
//  Copyright © 2019 Fury. All rights reserved.
//

import UIKit

protocol AddFeedViewDelegate: class {
    func alertActionSheet(_ photoImage: UIImageView) -> Void
    func presentAddFishingPointVC() -> Void
}

class AddFeedView: UIView {
    
    weak var delegate: AddFeedViewDelegate!
    
    let photoImageView: UIImageView = {
        let photoImageView = UIImageView()
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.backgroundColor = .red
        photoImageView.image = UIImage(named: "defaultphoto")
        return photoImageView
    }()
    
    let containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    let pointNameLabel: UILabel = {
        let pointNameLabel = UILabel()
        pointNameLabel.translatesAutoresizingMaskIntoConstraints = false
        pointNameLabel.text = "장소"
        pointNameLabel.font = UIFont.systemFont(ofSize: 20)
        pointNameLabel.textColor = .black
        return pointNameLabel
    }()
    
    let pointNameTextField: UITextField = {
        let pointNameTextField = UITextField()
        pointNameTextField.translatesAutoresizingMaskIntoConstraints = false
        pointNameTextField.borderStyle = .roundedRect
        pointNameTextField.placeholder = "장소를 선택하세요"
        pointNameTextField.textAlignment = .center
        pointNameTextField.allowsEditingTextAttributes = false
        return pointNameTextField
    }()
    
    let reelNameLabel: UILabel = {
        let reelNameLabel = UILabel()
        reelNameLabel.translatesAutoresizingMaskIntoConstraints = false
        reelNameLabel.text = "릴"
        reelNameLabel.font = UIFont.systemFont(ofSize: 20)
        reelNameLabel.textColor = .black
        return reelNameLabel
    }()
    
    let reelNameTextField: UITextField = {
        let reelNameTextField = UITextField()
        reelNameTextField.translatesAutoresizingMaskIntoConstraints = false
        reelNameTextField.borderStyle = .roundedRect
        reelNameTextField.placeholder = "릴 이름을 입력하세요"
        reelNameTextField.textAlignment = .center
        return reelNameTextField
    }()
    
    let rodNameLabel: UILabel = {
        let rodNameLabel = UILabel()
        rodNameLabel.translatesAutoresizingMaskIntoConstraints = false
        rodNameLabel.text = "로드"
        rodNameLabel.font = UIFont.systemFont(ofSize: 20)
        rodNameLabel.textColor = .black
        return rodNameLabel
    }()
    
    let rodNameTextField: UITextField = {
        let rodNameTextField = UITextField()
        rodNameTextField.translatesAutoresizingMaskIntoConstraints = false
        rodNameTextField.borderStyle = .roundedRect
        rodNameTextField.placeholder = "로드 이름을 입력하세요"
        rodNameTextField.textAlignment = .center
        return rodNameTextField
    }()
    
    let lureNameLabel: UILabel = {
        let lureNameLabel = UILabel()
        lureNameLabel.translatesAutoresizingMaskIntoConstraints = false
        lureNameLabel.text = "루어"
        lureNameLabel.font = UIFont.systemFont(ofSize: 20)
        lureNameLabel.textColor = .black
        return lureNameLabel
    }()
    
    let lureNameTextField: UITextField = {
        let lureNameTextField = UITextField()
        lureNameTextField.translatesAutoresizingMaskIntoConstraints = false
        lureNameTextField.borderStyle = .roundedRect
        lureNameTextField.placeholder = "루어 이름을 입력하세요"
        lureNameTextField.textAlignment = .center
        return lureNameTextField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        configure()
        addContentView()
        autoLayout()
    }
    
    @objc private func photoIVDidTap(_ image: UIImageView) {
        delegate.alertActionSheet(image)
    }
    
    @objc private func pointTextFieldDidTap(_ text: UITextField) {
        delegate.presentAddFishingPointVC()
    }
    
    private func configure() {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(photoIVDidTap(_:)))
        photoImageView.isUserInteractionEnabled = true
        photoImageView.addGestureRecognizer(singleTap)
        
        let singleTap2 = UITapGestureRecognizer(target: self, action: #selector(pointTextFieldDidTap(_:)))
        pointNameTextField.isUserInteractionEnabled = true
        pointNameTextField.addGestureRecognizer(singleTap2)
    }
    
    private func addContentView() {
        self.addSubview(photoImageView)
        self.addSubview(containerView)
        containerView.addSubview(pointNameLabel)
        containerView.addSubview(pointNameTextField)
        containerView.addSubview(reelNameLabel)
        containerView.addSubview(reelNameTextField)
        containerView.addSubview(rodNameLabel)
        containerView.addSubview(rodNameTextField)
        containerView.addSubview(lureNameLabel)
        containerView.addSubview(lureNameTextField)
    }
    
    private func autoLayout() {
        let margin: CGFloat = 10
        let height: CGFloat = 50
        
        NSLayoutConstraint.activate([
            // 이미지
            photoImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: margin * 5),
            photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: margin * 2),
            photoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            containerView.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: margin * 2),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: margin * 2),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            containerView.heightAnchor.constraint(equalTo: photoImageView.heightAnchor),
            
            // 장소
            pointNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: margin),
            pointNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            pointNameLabel.heightAnchor.constraint(equalToConstant: height),
            
            pointNameTextField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: margin),
            pointNameTextField.leadingAnchor.constraint(equalTo: pointNameLabel.trailingAnchor),
            pointNameTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            pointNameTextField.centerYAnchor.constraint(equalTo: pointNameLabel.centerYAnchor),
            pointNameTextField.widthAnchor.constraint(equalTo: pointNameLabel.widthAnchor, multiplier: 6),
            pointNameTextField.heightAnchor.constraint(equalTo: pointNameLabel.heightAnchor),
            
            
            // 릴
            reelNameLabel.topAnchor.constraint(equalTo: pointNameLabel.bottomAnchor, constant: margin),
            reelNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            reelNameLabel.heightAnchor.constraint(equalTo: pointNameLabel.heightAnchor),
            
            reelNameTextField.topAnchor.constraint(equalTo: pointNameLabel.bottomAnchor, constant: margin),
            reelNameTextField.leadingAnchor.constraint(equalTo: reelNameLabel.trailingAnchor),
            reelNameTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            reelNameTextField.centerYAnchor.constraint(equalTo: reelNameLabel.centerYAnchor),
            reelNameTextField.widthAnchor.constraint(equalTo: reelNameLabel.widthAnchor, multiplier: 6),
            reelNameTextField.heightAnchor.constraint(equalTo: reelNameLabel.heightAnchor),
            
            // 로드
            rodNameLabel.topAnchor.constraint(equalTo: reelNameLabel.bottomAnchor, constant: margin),
            rodNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            rodNameLabel.heightAnchor.constraint(equalTo: reelNameLabel.heightAnchor),
            
            rodNameTextField.topAnchor.constraint(equalTo: reelNameLabel.bottomAnchor, constant: margin),
            rodNameTextField.leadingAnchor.constraint(equalTo: rodNameLabel.trailingAnchor),
            rodNameTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            rodNameTextField.centerYAnchor.constraint(equalTo: rodNameLabel.centerYAnchor),
            rodNameTextField.widthAnchor.constraint(equalTo: rodNameLabel.widthAnchor, multiplier: 6),
            rodNameTextField.heightAnchor.constraint(equalTo: rodNameLabel.heightAnchor),
            
            // 루어
            lureNameLabel.topAnchor.constraint(equalTo: rodNameLabel.bottomAnchor, constant: margin),
            lureNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            lureNameLabel.heightAnchor.constraint(equalTo: rodNameLabel.heightAnchor),
            
            lureNameTextField.topAnchor.constraint(equalTo: rodNameLabel.bottomAnchor),
            lureNameTextField.leadingAnchor.constraint(equalTo: lureNameLabel.trailingAnchor, constant: margin),
            lureNameTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            lureNameTextField.centerYAnchor.constraint(equalTo: lureNameLabel.centerYAnchor),
            lureNameTextField.widthAnchor.constraint(equalTo: lureNameLabel.widthAnchor,
                                                     multiplier: 6),
            lureNameTextField.heightAnchor.constraint(equalTo: lureNameLabel.heightAnchor),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
