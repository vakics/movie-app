//
//  movie_appUI2TestsLaunchTests.swift
//  movie-appUI2Tests
//
//  Created by Panna Krisztina Pazonyi on 2025. 06. 23..
//

import XCTest

final class movie_appUI2TestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}

extension XCUIElement {
    var firstChildCell: XCUIElement {
        return self.cells.element(boundBy: 0)
    }

    var firstChildImage: XCUIElement {
        return self.images.element(boundBy: 0)
    }
}

extension XCUIApplication {
    func firstCellInCollectionView(withIdentifier id: String) -> XCUIElement {
        return collectionViews[id].cells.element(boundBy: 0)
    }
}

extension XCUIApplication {
    func findElement(withId id: String) -> XCUIElement? {
        // Ellenőrzésre használt összes ismert típus
        let types: [XCUIElement.ElementType] = [
            .staticText,
            .button,
            .image,
            .textField,
            .secureTextField,
            .switch,
            .navigationBar,
            .collectionView,
            .table,
            .cell,
            .other
        ]

        for type in types {
            let element = descendants(matching: type)[id]
            if element.exists {
                return element
            }
        }

        // Ha semmit nem talált, visszatér egy nem létező elemre
        return nil
    }
}
