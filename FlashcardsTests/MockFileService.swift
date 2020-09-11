//
//  MockFileService.swift
//  FlashcardsTests
//
//  Created by Thane Heninger on 9/11/20.
//

import UIKit
@testable import Flashcards

class MockFileService: PhotosFileServiceProtocol {
    var invokedSave = false
    var invokedSaveParameters: (image: UIImage, id: UUID, completion: () -> Void)?
    func save(image: UIImage, for id: UUID, completion: @escaping () -> Void) {
        invokedSave = true
        invokedSaveParameters = (image, id, completion)
    }
    
    var invokedLoad = false
    func load(photoID id: UUID, completion: @escaping (UIImage?) -> Void) {
        invokedLoad = true
    }
}
