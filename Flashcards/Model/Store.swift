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
    static let shared = Store(photosFileService: PhotosFileService.shared)
    
    var cards = [Card]()
    private let fileService: PhotosFileServiceProtocol
    
    init(photosFileService: PhotosFileServiceProtocol) {
        self.fileService = photosFileService
    }
    
    func addItem(name: String, details: String?,
                 image: UIImage?,
                 location: CLLocationCoordinate2D?) throws {
        let id = UUID()
        if let image = image {
            saveImage(image: image, forID: id)
        }
        let card = Card(id: id, created: Date(), name: name,
                        details: details ?? "", //photo: image,
                        location: location)
        
        try PersistenceController.shared.addItem(card: card)
        
        cards.append(card)
    }
    
    func saveImage(image: UIImage, forID id: UUID) {
//        if let jpegData = image.jpegData(compressionQuality: 0.8) {
//            fileService.save(data: jpegData, for: id) {
//                print("save completed for \(id.uuidString)")
//            }
//        }
        if let data = image.pngData() {
            fileService.save(data: data, for: id) {
                print("save completed for \(id.uuidString)")
            }
        }
    }
    
    func loadImage(id: UUID, completion: @escaping (UIImage?)->Void) {
        fileService.load(photoID: id) { image in
            completion(image)
        }
    }
    
    func loadItems(completion: @escaping ([Card])->Void) {
        PersistenceController.shared.loadItems { items in
            if let cards = try? items.map(self.toCard) {
                self.cards = cards
                completion(cards)
            } else {
                completion([Card]())
            }
        }
    }
    
    func deleteItems(offsets: IndexSet, completion: @escaping ()->Void) {
        PersistenceController.shared.deleteItems(offsets: offsets,
                                                 completion: completion)
    }
        
    enum ConversionError: Error {
        case invalidData
    }
    
    func toCard(from item: CoreItem) throws -> Card {
        guard let id = item.id,
              let date = item.created,
              let name = item.name else {
            throw ConversionError.invalidData
        }
        var location: CLLocationCoordinate2D?
        if item.hasLocation {
            location = CLLocationCoordinate2D(latitude: item.latitude,
                                              longitude: item.longitude)
        }
        return Card(id: id, created: date, name: name,
                    details: item.details ?? "", /*photo: image,*/ location: location)
    }
}
