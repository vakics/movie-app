//
//  GenreSectionViewUITests.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 06. 23..
//


import XCTest

final class GenreSectionViewUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        
        app.launch()
        sleep(5)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testTabBarItems() throws {
        // UI tests must launch the application that they test.
        
        app.images["search"].tap()
        app.images["favorites"].tap()
        app.images["settings"].tap()
        app.images["genre"].tap()
        
        
    }
    
    func testUsage() throws {
        // UI tests must launch the application that they test.
        
        let collectionView = app.firstCellInCollectionView(withIdentifier: "genreSectionCollectionView")
//        let collectionView = app.collectionViews.firstMatch
        collectionView.swipeUp()
        
        let adventureGenreCell = app.findElement(withId: "Adventure")
        adventureGenreCell?.tap()
        
        
    }
}
