import XCTest

func preparePushVCTest(startPoint: CGVector, endPoint: CGVector) -> (XCUICoordinate, XCUICoordinate) {
    let app = XCUIApplication()
    app.launch()
    
    let pushButton = app.buttons["Push VC"]
    XCTAssertTrue(pushButton.waitForExistence(timeout: 5))
    pushButton.tap()
    
    XCTAssertTrue(pushButton.waitForNonExistence(timeout: 5))
    
    let window = app.windows.firstMatch
    let startPoint = window.coordinate(withNormalizedOffset: startPoint)
    let endPoint = window.coordinate(withNormalizedOffset: endPoint)
    
    return (startPoint, endPoint)
}


final class UITests: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    func testPushViewControllerAndSwipeBackFromCenterWithGlitch() throws {
        let (startPoint, endPoint) = preparePushVCTest(startPoint: CGVector(dx: 0.5, dy: 0.5), endPoint: CGVector(dx: 0.6, dy: 0.5))
        startPoint.press(forDuration: 0.05, thenDragTo: endPoint, withVelocity: XCUIGestureVelocity(3000), thenHoldForDuration: 0)
    }
    
    func testPushViewControllerAndSwipeBackFromCenterNoGlitch() throws {
        let (startPoint, endPoint) = preparePushVCTest(startPoint: CGVector(dx: 0.5, dy: 0.5), endPoint: CGVector(dx: 0.6, dy: 0.5))
        startPoint.press(forDuration: 0.05, thenDragTo: endPoint, withVelocity: .fast, thenHoldForDuration: 0)
    }
    
    func testPushViewControllerAndSwipeBackFromLeftSide() throws {
        let (startPoint, endPoint) = preparePushVCTest(startPoint: CGVector(dx: 0.0, dy: 0.5), endPoint: CGVector(dx: 0.1, dy: 0.5))
        startPoint.press(forDuration: 0.05, thenDragTo: endPoint, withVelocity: XCUIGestureVelocity(3000), thenHoldForDuration: 0)
    }
}
