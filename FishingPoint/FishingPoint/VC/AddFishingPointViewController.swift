//
//  AddFishingPointViewController.swift
//  FishingPoint
//
//  Created by Fury on 24/05/2019.
//  Copyright © 2019 Fury. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

final class Annotation: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
}

class AddFishingPointViewController: UIViewController {
    
    // 현재 장소의 텍스트 데이터를 넘기기 위한 임시 저장 변수
    var tempStored = ""
    
    // CLLocationManager 인스턴스
    let locationManager = CLLocationManager()
    
    var feedManager = FeedDataManager.shard
    
    let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    let currentPositionLabel: UILabel = {
        let currentPositionLabel = UILabel()
        currentPositionLabel.translatesAutoresizingMaskIntoConstraints = false
        return currentPositionLabel
    }()
    
    let confirmButton: UIButton = {
        let confirmButton = UIButton(type: .system)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.setTitle("등록", for: .normal)
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        confirmButton.backgroundColor = .gray
        confirmButton.layer.cornerRadius = 15
        return confirmButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        addSubView()
        autoLayout()
        checkAutohorizationStatus()
    }
    
    private func configure() {
        view.backgroundColor = .white
        
        // CLLocationManager 델리게이트 설정
        locationManager.delegate = self
        
        confirmButton.addTarget(self, action: #selector(didTapConfirmButton(_:)), for: .touchUpInside)
    }
    
    private func addSubView() {
        view.addSubview(mapView)
        view.addSubview(currentPositionLabel)
        view.addSubview(confirmButton)
    }
    
    private func autoLayout() {
        let guide = view.safeAreaLayoutGuide
        let margin: CGFloat = 10
        
        NSLayoutConstraint.activate([
            confirmButton.topAnchor.constraint(equalTo: guide.topAnchor, constant: margin * 3),
            confirmButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -margin * 3),
            confirmButton.widthAnchor.constraint(equalToConstant: 50),
            confirmButton.heightAnchor.constraint(equalToConstant: 30),
            
            mapView.topAnchor.constraint(equalTo: confirmButton.bottomAnchor, constant: margin),
            mapView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: currentPositionLabel.topAnchor),
            
            currentPositionLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            currentPositionLabel.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            currentPositionLabel.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            currentPositionLabel.heightAnchor.constraint(equalToConstant: 50),
            ])
    }
    
    private func checkAutohorizationStatus() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedWhenInUse:
            fallthrough
        case .authorizedAlways:
            startUpdatingLocation()
        @unknown default: break
        }
    }
    
    func startUpdatingLocation() {
        let status = CLLocationManager.authorizationStatus()
        guard status == .authorizedAlways || status == .authorizedWhenInUse, CLLocationManager.locationServicesEnabled() else { return }
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 10.0
        locationManager.startUpdatingLocation()
    }
    
    // 등록 버튼 액션
    // dismiss
    @objc func didTapConfirmButton(_ sender: UIButton) {
        feedManager.pointName = tempStored
        dismiss(animated: true, completion: nil)
    }
}

extension AddFishingPointViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let current = locations.last!
        
        if (abs(current.timestamp.timeIntervalSinceNow) < 10) {
            let coordinate = current.coordinate
        }
        
        let coordinate = current.coordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.0005, longitudeDelta: 0.0005)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        addAnnotation(location: current)
        
        CLGeocoder().reverseGeocodeLocation(current, completionHandler: {
            (placemarks, error) -> Void in
            let pm = placemarks!.first
            let country = pm!.country
            var address: String = country!
            if pm!.locality != nil {
                address += " "
                address += pm!.locality!
            }
            if pm!.thoroughfare != nil {
                address += " "
                address += pm!.thoroughfare!
            }
            // 현재 위치 텍스트로 변환하여 레이블에 띄우기
            self.currentPositionLabel.text = address
            // 임시 저장 변수로 address 값을 옮김
            self.tempStored = address
        })
        locationManager.stopUpdatingLocation()
    }
    
    func addAnnotation(location: CLLocation) {
        let annotation = Annotation(title: "현재위치", coordinate: location.coordinate)
        mapView.addAnnotation(annotation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied { return }
    }
    
}
