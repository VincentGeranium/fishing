//
//  AddFeedViewController.swift
//  FishingPoint
//
//  Created by Fury on 24/05/2019.
//  Copyright © 2019 Fury. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices
import HPGradientLoading

extension UIScrollView {
    
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        setContentOffset(bottomOffset, animated: true)
    }
}

class AddFeedViewController: UIViewController {
    
    var isUp = false
    var db: Firestore!
    var oriImageData: Data!
    let feedDataManager = FeedDataManager.shard
    let imagePicker = UIImagePickerController()
    
    var autoHeight: NSLayoutConstraint!
    
    let scroll: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    let addFeedView: AddFeedView = {
        let addFiedView = AddFeedView()
        addFiedView.translatesAutoresizingMaskIntoConstraints = false
        return addFiedView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        addSubView()
        autoLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addFeedView.pointNameTextField.text = feedDataManager.pointName ?? nil
        feedDataManager.pointName = nil
    }
    
    // image resize func
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    // Feed Image와 내용들을 Firebase에 저장
    @objc private func saveFeedDidTap(_ sender: UIButton) {
        // 빈 칸이 있는지 조건을 통해서 확인
        if addFeedView.photoImageView.image == UIImage(named: "defaultphoto") {
            return
        } else if addFeedView.pointNameTextField.text == nil {
            return
        } else if addFeedView.rodNameTextField.text == nil {
            return
        } else if addFeedView.reelNameTextField.text == nil {
            return
        } else if addFeedView.lureNameTextField.text == nil {
            return
        } else {
            saveData()
        }
    }
    
    private func saveData() {
        HPGradientLoading.shared.showLoading(with: "저장중 ...")
        let date = Date()
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imageRef = storageRef.child("images/\(date)")
        //        feedDataManager.allImageData.insert(imageRef, at: 0)
        let uploadTask = imageRef.putData(oriImageData, metadata: nil) { (metadata, error) in
            
            self.db.collection("feeds").document("\(date)").setData([
                "ImageName" : "\(date)",
                "Point" : "\(self.addFeedView.pointNameTextField.text!)",
                "Rod" : "\(self.addFeedView.rodNameTextField.text!)",
                "Reel" : "\(self.addFeedView.reelNameTextField.text!)",
                "Lure" : "\(self.addFeedView.lureNameTextField.text!)",
                ])
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                HPGradientLoading.shared.dismiss()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    // Alert Action Sheet
    func alertConfigration() {
        let alert = UIAlertController(title: "선택", message: nil, preferredStyle: .actionSheet)
        let cameraOpenAction = UIAlertAction(title: "카메라", style: .default) { _ in
            self.cameraAction()
        }
        let openPhotoLibraryAction = UIAlertAction(title: "앨범", style: .default) { _ in
            self.openPhotoLibrary()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(cameraOpenAction)
        alert.addAction(openPhotoLibraryAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    //카메라 동작 함수
    func cameraAction() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    // 앨범 열기 함수
    func openPhotoLibrary() {
        imagePicker.sourceType = .savedPhotosAlbum
        present(imagePicker, animated: true)
    }
    
    private func configure() {
        HPGradientLoading.shared.configation.isEnableDismissWhenTap = true
        HPGradientLoading.shared.configation.isBlurBackground = true
        HPGradientLoading.shared.configation.durationAnimation = 1.0
        HPGradientLoading.shared.configation.fontTitleLoading = UIFont.systemFont(ofSize: 20)
        
        self.view.backgroundColor = .white
        self.title = "등록"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .done, target: self, action: #selector(saveFeedDidTap(_:)))
        
        // ImagePicker 델리게이트
        imagePicker.delegate = self
        
        // AlertSheet 델리게이트
        addFeedView.delegate = self
        
        // TextField 델리게이트
        addFeedView.pointNameTextField.delegate = self
        addFeedView.reelNameTextField.delegate = self
        addFeedView.rodNameTextField.delegate = self
        addFeedView.lureNameTextField.delegate = self
        
        // Firebase store Settings
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
    }
    
    private func addSubView() {
        view.addSubview(scroll)
        scroll.addSubview(addFeedView)
    }
    
    private func autoLayout() {
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: guide.topAnchor),
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            
            addFeedView.topAnchor.constraint(equalTo: scroll.topAnchor),
            addFeedView.bottomAnchor.constraint(equalTo: scroll.bottomAnchor),
            addFeedView.widthAnchor.constraint(equalTo: guide.widthAnchor),
            ])
        
        autoHeight = addFeedView.bottomAnchor.constraint(equalTo: scroll.bottomAnchor)
        autoHeight.isActive = true
    }
}

extension AddFeedViewController: AddFeedViewDelegate {
    func presentAddFishingPointVC() {
        let addFishingPointVC = AddFishingPointViewController()
        present(addFishingPointVC, animated: true)
    }
    
    func alertActionSheet(_ photoImage: UIImageView) {
        alertConfigration()
    }
}

extension AddFeedViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let mediaType = info[.mediaType] as! NSString
        
        if UTTypeEqual(mediaType, kUTTypeImage) {
            let originalImage = info[.originalImage] as! UIImage
            let editedImage = info[.editedImage] as? UIImage
            let selectedImage = editedImage ?? originalImage
            
            
            let imageData = resizeImage(image: selectedImage, targetSize: CGSize(width: view.frame.width, height: 300)).jpegData(compressionQuality: 0.8)
            oriImageData = imageData
            addFeedView.photoImageView.image = resizeImage(image: selectedImage, targetSize: CGSize(width: view.frame.width, height: 300))
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension AddFeedViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if isUp {
            
        } else {
            autoHeight.constant -= 200
            let bottomOffset = CGPoint(x: 0, y: scroll.contentSize.height - scroll.bounds.size.height + scroll.contentInset.bottom + 200)
            scroll.setContentOffset(bottomOffset, animated: true)
            isUp.toggle()
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if isUp {
            autoHeight.constant += 200
            textField.resignFirstResponder()
            isUp.toggle()
        }
        return true
    }
}
