//
//  Card.swift
//  Flashcards
//
//  Created by Thane Heninger on 9/9/20.
//

import Foundation
import MapKit
import UIKit

struct Card: Identifiable {
    let id: UUID
    let created: Date
    let name: String
    let details: String
//    let photo: UIImage?
    let location: CLLocationCoordinate2D?
    
    static let example = Card(id: UUID(), created: Date(), name: "Example", details: "Details", location: nil)
}
