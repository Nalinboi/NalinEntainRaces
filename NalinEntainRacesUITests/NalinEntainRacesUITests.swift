//
//  NalinEntainRacesUITests.swift
//  NalinEntainRacesUITests
//
//  Created by Nalin Aswani on 30/03/2025.
//

import XCTest

final class NalinEntainRacesUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        // Adding a launch argument so that the app runs with mock data
        app.launchArguments.append("-UITestMode")
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testRaceCategoryPickers() throws {
        // Check if "Upcoming Races" title is visible
        XCTAssertTrue(app.navigationBars["Upcoming Races"].exists, "The navigation title is not displayed.")
        
        var pickerString = "All" // Starts off at all then keeps changing
        var picker: XCUIElement {
            app.buttons["Race Category, \(pickerString)"]
        }
        XCTAssertTrue(picker.exists, "Race category picker does not exist.")
        let pickerOptions = ["Horse", "Greyhound", "Harness", "All"]
        for optionString in pickerOptions {
            picker.tap()
            let optionElement = app.buttons[optionString]
            XCTAssertTrue(optionElement.waitForExistence(timeout: 5), "The '\(optionString)' option is missing in the picker.")
            optionElement.tap()
            pickerString = optionString // Update the picker name for the tests
            XCTAssertTrue(picker.waitForExistence(timeout: 5), "Picker did not update to '\(optionString)'.")
        }
        
    }
    
    
    // TODO: I would have done the following UITests if I had more time
    // It would require changes to my MockNetworkManager so that I could edit the AdvertisedStart times adjusted towards todays date.
//    // Check if the 5 expected races names are there from the mock data
//    let upcomingRaceNames = ["Monmore Bags", "Adana", "Lingfield", "Oxford", "Perry Barr Bags"]
//    checkForTheseRaces(racesList: upcomingRaceNames)
//    private func checkForTheseRaces(racesList: [String]) {
//        for raceName in racesList {
//            XCTAssertTrue(app.staticTexts[raceName].waitForExistence(timeout: 5), "\(raceName) not found in the list of races")
//        }
//    }

    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
