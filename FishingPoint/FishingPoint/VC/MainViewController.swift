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
    
    var allFeedData: [FeedData] = []
    var allImageData: [StorageReference] = []
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
        getData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        allFeedData = feedDataManager.allFeedData
        allImageData = feedDataManager.allImageData
        mainFeedTable.reloadData()
    }
    
    private func getData() {
        // 화면 구성
        allFeedData = []
        allImageData = []
        
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
                    
                    self.allFeedData.append(feedData)
                    self.feedDataManager.allFeedData.append(feedData)
                    
                    // 이미지 다운로드
                    let imageNmae = document.get("ImageName") as! String
                    print("[Log] imageNmae :", imageNmae)
                    let storage = Storage.storage()
                    let storageRef = storage.reference()
                    let desertRef = storageRef.child("images/\(imageNmae)")
                    self.allImageData.append(desertRef)
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
        return feedDataManager.allFeedData.count
        //        return allFeedData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mainFeedTable.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as! MainTableViewCell
        cell.delegate = self
        cell.mainContentsView.delegate = self
        if allImageData.isEmpty {
            
        } else {
            print("[Order Log] tableView Cell Called")
            cell.imageCollection = allImageData[indexPath.row]
            cell.actionButton.tag = indexPath.row
            cell.mainContentsView.pointBtn.text = allFeedData[indexPath.row].pointName!
            cell.mainContentsView.rodName.text = allFeedData[indexPath.row].rodName!
            cell.mainContentsView.reelName.text = allFeedData[indexPath.row].reelName!
            cell.mainContentsView.lureName.text = allFeedData[indexPath.row].lureName!
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
        let modify = UIAlertAction(title: "수정", style: .default)
        
        let delete = UIAlertAction(title: "삭제", style: .destructive) { _ in
            self.db.collection("feeds").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    var i = 0
                    for document in querySnapshot!.documents {
                        if i == num {
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
                    self.mainFeedTable.reloadData()
                }
            }
        }
        // db 삭제 후 테이블 리로드
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
