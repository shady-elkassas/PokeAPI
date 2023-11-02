//
//  PokeAPITests.swift
//  PokeAPITests
//
//  Created by Shady Elkassas on 29/10/2023.
//

import XCTest
@testable import PokeAPI

final class PokeAPITests: XCTestCase {

    var viewModel: PokeViewModel!
    
    override func setUpWithError() throws {
        viewModel = PokeViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchRoot() {
           let expectation = XCTestExpectation(description: "Fetch Root")
           
           viewModel.getRoot()
           
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
               // Add an appropriate test assertion here.
               XCTAssertGreaterThan(self.viewModel.PokemonRoot.count, 0)
               expectation.fulfill()
           }
           
           wait(for: [expectation], timeout: 5)
       }
    
    func testFetchPokemonDetails() {
           let expectation = XCTestExpectation(description: "Fetch Pokemon Details")
           
           viewModel.getRoot()
           
           DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
               // Add an appropriate test assertion here.
               XCTAssertGreaterThan(self.viewModel.PokemonList.count, 0)
               expectation.fulfill()
           }
           
           wait(for: [expectation], timeout: 5)
       }
    
    func testFetchPokemonInfoByName() {
          let expectation = XCTestExpectation(description: "Fetch Pokemon Info by Name")
          
          viewModel.fetchPokemonInfoByName(name: "ditto")
          
          DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
              // Add an appropriate test assertion here.
              XCTAssertGreaterThan(self.viewModel.PokemonList.count, 0)
              expectation.fulfill()
          }
          
          wait(for: [expectation], timeout: 5)
      }

}
