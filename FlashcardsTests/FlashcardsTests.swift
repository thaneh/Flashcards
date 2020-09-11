//
//  FlashcardsTests.swift
//  FlashcardsTests
//
//  Created by Thane Heninger on 8/28/20.
//

import XCTest
@testable import Flashcards

class FlashcardsTests: XCTestCase {
    
    var fileService: MockFileService!
    var persistence: MockPersistence!
    var store: Store!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        fileService = MockFileService()
        persistence = MockPersistence()
        
        store = Store(photosFileService: fileService, persistence: persistence)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testAddSimpleItem() throws {
        try store.addItem(name: "Test Item", details: "details", image: nil, location: nil)
        
        XCTAssertFalse(fileService.invokedSave)
        XCTAssertTrue(persistence.invokedAddItem)
        let card = persistence.invokedAddItemParameters?.card
        XCTAssertNotNil(card)
        XCTAssertEqual(card!.name, "Test Item")
        XCTAssertEqual(card!.details, "details")
        XCTAssertNil(card!.location)
    }
    
    func testAddItemWithImage() throws {
        let image = UIImage(systemName: "photo")
        try store.addItem(name: "Test Item", details: "details", image: image, location: nil)
        
        XCTAssertTrue(fileService.invokedSave)
        let params = fileService.invokedSaveParameters
        XCTAssertNotNil(params)
        XCTAssertEqual(params!.image, image)
        XCTAssertEqual(params!.id, persistence.invokedAddItemParameters?.card.id)
    }
    
    func testLoad() throws {
        var responded = false
        store.loadItems { cards in
            responded = true
        }
        
        XCTAssertTrue(persistence.invokedLoadItems)
        XCTAssertFalse(responded)
        
        persistence.invokedLoadItemsParameters?.completion([])
        XCTAssertTrue(responded)
    }
}
