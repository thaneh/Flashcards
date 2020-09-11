//
//  PhotosFileService.swift
//  Flashcards
//
//  Created by Thane Heninger on 9/9/20.
//

import Foundation
import UIKit

protocol PhotosFileServiceProtocol {
    func save(image: UIImage, for id: UUID, completion: @escaping ()->Void)
    func load(photoID id: UUID, completion: @escaping (UIImage?)->Void)
}

class PhotosFileService {
    static let shared = PhotosFileService()
    
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    static var photosURL: URL {
        documentsDirectory.appendingPathComponent("Photos")
    }
    
    static func fileURL(id: UUID) -> URL {
        photosURL.appendingPathComponent(String(id.uuidString))
    }
    
    static func createPhotosDirectory() {
        try? FileManager.default.createDirectory(at: Self.photosURL, withIntermediateDirectories: true, attributes: nil)
    }
}

extension PhotosFileService: PhotosFileServiceProtocol {
    func save(image: UIImage, for id: UUID, completion: @escaping ()->Void) {
        DispatchQueue.global().async {
            do {
                Self.createPhotosDirectory()
                
                let fileURL = Self.fileURL(id: id)
                if let data = image.pngData() {
                    try data.write(to: fileURL)
                } else {
                    print("Unable to save photo.")
                }
                completion()
            } catch {
                print("Unable to save photo.")
                completion()
            }
        }
    }
    
    func load(photoID id: UUID, completion: @escaping (UIImage?)->Void) {
        DispatchQueue.global().async {
            let fileURL = Self.fileURL(id: id)
            guard let data = try? Data(contentsOf: fileURL),
                  let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            completion(image)
        }
    }
}
