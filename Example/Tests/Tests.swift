import XCTest
import Inletclient

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func onError(_ error: Error) {
        print("Inletclient error– \(error)")
    }
    
    func onBrandDetails(_ brandDetails: BrandDetails) {
        print("Inletclient brand details– \(brandDetails)")
    }
    
    func testExample() {
        let payWithWfUser:PayWithWfUser = "bill"
        // This is an example of a functional test case.
        Inletclient.getPayees(payWithWfUser: payWithWfUser, onBrandDetails: onBrandDetails, onError: onError)
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
