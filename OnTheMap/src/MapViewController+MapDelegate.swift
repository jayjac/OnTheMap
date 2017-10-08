//
//  MapViewController+MapDelegate.swift
//  OnTheMap
//
//  Created by Jean-Yves Jacaria on 06/10/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import MapKit


extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var view: StudentAnnotationView
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin") as? StudentAnnotationView {
            annotationView.annotation = annotation
            view = annotationView
        }
        else {
            let nib = UINib(nibName: "StudentAnnotationView", bundle: nil)
            let nibView = nib.instantiate(withOwner: nil, options: nil)[0]
            guard let studentAnnotationView = nibView as? StudentAnnotationView else { return nil }
            studentAnnotationView.annotation = annotation
            studentAnnotationView.isEnabled = true
            view = studentAnnotationView
        }
        view.dropPinIfNeeded()
        return view
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let studentAnnotationView = view as? StudentAnnotationView else { return }
        studentAnnotationView.animateAnnotation(to: .focused)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        //print("deselected annotation")
        guard let studentAnnotationView = view as? StudentAnnotationView else { return }
        studentAnnotationView.animateAnnotation(to: .normal)
    }

    
}
