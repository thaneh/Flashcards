//
//  LocationFetcher.swift
//  Flashcards
//
//  Created by Thane Heninger on 9/9/20.
//

import CoreLocation

class LocationFetcher: NSObject {
    static let shared: LocationFetcher = {
        let fetcher = LocationFetcher()
        fetcher.start()
        return fetcher
    }()
    
    let manager = CLLocationManager()
    var lastKnownLocation: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func start() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
}

extension LocationFetcher: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first?.coordinate
    }
}
