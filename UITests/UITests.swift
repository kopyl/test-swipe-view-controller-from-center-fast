import XCTest

func preparePushVCTest() -> (XCUICoordinate, XCUICoordinate) {
    let app = XCUIApplication()
    app.launch()
    
    let pushButton = app.buttons["Push VC"]
    XCTAssertTrue(pushButton.waitForExistence(timeout: 5))
    pushButton.tap()
    
    XCTAssertTrue(pushButton.waitForNonExistence(timeout: 5))
    
    let window = app.windows.firstMatch
    let startPoint = window.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
    let endPoint = window.coordinate(withNormalizedOffset: CGVector(dx: 0.6, dy: 0.5))
    
    return (startPoint, endPoint)
}


final class UITests: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    func testPushViewControllerAndSwipeBackFromCenterWithGlitch() throws {
        let (startPoint, endPoint) = preparePushVCTest()
        startPoint.press(forDuration: 0.05, thenDragTo: endPoint, withVelocity: XCUIGestureVelocity(3000), thenHoldForDuration: 0)
    }
    
    func testPushViewControllerAndSwipeBackFromCenterNoGlitch() throws {
        let (startPoint, endPoint) = preparePushVCTest()
        startPoint.press(forDuration: 0.05, thenDragTo: endPoint, withVelocity: .fast, thenHoldForDuration: 0)
    }
}
