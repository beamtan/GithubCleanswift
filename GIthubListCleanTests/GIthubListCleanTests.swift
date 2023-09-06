//
//  GIthubListCleanTests.swift
//  GIthubListCleanTests
//
//  Created by A667243 A667243 on 30/8/2566 BE.
//

import XCTest
@testable import GIthubListClean

final class GIthubListCleanTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    var interactor: GithubInteractor!
    var presenter: MockGithubPresenter!
    var worker: MockGithubWorker!
    
    var allUser: [GitHubUser] = []
    var github30people: [GitHubUser] = []
    var mockData = GitHubMockDataGenerator()
    
    override func setUp() {
        super.setUp()
        interactor = GithubInteractor()
        presenter = MockGithubPresenter()
        worker = MockGithubWorker()
        
        interactor.presenter = presenter
        interactor.worker = worker
        
        mockData.setUpGitHubMockData()
    }
    
    override func tearDown() {
        interactor = nil
        presenter = nil
        worker = nil
        super.tearDown()
    }
    
    
    func testInteractorLikeUser() {
        // Given
        let row = 0 // Index of the user to be toggled from unliked to liked
        let request = Github.UserIsLiked.Request(updateAt: row)
        interactor.allUser = self.mockData.allUser
        
        // When
        interactor.interactorLikeUser(request: request)
        
        // Then
        XCTAssertTrue(presenter.presentRefreshTableCalled)
        XCTAssertEqual(presenter.refreshTableViewModel?.updateAt, row)
        XCTAssertTrue(interactor.allUser[row].isLiked)
    }
    
    func testInteractorGetMoreDataWithValidPage() {
        // Given
        interactor.currentPage = 1 // Set the current page
        interactor.isLoadingData = false 
        interactor.allUser = self.mockData.github30people

        // When
        interactor.interactorGetMoreData()

        // Then
        XCTAssertTrue(presenter.presentGithubUserCalled)
        XCTAssertEqual(interactor.currentPage, 2) // Check if currentPage is incremented
        // Add more assertions based on your logic
    }

    func testInteractorGetMoreData() {
        // Given
        interactor.currentPage = 1
        interactor.isLoadingData = false
        interactor.allUser = self.mockData.github30people

        // When
        interactor.interactorGetMoreData()

        // Then
        XCTAssertTrue(presenter.presentGithubUserCalled)
        XCTAssertEqual(presenter.presentGithubUserResponse!.githubUser?.count, 20)
        XCTAssertFalse(presenter.presentGithubUserResponse!.isError)
    }
    
    func testInteractorGetMoreDataWithMaximumPage() {
        // Given
        
        // Set maximumDisplayCurrentPage such that it reaches the maximum
        interactor.currentPage = 4
        
        interactor.isLoadingData = false
        interactor.allUser = self.mockData.github30people
        
        // When
        interactor.interactorGetMoreData()

        // Then
        XCTAssertFalse(presenter.presentGithubUserCalled)
    }
    
    func testInteractorCallApi() {
        // Create an expectation
        let expectation = self.expectation(description: "API call completed")

        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }

        // Trigger the interactor method that makes the API call
        worker.mockData = mockData.github30people
        interactor.interactorCallApi()
        

        // Wait for the expectation to be fulfilled or timeout after a certain duration
        waitForExpectations(timeout: 2) { error in
            if let error = error {
                XCTFail("Test timed out: \(error)")
            } else {
                // Your assertions here
                XCTAssertTrue(self.presenter.presentGithubUserCalled)
            }
        }
    }
    
    func testInteractorCallApiError() {
        // Create an expectation
        let expectation = self.expectation(description: "API call Error")
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        
        let errorMessage1 = "The operation couldn’t be completed"
        
        let userInfo = [NSLocalizedDescriptionKey: "The operation couldn’t be completed"]
        worker.mockError = NSError(domain: "MockErrorDomain", code: 123, userInfo: userInfo)
        worker.mockData = nil
        interactor.interactorCallApi()
       
        // Wait for the expectation to be fulfilled or timeout after a certain duration
        waitForExpectations(timeout: 2) { error in
            if let error = error {
                XCTFail("Test timed out: \(error)")
            } else {
                XCTAssertTrue(self.presenter.presentErrorCalled)
            }
        }
    }
    
    func testWorkerCallAPI() {
        // Arrange
        let expectation = self.expectation(description: "API call completed")
        let mockData = self.mockData.github30people // Replace with your mock data
        
        worker.mockData = mockData
        
        // Act
        worker.getGithubUserData { users, error in
            // Assert
            XCTAssertNil(error)
            XCTAssertNotNil(users)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func testWorkerGetGithubUserDataFailure() {
        // Arrange
        let expectation = self.expectation(description: "API call completed")
        let mockError = NSError(domain: "MockErrorDomain", code: 123, userInfo: nil)
        worker.mockError = mockError
        
        // Act
        worker.getGithubUserData { users, error in
            // Assert
            XCTAssertNotNil(error)
            XCTAssertNil(users)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3, handler: nil)
    }
}

class MockGithubPresenter: GithubPresentationLogic {
    var presentGithubUserCalled = false
    var presentRefreshTableCalled = false
    var presentErrorCalled = false
    
    var refreshTableViewModel: Github.UserIsLiked.ViewModel?
    var presentGithubUserResponse: Github.UserDetail.Response?
    
    func presentGithubUser(response: GIthubListClean.Github.UserDetail.Response) {
        presentGithubUserCalled = true
        presentGithubUserResponse = response
    }
    
    func presentError(response: GIthubListClean.Github.UserDetail.Response) {
        presentErrorCalled = true
    }
    
    func presentRefreshTable(response: Github.UserIsLiked.Response) {
        presentRefreshTableCalled = true
        refreshTableViewModel = Github.UserIsLiked.ViewModel(updateAt: response.updateAt)
    }
}

class MockGithubWorker: GithubWorkerProtocol {
    var mockData: [GitHubUser]?
    var mockError: Error?
    
    func getGithubUserData(completionHandler: @escaping ([GIthubListClean.GitHubUser]?, Error?) -> Void) {
        completionHandler(mockData, mockError)
    }
}

class GitHubMockDataGenerator {
    var allUser: [GitHubUser] = []
    var github30people: [GitHubUser] = []
    
    func setUpGitHubMockData() {
        if let jsonFileURL = Bundle(for: type(of: self)).url(forResource: "GIthubMockData", withExtension: "json") {
            do {
                let data = try Data(contentsOf: jsonFileURL)
                allUser = try JSONDecoder().decode([GitHubUser].self, from: data)
                github30people = Array(repeating: allUser[0], count: 31)
            } catch {
                print("Error loading or decoding JSON data: \(error)")
            }
        } else {
            print("JSON file not found in the test bundle.")
        }
    }
}
