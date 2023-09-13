//
//  DefaultApiManager_Tests.swift
//  RickAndMortyTests
//
//  Created by Vít Nademlejnský on 13.09.2023.
//

import XCTest
@testable import RickAndMorty

final class DefaultApiManager_Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_DefaultApiManager_somePagesLeft_NormalValueShouldReturnTrue() {
        //ARRANGE
        let defaultApiManager = DefaultApiManager { i in
            return ""
        }
        //ACT
        defaultApiManager.maxPage = 10
        defaultApiManager.pageNumber = 5
        let ret = defaultApiManager.somePagesLeft()
        
        //ASSERT
        XCTAssertTrue(ret)
    }
    
    func test_DefaultApiManager_somePagesLeft_MarginValueReturnsTrue() {
        //ARRANGE
        let defaultApiManager = DefaultApiManager { i in
            return ""
        }
        //ACT
        defaultApiManager.maxPage = 10
        defaultApiManager.pageNumber = 10
        let ret = defaultApiManager.somePagesLeft()
        
        //ASSERT
        XCTAssertTrue(ret)
    }
    
    func test_DefaultApiManager_somePagesLeft_OutOfBoundsValueReturnsTrue() {
        //ARRANGE
        let defaultApiManager = DefaultApiManager { i in
            return ""
        }
        //ACT
        defaultApiManager.maxPage = 10
        defaultApiManager.pageNumber = 11
        let ret = defaultApiManager.somePagesLeft()
        
        //ASSERT
        XCTAssertFalse(ret)
    }
}
