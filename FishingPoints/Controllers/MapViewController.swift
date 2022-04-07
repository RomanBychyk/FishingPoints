//
//  MapViewController.swift
//  FishingPoints
//
//  Created by Roman Torry on 7.04.22.
//

import UIKit
import MapKit


class MapViewController: UIViewController {
    
    var point: Point!
    let annotationIdentifier = "annotationIdentifier"
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPlaceMark()

    }
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
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
    
}
