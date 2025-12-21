import XCTest

final class UITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testPushViewControllerAndSwipeBack() throws {
        let app = XCUIApplication()
        app.launch()

        let pushButton = app.buttons["Push VC"]
        XCTAssertTrue(pushButton.waitForExistence(timeout: 5))
        pushButton.tap()
        
        XCTAssertTrue(pushButton.waitForNonExistence(timeout: 5))
        
        let window = app.windows.firstMatch
        let startPoint = window.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        let endPoint = window.coordinate(withNormalizedOffset: CGVector(dx: 0.6, dy: 0.5))
        startPoint.press(forDuration: 0.05, thenDragTo: endPoint, withVelocity: XCUIGestureVelocity(3000), thenHoldForDuration: 0)
    }
}
