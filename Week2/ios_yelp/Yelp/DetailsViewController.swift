//
//  DetailsViewController.swift
//  Yelp
//
//  Created by Nguyen Xuan Gieng on 9/8/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import Foundation
import MapKit

class DetailsViewController: UIViewController, MKMapViewDelegate {
    
    var business: Business!
    
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var userLocation: UserLocation = UserLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(business)
        self.navigationItem.title = business.name!
        
        if (self.business.imageURL != nil) {
            self.previewImage.setImageWithURL(self.business.imageURL)
        }
        
        self.previewImage.layer.cornerRadius = 9.0
        self.previewImage.layer.masksToBounds = true
        
        self.ratingImage.setImageWithURL(self.business.ratingImageURL)
        
        let reviewCount = self.business.reviewCount
        if (reviewCount == 1) {
            self.reviewLabel.text = "\(reviewCount!) review"
        } else {
            self.reviewLabel.text = "\(reviewCount!) reviews"
        }
        
        self.addressLabel.text = self.business.address!
        self.categoriesLabel.text = self.business.categories!
        
        self.distanceLabel.text = String(format: "%.2f mi", UserLocation.instance.location.distanceFromLocation(business.location) / 1609.344)
        
        self.mapView.delegate = self
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: business.latitude as! Double, longitude: business.longitude as! Double)
        self.mapView.addAnnotation(annotation)
        self.mapView.setRegion(MKCoordinateRegion(center: annotation.coordinate, span: MKCoordinateSpanMake(0.01, 0.01)), animated: false)
        self.mapView.layer.cornerRadius = 9.0
        self.mapView.layer.masksToBounds = true


}
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if !(annotation is MKPointAnnotation) {
            return nil
        }
        
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier("pin") as? MKPinAnnotationView
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            view!.canShowCallout = false
        }
        return view
    }
}