//
//  MapViewController.swift
//  Yelp
//
//  Created by Nguyen Xuan Gieng on 9/8/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import MapKit

class MapViewController: SearchViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var crosshairButton: UIButton!
    
    var delegate: SearchViewController!
    
    var center: CLLocationCoordinate2D!
    var annotations: Array<MKPointAnnotation>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        
        self.crosshairButton.layer.cornerRadius = 5.0
        self.crosshairButton.layer.masksToBounds = true
        
        self.synchronize(self.delegate)
        
        if self.results.count == 0 {
            let center = UserLocation.instance.location.coordinate
            let span = MKCoordinateSpanMake(0.05, 0.05)
            self.mapView.setRegion(MKCoordinateRegion(center: center, span: span), animated: false)
        }
    }
    
    override func onBeforeSearch() {
    }
    
    override func onResults(results: [Business], total: Int, response: NSDictionary) {
        if let region = response["region"] as? Dictionary<String, Dictionary<String, Double>> {
            self.center = nil
            let center = CLLocationCoordinate2D(
                latitude: region["center"]!["latitude"]!,
                longitude: region["center"]!["longitude"]!
            )
            let span = MKCoordinateSpanMake(
                region["span"]!["latitude_delta"]!,
                region["span"]!["longitude_delta"]!
            )
            self.mapView.setRegion(MKCoordinateRegion(center: center, span: span), animated: true)
        } else {
            println("error: unable to parse region in response")
        }
        
        self.annotations = []
        for business in results {
            let annotation = MKPointAnnotation()
            let coordinate = CLLocationCoordinate2D(latitude: business.latitude as! Double, longitude: business.longitude as! Double)
            annotation.coordinate = coordinate
            annotation.title = business.name!
            annotation.subtitle = business.categories!
            self.annotations.append(annotation)
        }
        self.mapView.addAnnotations(self.annotations)
    }
    
    override func onResultsCleared() {
        self.mapView.removeAnnotations(self.mapView.annotations)
    }
    
    override func getSearchParameters() -> Dictionary<String, String> {
        var parameters = super.getSearchParameters()
        
        let rect = self.mapView.visibleMapRect
        let neCoord = MKCoordinateForMapPoint(MKMapPointMake(MKMapRectGetMaxX(rect), rect.origin.y))
        let swCoord = MKCoordinateForMapPoint(MKMapPointMake(rect.origin.x, MKMapRectGetMaxY(rect)))
        parameters["bounds"] = "\(swCoord.latitude),\(swCoord.longitude)|\(neCoord.latitude),\(neCoord.longitude)"
        parameters.removeValueForKey("ll")
        
        return parameters
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if !(annotation is MKPointAnnotation) {
            return nil
        }
        
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier("pin") as? MKPinAnnotationView
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            view!.canShowCallout = true
            view!.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIView
        }
        return view
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        let index = (self.annotations as NSArray).indexOfObject(view.annotation)
        if index >= 0 {
            self.showDetailsForResult(self.results[index])
        }
    }
    
    func mapView(mapView: MKMapView!, regionDidChangeAnimated animated: Bool) {
        if self.center == nil {
            self.center = mapView.region.center
        } else {
            let before = CLLocation(latitude: self.center.latitude, longitude: self.center.longitude)
            let nowCenter = mapView.region.center
            let now = CLLocation(latitude: nowCenter.latitude, longitude: nowCenter.longitude)
            
            if self.searchBar.text != "" || before.distanceFromLocation(now) > 100 {
                ReSearch()
            }
        }
    }
    
    func ReSearch() {
        self.clearResults()
        self.performSearch(self.searchBar.text)
    }

    
    @IBAction func onCrosshairButton(sender: AnyObject) {
        let center = UserLocation.instance.location.coordinate
        let region = MKCoordinateRegion(center: center, span: self.mapView.region.span)
        self.mapView.setRegion(region, animated: true)
    }
    
    @IBAction func onSearchListButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.delegate.synchronize(self)
    }
    
}
