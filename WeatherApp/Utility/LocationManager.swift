//
//  LocationManager.swift
//  WeatherApp
//
//  Created by 정현 on 3/13/24.
//

import Foundation
import CoreLocation
import SwiftUI

class LocationManager : NSObject, ObservableObject, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    let locale = Locale(identifier: "Ko-kr")
    @Published var authorizationStatus : CLAuthorizationStatus?
    var latitude : Double {
        locationManager.location?.coordinate.latitude ?? 0.0
    }
    
    var longtitude : Double {
        locationManager.location?.coordinate.longitude ?? 0.0
    }
    
    override init(){
        super.init()
        locationManager.delegate = self
    }
    
  
    func reverseGeocoding(latitude: CLLocationDegrees, longitude: CLLocationDegrees,completion : @escaping(String) -> ()){
            let geocoder = CLGeocoder()
            let location = CLLocation(latitude: latitude, longitude: longitude)
    
        geocoder.reverseGeocodeLocation(location) {placemarks, error in
            if let placemark = placemarks?.first {

                let address = placemark.address!
               
                completion(address)
            }
        }
    }
      
        
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            authorizationStatus = .authorizedWhenInUse
            locationManager.requestLocation()
            break
            
        case .restricted :
            authorizationStatus = .restricted
            break
            
        case .denied :
            authorizationStatus = .denied
            break
            
        case .notDetermined :
            authorizationStatus = .notDetermined
            manager.requestWhenInUseAuthorization()
            break
            
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        locationManager.stopUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error location")
    }
    
    
}


extension CLPlacemark {

    var address: String? {
        if let name = name {
            var result = ""

            if let country = country {
                result += "\(country)"
            }

            if let city = locality {
                result += ", \(city)"
            }
    

            return result
        }

        return nil
    }

}
