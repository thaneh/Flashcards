//
//  MapView.swift
//  Flashcards
//
//  Created by Thane Heninger on 9/9/20.
//

import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
    
    let centerCoordinate: CLLocationCoordinate2D
    var pinCenter = true
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        if pinCenter {
            let annotation = MKPointAnnotation()
            annotation.coordinate = centerCoordinate
            mapView.addAnnotation(annotation)
        }
        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: UIViewRepresentableContext<MapView>) {
        //
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
//        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
//            parent.centerCoordinate = mapView.centerCoordinate
//        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = "Placemark"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            } else {
                annotationView?.annotation = annotation
            }
            return annotationView
        }
    }
}

extension MKPointAnnotation {
    static var example: MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.title = "London"
        annotation.subtitle = "Home to the 2012 Summer Olympics."
        annotation.coordinate = CLLocationCoordinate2D(latitude: 51.5, longitude: -0.13)
        return annotation
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(centerCoordinate: MKPointAnnotation.example.coordinate)
    }
}
