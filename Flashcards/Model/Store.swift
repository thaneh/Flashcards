//
//  Store.swift
//  Flashcards
//
//  Created by Thane Heninger on 9/9/20.
//

import Foundation
import MapKit
import UIKit

class Store {
    static let shared = Store(photosFileService: PhotosFileService.shared,
                              persistence: PersistenceController.shared)
    
    private let fileService: PhotosFileServiceProtocol
    private let persistence: PersistenceControllerProtocol
    
    init(photosFileService: PhotosFileServiceProtocol,
         persistence: PersistenceControllerProtocol) {
        self.fileService = photosFileService
        self.persistence = persistence
    }
    
    func addItem(name: String, details: String?,
                 image: UIImage?,
                 location: CLLocationCoordinate2D?) throws {
        let id = UUID()
        if let image = image {
            saveImage(image: image, forID: id)
        }
        let card = Card(id: id, created: Date(), name: name,
                        details: details ?? "",
                        location: location)
        
        try persistence.addItem(card: card)
    }
    
    func saveImage(image: UIImage, forID id: UUID) {
//        if let jpegData = image.jpegData(compressionQuality: 0.8) {
//            fileService.save(data: jpegData, for: id) {
//                print("save completed for \(id.uuidString)")
//            }
//        }
        fileService.save(image: image, for: id) {
            print("save completed for \(id.uuidString)")
        }
    }
    
    func loadImage(id: UUID, completion: @escaping (UIImage?)->Void) {
        fileService.load(photoID: id) { image in
            completion(image)
        }
    }
    
    func loadItems(completion: @escaping ([Card])->Void) {
        persistence.loadItems(completion: completion)
    }
    
    func deleteItems(offsets: IndexSet, completion: @escaping ()->Void) {
        persistence.deleteItems(offsets: offsets, completion: completion)
    }
}
