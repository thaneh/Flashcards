//
//  FlashcardsUITests.swift
//  FlashcardsUITests
//
//  Created by Thane Heninger on 8/28/20.
//

import XCTest

class FlashcardsUITests: XCTestCase {
    
    let app = XCUIApplication()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAddCardDismissButtonSwitchesName() throws {
        app.launch()
        app.navigationBars["Flashcards"].buttons["add"].tap()
        
        let button = app.buttons["AddItemView.dismiss"]
        XCTAssertTrue(button.waitForExistence(timeout: 1))
        XCTAssertEqual(button.label, "Cancel")
        
        let title = app.textFields["AddItemView.title"]
        title.tap()
        title.typeText("A")
        
        XCTAssertEqual(button.label, "Save")
        
        app.keys["delete"].tap()
        XCTAssertEqual(button.label, "Cancel")
    }
    
    func testAddDeleteCard() throws {
        let name = "Test Item"
        let description = "Test Description"
        
        app.launch()
        app.navigationBars["Flashcards"].buttons["add"].tap()

        let nameField = app.textFields["AddItemView.title"]
        nameField.tap()
        nameField.typeText(name)

        let descriptionField = app.textFields["AddItemView.description"]
        descriptionField.tap()
        descriptionField.typeText(description)

        let button = app.buttons["AddItemView.dismiss"]
        button.tap()
        
        let predicate = NSPredicate(format: "label BEGINSWITH %@", name)
        let cell = app.cells.matching(predicate).element
        cell.tap()

        let nameText = app.staticTexts["ItemDetails.name"]
        XCTAssertEqual(nameText.label, name)
        let descriptionText = app.staticTexts["ItemDetails.description"]
        XCTAssertEqual(descriptionText.label, description)

        app.navigationBars.element.buttons["Flashcards"].tap()
        
        app.navigationBars.element.buttons["Edit"].tap()
        cell.buttons["Delete "].tap()
        app.tables.buttons["Delete"].tap()
        app.navigationBars.element.buttons["Done"].tap()
        
        XCTAssertFalse(cell.exists)
    }
}
