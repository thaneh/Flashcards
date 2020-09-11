//
//  MockPersistence.swift
//  FlashcardsTests
//
//  Created by Thane Heninger on 9/11/20.
//

import Foundation
@testable import Flashcards

class MockPersistence: PersistenceControllerProtocol {
    var invokedAddItem = false
    var invokedAddItemParameters: (card: Card, Void)?
    func addItem(card: Card) throws {
        invokedAddItem = true
        invokedAddItemParameters = (card, ())
    }
    
    var invokedDeleteItems = false
    func deleteItems(offsets: IndexSet, completion: @escaping () -> Void) {
        invokedDeleteItems = true
    }
    
    var invokedLoadItems = false
    var invokedLoadItemsParameters: (completion: ([Card])->Void, Void)?
    func loadItems(completion: @escaping ([Card]) -> Void) {
        invokedLoadItems = true
        invokedLoadItemsParameters = (completion, ())
    }
}
