//
//  MapViewController.swift
//  Raya
//
//  Created by Yahya haj ali  on 28/04/2022.
//
import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureMapView()
        configureLeftBarButton()
        
        self.title = "Map View"
        // Do any additional setup after loading the view.
    }
    
     //MARK:- Vars
    
    var location: CLLocation?
    var mapView: MKMapView!
    
    
    private func configureMapView() {
        
        mapView = MKMapView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        
        mapView.showsUserLocation = true
        if location != nil {
            mapView.setCenter(location!.coordinate, animated: false)
            mapView.addAnnotation(MapAnnotation(title: "User Location", coordinate: location!.coordinate))
            
        }
        
        view.addSubview(mapView)
        
        
    }
    
    private func configureLeftBarButton() {
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(self.backButtonPressed))
    }
    
    @objc func backButtonPressed() {
        
        self.navigationController?.popViewController(animated: true)
    }
    

}
