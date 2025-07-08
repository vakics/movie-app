//
//  FavoriesViewUITests.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 07. 08..
//


import XCTest

final class FavoriesViewUITests: XCTestCase {
    
    let app = XCUIApplication()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        
        app.launch()
        sleep(3)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFavoriteSelection() throws {
        app.images["favorites"].tap()
        let scrollView = app.firstScrollViewView(withIdentifier: "favoritesScrollView")
        scrollView.swipeUp()
        print(scrollView.images)
        
        let secondCell = app.findElement(withId: "MediaItem2")
        secondCell?.tap()
         
                
        
    }
}
