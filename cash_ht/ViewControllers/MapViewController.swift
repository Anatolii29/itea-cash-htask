//
//  MapViewController.swift
//  cash_ht
//
//  Created by Anatolii on 7/28/19.
//  Copyright © 2019 Anatolii. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    
    var locationManager = CLLocationManager()
    var currentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        backButton.layer.cornerRadius = 8
        profileButton.layer.cornerRadius = 8
        updatePosition(long: 30.6081901, lat: 50.4130771, locZoom: 10)
        backButton.isHidden = true
    }
    
    func update(user: User?) {
        currentUser = user
    }
    
    @IBAction func profileButtonPressed(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                vc.update(user: currentUser)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension MapViewController: CLLocationManagerDelegate, GMSMapViewDelegate {
    func updatePosition(long: Double?, lat: Double?, locZoom: Double?) {
        guard let _ = lat, let _ = long else {
            return
        }
        
        let camera = GMSCameraPosition.camera(withLatitude: lat ?? 0.0, longitude: long ?? 0.0, zoom: Float(locZoom ?? 10))
        self.mapView.animate(to: camera)
        self.locationManager.stopUpdatingLocation()
        updateMarkers()
    }
    
    func updateMarkers() {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: currentUser?.latitude ?? 0, longitude: currentUser?.longitude ?? 0)
        marker.icon = UIImage(named: "mark1")
        marker.title = "\(currentUser?.name ?? "") \(currentUser?.surname ?? "")"
        marker.userData = currentUser
        marker.map = mapView
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NewsViewController") as! NewsViewController
                vc.update(user: currentUser)
        self.navigationController?.pushViewController(vc, animated: true)
        return false
    }
    
}
