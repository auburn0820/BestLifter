//
//  NetworkTest.swift
//  Best LifterTests
//
//  Created by 피수영 on 2021/05/26.
//

import XCTest
@testable import Best_Lifter

class NetworkTest: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testImagePredict() {
        let network = Network()
        
        guard let image = UIImage(named: "Pho") else { return }
        
        network.sendImageToPredictServer(image: image)
    }
}
