//
//  Location.swift
//  Best Lifter
//
//  Created by 피수영 on 2021/05/15.
//

import Foundation
import CoreLocation

class Location: NSObject, CLLocationManagerDelegate {
    // Create a CLLocationMananger
    private let locationManager = CLLocationManager()
    private var location = CLLocation()
    static let shared = Location()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func requestLocation(completion: (CLLocation?) -> Void) {
        locationManager.requestLocation()
        guard let location = locationManager.location else { return }
        self.location = location
        
        completion(self.location)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        self.location = location
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func getPlacemarkFromCoordinate(location: CLLocation?, completionHandler: @escaping (CLPlacemark?) -> Void) {
        guard let location = location else { return }
        
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if error == nil {
                let firstLocation = placemarks?.first
                completionHandler(firstLocation)
            }
            else {
                completionHandler(nil)
            }
        }
    }
    
    func getUserAddress(completion: @escaping (UserRank) -> Void) {
        guard let location = locationManager.location else { return }
        
        getPlacemarkFromCoordinate(location: location) { (placemark) in
            if let placemark = placemark,
               let administrativeArea = placemark.administrativeArea,
               let locality = placemark.locality {
                Network.shared.getUserRanking(userLocation: "\(administrativeArea) \(locality)") { userRank in
                    completion(userRank)
                }
            }
        }
    }
}
