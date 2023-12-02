//
//  ViewController.swift
//  GSATest
//
//  Created by Jatin on 02/12/23.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var goNext: UIButton!
    var startCoordinate: CLLocationCoordinate2D?
    var endCoordinate: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        mapView.addGestureRecognizer(tapGesture)
    }

    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        
        if startCoordinate == nil {
            startCoordinate = coordinate
            addAnnotation(at: coordinate, title: "Start Point")
        } else if endCoordinate == nil {
            endCoordinate = coordinate
            addAnnotation(at: coordinate, title: "End Point")
            showDistanceAlert()
        } else {
            showAlert("Do you want to change the Start Point?")
        }
    }

    func addAnnotation(at coordinate: CLLocationCoordinate2D, title: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        mapView.addAnnotation(annotation)
    }

    func showDistanceAlert() {
        let distance = calculateDistance()
        let alert = UIAlertController(title: "Distance", message: "Distance: \(distance) meters", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    func calculateDistance() -> CLLocationDistance {
        guard let start = startCoordinate, let end = endCoordinate else {
            return 0
        }
        let startLocation = CLLocation(latitude: start.latitude, longitude: start.longitude)
        let endLocation = CLLocation(latitude: end.latitude, longitude: end.longitude)
        return startLocation.distance(from: endLocation)
    }

    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Change", style: .default, handler: { _ in
            self.changeStartPoint()
        }))
        present(alert, animated: true, completion: nil)
    }

    func changeStartPoint() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleStartPointChange(_:)))
        mapView.addGestureRecognizer(tapGesture)
    }

    @objc func handleStartPointChange(_ gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        
        startCoordinate = coordinate
        mapView.removeAnnotations(mapView.annotations)
        addAnnotation(at: startCoordinate!, title: "Start Point")
        addAnnotation(at: endCoordinate!, title: "End Point")
        
        mapView.removeGestureRecognizer(gestureRecognizer)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    @IBAction func nextPressed(_ sender: Any) {
        guard let controller = UIStoryboard(name: "LoginView", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as?  LoginViewController else {fatalError()}
        self.navigationController?.pushViewController(controller, animated: false)
    }
}
