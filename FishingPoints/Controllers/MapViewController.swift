//
//  MapViewController.swift
//  FishingPoints
//
//  Created by Roman Torry on 7.04.22.
//

import UIKit
import MapKit
import CoreLocation



protocol MapViewControllerDelegate {
    func getCoordinates (_ coordinates: String?)
}

class MapViewController: UIViewController {
    
    var mapVCDelegate: MapViewControllerDelegate?
    
    var point: Point!
    let annotationIdentifier = "annotationIdentifier"
    let locationManager = CLLocationManager()
    let regionInMeters = 1000.00
    var incomeSegueIdentifier = ""
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapPinMarker: UIImageView!
    @IBOutlet weak var coordinatesLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapView()
        checkLocationServices()

    }
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func doneButtonPressed() {
        
        mapVCDelegate?.getCoordinates(coordinatesLabel.text)
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func centerViewInUserLocation() {
        showUserLocation()
    }
    
    private func setupMapView () {
        if incomeSegueIdentifier == "showMap" {
            mapPinMarker.isHidden = true
            coordinatesLabel.isHidden = true
            doneButton.isHidden = true
            setupPlaceMark()
        }
    }
    
    private func setupPlaceMark () {
        
        guard let location = point?.coordinates else { return }
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(location) { placemarks, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let placemarks = placemarks else { return }
            let placemark = placemarks.first
            
            let annotation = MKPointAnnotation()
            annotation.title = self.point?.name
            //annotation.subtitle = point.typeOfPond
            guard let placeMarkLocation = placemark?.location else { return }
            annotation.coordinate = placeMarkLocation.coordinate
            self.mapView.showAnnotations([annotation], animated: true)
            self.mapView.selectAnnotation(annotation, animated: true)
            
            
        }
    }
    
    private func checkLocationServices () {
        
        if CLLocationManager.locationServicesEnabled() {
            //first setup
            setupLocationManager()
            checkLocationAutharization()
        } else {
            //show alert with path to enable location services
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(title: "Location services are disable", message: "You need to enable them by path: Settings -> Privacy -> Location Services and turn on")
            }
            
        }
    }
    
    private func setupLocationManager () {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
    }
    
    private func checkLocationAutharization () {
        
        
        switch CLLocationManager.authorizationStatus(){
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break // в каждом из кейсов необходим
        case .restricted:
            //show alert controller
            break
        case .denied:
            showAlert(title: "Your location isn't available.",
                      message: "To give permission you need to go to: Settings -> Fishing Points -> Location")
            break
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            if incomeSegueIdentifier == "getAdress" { showUserLocation()}
            break
        @unknown default:
            print ("New case is available.")
        }
    }
    
    private func showAlert (title: String, message: String) {
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        ac.addAction(okAction)
        present(ac, animated: true, completion: nil)
    }
    
    private func showUserLocation () {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location,
                                            latitudinalMeters: regionInMeters,
                                            longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    private func getCenterLocation (for mapView: MKMapView) -> CLLocation {
        
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
        
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil}
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.canShowCallout = true
        }
      
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            imageView.layer.cornerRadius = 10
            imageView.clipsToBounds = true
            let decodeData = Data(base64Encoded: (point?.imageOfPoint!)!, options: .ignoreUnknownCharacters)!
            imageView.image = UIImage(data: decodeData)
            annotationView?.leftCalloutAccessoryView = imageView
        
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)
        
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(center) { placemarks, error in
            if let error = error {
                print (error.localizedDescription)
                return
            }
            guard let placemarks = placemarks else { return }
            let placemark = placemarks.first
            let coordinates = (placemark?.location)!
            let lat = coordinates.coordinate.latitude
            let long = coordinates.coordinate.longitude
            
            DispatchQueue.main.async {
                self.coordinatesLabel.text = "\(lat), \(long)"
            }
        }
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAutharization()
    }
}
