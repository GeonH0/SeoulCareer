//
//  MapView.swift
//  BusanCareer
//
//  Created by 김건호 on 12/26/23.
//
import Foundation
import UIKit
import NMapsMap
import CoreLocation
//import SwiftUI

class MapView: UIView, NMFMapViewTouchDelegate, CLLocationManagerDelegate {
    var locationManager: CLLocationManager!
    var infoWindow = NMFInfoWindow()
    var mapNaverView: NMFNaverMapView!
    var onMarkerTapped: ((NMGLatLng) -> Void)?
    var sections: [Section] = []
    
    func setupMapView() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()

        mapNaverView = NMFNaverMapView()
        mapNaverView.showZoomControls = true
        mapNaverView.showLocationButton = true
        mapNaverView.mapView.isScrollGestureEnabled = true
        mapNaverView.mapView.isTiltGestureEnabled = true
        mapNaverView.mapView.isRotateGestureEnabled = true
        mapNaverView.mapView.isStopGestureEnabled = true
        mapNaverView.translatesAutoresizingMaskIntoConstraints = false
        mapNaverView.mapView.touchDelegate = self

        addSubview(mapNaverView)
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mapNaverView.topAnchor.constraint(equalTo: topAnchor),
            mapNaverView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mapNaverView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapNaverView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    func setupMarkers() {
           if sections.isEmpty {
               print("섹션 데이터가 비어 있습니다.")
               return
           }

           for section in sections {
               if section.sectionTitle == "기타" {return}
               let marker = NMFMarker()
               marker.position = NMGLatLng(lat: section.latitude, lng: section.longitude)
               marker.mapView = mapNaverView.mapView

               marker.touchHandler = { [weak self] (overlay: NMFOverlay) -> Bool in
                   if let marker = overlay as? NMFMarker {
                       self?.onMarkerTapped?(marker.position)
                   }
                   return true
               }
           }
       }

}
