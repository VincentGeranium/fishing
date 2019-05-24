//
//  ViewController.swift
//  FishingPoint
//
//  Created by Fury on 24/05/2019.
//  Copyright © 2019 Fury. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class MainViewController: UIViewController {
    
    private var db: Firestore!
    
    var feedDataManager = FeedDataManager.shard
    
    private let mainFeedTable: UITableView = {
        let mainFeedTable = UITableView()
        mainFeedTable.translatesAutoresizingMaskIntoConstraints = false
        mainFeedTable.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.identifier)
        return mainFeedTable
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarSetting()
        configure()
        addSubView()
        autoLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
    }
    
    private func getData() {
        // 화면 구성
        feedDataManager.allFeedData = []
        feedDataManager.allImageData = []
        
        db.collection("feeds").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in (querySnapshot!.documents).reversed() {
                    // 데이터 다운로드
                    let feedData = FeedData(
                        feedImage: document.get("ImageName") as! String,
                        pointName: document.get("Point") as! String,
                        rodName: document.get("Rod") as! String,
                        reelName: document.get("Reel") as! String,
                        lureName: document.get("Lure") as! String
                    )
                    self.feedDataManager.allFeedData.append(feedData)
                    
                    // 이미지 다운로드
                    let imageNmae = document.get("ImageName") as! String
                    print("[Log] imageNmae :", imageNmae)
                    let storage = Storage.storage()
                    let storageRef = storage.reference()
                    let desertRef = storageRef.child("images/\(imageNmae)")
                    self.feedDataManager.allImageData.append(desertRef)
                }
            }
            self.mainFeedTable.reloadData()
        }
    }
    
    @objc private func plusButtonDidTap(_ sender: UIButton) {
        let addFeedVC = AddFeedViewController()
        self.navigationController?.pushViewController(addFeedVC, animated: true)
    }
    
    private func tabBarSetting() {
        let naviTitleView = UIImageView(image: UIImage(named: AppImageData.logo))
        naviTitleView.contentMode = .scaleAspectFit
        navigationController?.navigationBar.backgroundColor = UIColor(red: 0.36, green: 0.57, blue: 0.78, alpha: 1)
        self.navigationItem.titleView = naviTitleView
        
        self.navigationItem.setRightBarButton(UIBarButtonItem(image: UIImage(named: AppImageData.plus), style: .plain, target: self, action: #selector(plusButtonDidTap(_:))), animated: true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = .black
    }
    
    private func configure() {
        mainFeedTable.dataSource = self
        
        // Firebase store Settings
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
    }
    
    private func addSubView() {
        view.addSubview(mainFeedTable)
    }
    
    private func autoLayout() {
        let guide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            mainFeedTable.topAnchor.constraint(equalTo: guide.topAnchor),
            mainFeedTable.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            mainFeedTable.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            mainFeedTable.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            ])
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("[Log] FeedData Count : \(feedDataManager.allFeedData.count)")
        print("[Log] ImageData Count : \(feedDataManager.allImageData.count)")
        return feedDataManager.allFeedData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mainFeedTable.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as! MainTableViewCell
        cell.delegate = self
        cell.mainContentsView.delegate = self
        if feedDataManager.allImageData.isEmpty {
            
        } else {
            print("[Log] Table IndexPath - \(indexPath.row)")
            
            cell.collectionImage.sd_setImage(with: feedDataManager.allImageData[indexPath.row])
            cell.actionButton.tag = indexPath.row
            cell.mainContentsView.pointBtn.text = feedDataManager.allFeedData[indexPath.row].pointName!
            cell.mainContentsView.rodName.text = feedDataManager.allFeedData[indexPath.row].rodName!
            cell.mainContentsView.reelName.text = feedDataManager.allFeedData[indexPath.row].reelName!
            cell.mainContentsView.lureName.text = feedDataManager.allFeedData[indexPath.row].lureName!
        }
        return cell
    }
}

extension MainViewController: MainTableViewCellDelegate {
    func alertActionSheet(_ num: Int) {
        var removeImageName = ""
        print("alertActionSheet - num : ", num)
        let action = UIAlertController(title: "선택", message: nil, preferredStyle: .actionSheet)
        // 등록페이지로 가고, 등록페이지에 이미지, text들을 다 채워놓고, 네비게이션 타이틀을 수정으로 변경
        let modify = UIAlertAction(title: "수정", style: .default) { _ in
            self.db.collection("feeds").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    let count = querySnapshot!.documents.count - 1
                    
                    let point = querySnapshot?.documents[count - num].get("Point") as! String
                    let rod = querySnapshot?.documents[count - num].get("Rod") as! String
                    let reel = querySnapshot?.documents[count - num].get("Reel") as! String
                    let lure = querySnapshot?.documents[count - num].get("Lure") as! String
                    
                    let addFeedVC = AddFeedViewController()
                    addFeedVC.addFeedView.pointNameTextField.text = point
                    addFeedVC.addFeedView.rodNameTextField.text = rod
                    addFeedVC.addFeedView.reelNameTextField.text = reel
                    addFeedVC.addFeedView.lureNameTextField.text = lure
                    
                    self.navigationController?.pushViewController(addFeedVC, animated: true)
                }
            }
        }
        
        let delete = UIAlertAction(title: "삭제", style: .destructive) { _ in
            self.db.collection("feeds").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    var i = 0
                    for document in (querySnapshot!.documents).reversed() {
                        if num == i {
                            removeImageName = document.get("ImageName") as! String
                            self.db.collection("feeds").document("\(document.reference.documentID)").delete()
                            
                            // 이미지 삭제
                            let storage = Storage.storage()
                            let storageRef = storage.reference()
                            let desertRef = storageRef.child("images/\(removeImageName)")
                            
                            // Delete the file
                            desertRef.delete { error in
                                if let _ = error {
                                    // Uh-oh, an error occurred!
                                } else {
                                    // File deleted successfully
                                }
                            }
                            break
                        }
                        i += 1
                    }
                    self.getData()
                }
            }
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        action.addAction(delete)
        action.addAction(modify)
        action.addAction(cancel)
        
        present(action, animated: true)
    }
}

extension MainViewController: MainContentsViewDelegate {
    func presentMapView(_ pointName: String) {
        let fishingPointVC = FishingPointViewController()
        fishingPointVC.originAddress = pointName
        navigationController?.pushViewController(fishingPointVC, animated: true)
    }
}
