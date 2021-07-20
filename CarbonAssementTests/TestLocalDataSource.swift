//
//  TestLocalDataSource.swift
//  CarbonAssementTests
//
//  Created by Anthony Odu on 19/07/2021.
//

import Foundation
import XCTest
@testable import CarbonAssement

class TestLocalDataSource: XCTestCase {
    
    var localDataSource:LocalDataSource!
    
    var coreDataStack:TestCoreDataStack!
    
   
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        localDataSource = LocalDataSource.shared
        coreDataStack = TestCoreDataStack()
        
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        coreDataStack = nil
    }


    /*this test case test for the proper initialization of CoreDataManager class :)*/
      func test_init_coreDataManager(){
        /*Asserts that an expression is not nil.
         Generates a failure when expression == nil.*/
        XCTAssertNotNil( localDataSource )
      }
    
    /*test if NSPersistentContainer(the actual core data stack) initializes successfully
     */
    func test_coreDataStackInitialization() {
        let coreDataStack = localDataSource.context
      /*Asserts that an expression is not nil.
       Generates a failure when expression == nil.*/
      XCTAssertNotNil( coreDataStack )
    }
    
    /*This test case inserts a movie*/
        func test_save_movie() {
            localDataSource.deleteAllData("MovieListItem")
            let result1 = Result(voteCount: 1, posterPath: "", id: 1, backdropPath: "", title: "Death Star", voteAverage: 2, overview: "", releaseDate: "")
            let result2 = Result(voteCount: 5, posterPath: "", id: 2, backdropPath: "", title: "Star", voteAverage: 8, overview: "", releaseDate: "")
            let result3 = Result(voteCount: 7, posterPath: "", id: 3, backdropPath: "", title: "Death Race", voteAverage: 4, overview: "", releaseDate: "")
            
            localDataSource.saveItem(item: result1) { _ in }
            XCTAssertNotNil( result1 )
            XCTAssertNotNil(result1, "Result should not be nil")
            XCTAssertTrue(result1.title == "Death Star")
            XCTAssertTrue(result1.voteCount == 1)
            XCTAssertTrue(result1.voteAverage == 2)
            XCTAssertNotNil(result1.id, "id should not be nil")
            
            
            localDataSource.saveItem(item: result2) { _ in }
            XCTAssertNotNil( result2 )
            XCTAssertNotNil(result2, "Result should not be nil")
            XCTAssertTrue(result2.title == "Star")
            XCTAssertTrue(result2.voteCount == 5)
            XCTAssertTrue(result2.voteAverage == 8)
            XCTAssertNotNil(result2.id, "id should not be nil")
            
            
            localDataSource.saveItem(item: result3) { _ in }
            XCTAssertNotNil( result3 )
            XCTAssertNotNil(result3, "Result should not be nil")
            XCTAssertTrue(result3.title == "Death Race")
            XCTAssertTrue(result3.voteCount == 7)
            XCTAssertTrue(result3.voteAverage == 4)
            XCTAssertNotNil(result3.id, "id should not be nil")
        }
    
    /*This test case fetches all movies*/
        func test_fetch_all_movies() {
             localDataSource.getAllitem { results in
                XCTAssertEqual(results.count, 3)
            } onFail: { _ in}

          
        
        }
    
    func test_remove_movie() {
        localDataSource.deleteAllData("MovieListItem")
        let result1 = Result(voteCount: 1, posterPath: "", id: 1, backdropPath: "", title: "Death Star", voteAverage: 2, overview: "", releaseDate: "")
        
        localDataSource.saveItem(item: result1) { _ in }
        
        localDataSource.getAllitem { results in
            XCTAssertTrue(results.count == 1)
            XCTAssertTrue(Int64(result1.id) == results.first?.id)
           
       } onFail: { _ in}

        localDataSource.deleteItem(item: result1)
        
        localDataSource.getAllitem { results in
            XCTAssertTrue(results.isEmpty)
       } onFail: { _ in}

      }
}
