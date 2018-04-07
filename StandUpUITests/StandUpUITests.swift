//
//  StandUpUITests.swift
//  StandUpUITests
//
//  Created by Devesh Laungani on 3/21/18.
//  Copyright © 2018 Devesh Laungani. All rights reserved.
//

import XCTest

class StandUpUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let app = XCUIApplication()
        setupSnapshot(app)
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launch()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        
    
        snapshot("Notifications")
        
        let app = XCUIApplication()
        app.buttons["WSettings"].tap()
        
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Work Times"]/*[[".cells.staticTexts[\"Work Times\"]",".staticTexts[\"Work Times\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        snapshot("Times")
        
        app.navigationBars["StandUp_Production.WorkTimeView"].buttons["Done"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.textFields["Live Longer by Standing Up  Now"]/*[[".cells.textFields[\"Live Longer by Standing Up  Now\"]",".textFields[\"Live Longer by Standing Up  Now\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCUIApplication().tables.cells.containing(.staticText, identifier:"Notification Message").children(matching: .textField).element.typeText("This is my custom message")
        snapshot("Customize")
       
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}
