//
//  FishingPointViewController.swift
//  FishingPoint
//
//  Created by Fury on 24/05/2019.
//  Copyright © 2019 Fury. All rights reserved.
//

import UIKit
import MapKit

class FishingPointViewController: UIViewController {
    
    var originAddress: String = ""
    
    private let myMap: MKMapView = {
        let myMap = MKMapView()
        myMap.translatesAutoresizingMaskIntoConstraints = false
        return myMap
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        addSubView()
        autoLayout()
        searchMap(originAddress)
    }
    
    private func goToAnnotation(_ originAddress: String, _ geoAddress: CLPlacemark) {
        // span, region 설정
        let span = MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
        let region = MKCoordinateRegion(center: geoAddress.location!.coordinate, span: span)
        
        // 위도, 경도 값 저장
        let latitude = geoAddress.location!.coordinate.latitude
        let longitude = geoAddress.location!.coordinate.longitude
        
        // addAnnotaition의 위치 정보 입력
        let destination = MKPointAnnotation()
        destination.title = "My Point"
        destination.subtitle = originAddress
        destination.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        
        myMap.addAnnotation(destination)
        myMap.setRegion(region, animated: true)
    }
    
    // 맵 검색 (geocoder 사용하여 주소를 좌표로 변환)
    private func searchMap(_ addr: String) {
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(addr) { (placeMark, error) in
            if error != nil {
                return print(error!.localizedDescription)
            }
            guard let address = placeMark?.first else { return }
            self.goToAnnotation(addr, address)
        }
    }
    
    private func addSubView() {
        view.addSubview(myMap)
    }
    
    private func autoLayout() {
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            myMap.topAnchor.constraint(equalTo: guide.topAnchor),
            myMap.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            myMap.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            myMap.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            ])
    }
}
