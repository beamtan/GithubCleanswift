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
    var allUser: [GitHubUser] = []
    var github30people: [GitHubUser] = []
    
    override func setUp() {
        super.setUp()
        interactor = GithubInteractor()
        presenter = MockGithubPresenter()
        interactor.presenter = presenter
        setUpGitHubMockData()
    }
    
    func setUpGitHubMockData() {
        allUser = [
            GitHubUser(
                login: "mojombo",
                id: 1,
                nodeId: "MDQ6VXNlcjE=",
                avatarUrl: "https://avatars.githubusercontent.com/u/1?v=4",
                gravatarId: "",
                url: "https://api.github.com/users/mojombo",
                htmlUrl: "https://github.com/mojombo",
                followersUrl: "https://api.github.com/users/mojombo/followers",
                followingUrl: "https://api.github.com/users/mojombo/following{/other_user}",
                gistsUrl: "https://api.github.com/users/mojombo/gists{/gist_id}",
                starredUrl: "https://api.github.com/users/mojombo/starred{/owner}{/repo}",                subscriptionsUrl: "https://api.github.com/users/mojombo/subscriptions",
                organizationsUrl: "https://api.github.com/users/mojombo/orgs",
                reposUrl: "https://api.github.com/users/mojombo/repos",
                eventsUrl: "https://api.github.com/users/mojombo/events{/privacy}",
                receivedEventsUrl: "https://api.github.com/users/mojombo/received_events",
                type: "User",
                siteAdmin: false,
                isLiked: false
            ),
            GitHubUser(
                login: "mojombo2",
                id: 2,
                nodeId: "MDQ6VXNlcjE=",
                avatarUrl: "https://avatars.githubusercontent.com/u/1?v=4",
                gravatarId: "",
                url: "https://api.github.com/users/mojombo",
                htmlUrl: "https://github.com/mojombo",
                followersUrl: "https://api.github.com/users/mojombo/followers",
                followingUrl: "https://api.github.com/users/mojombo/following{/other_user}",
                gistsUrl: "https://api.github.com/users/mojombo/gists{/gist_id}",
                starredUrl: "https://api.github.com/users/mojombo/starred{/owner}{/repo}",                subscriptionsUrl: "https://api.github.com/users/mojombo/subscriptions",
                organizationsUrl: "https://api.github.com/users/mojombo/orgs",
                reposUrl: "https://api.github.com/users/mojombo/repos",
                eventsUrl: "https://api.github.com/users/mojombo/events{/privacy}",
                receivedEventsUrl: "https://api.github.com/users/mojombo/received_events",
                type: "User",
                siteAdmin: false,
                isLiked: false
            )
        ]
        for _ in 0...30 {
            github30people.append(allUser[0])
        }
    }
    
    override func tearDown() {
        interactor = nil
        presenter = nil
        super.tearDown()
    }
    
    
    func testInteractorLikeUserUnlikedToLiked() {
        // Given
        let row = 0 // Index of the user to be toggled from unliked to liked
        let request = Github.UserIsLiked.Request(updateAt: row)
        interactor.allUser = self.allUser
        
        // When
        interactor.interactorLikeUser(request: request)
        
        // Then
        XCTAssertTrue(presenter.presentRefreshTableCalled)
        XCTAssertEqual(presenter.refreshTableViewModel?.updateAt, row)
        XCTAssertTrue(interactor.allUser[row].isLiked)
    }
    
//    func testInteractorGetMoreDataWithValidPage() {
//        // Given
//        interactor.currentPage = 1 // Set the current page
//        interactor.isLoadingData = false // Set isLoadingData to false
//        let totalUser = allUser.count - 1
//
//        // When
//        interactor.interactorGetMoreData()
//
//        // Then
//        XCTAssertTrue(presenter.presentGithubUserCalled)
//        XCTAssertFalse(interactor.isLoadingData)
//        XCTAssertEqual(interactor.currentPage, 2) // Check if currentPage is incremented
//        // Add more assertions based on your logic
//    }

    func testInteractorGetMoreData() {
        // Given
        interactor.currentPage = 1 // Set the current page
        interactor.isLoadingData = false // Set isLoadingData to false
        interactor.allUser = self.github30people
        
        // Set maximumDisplayCurrentPage such that it reaches the maximum
        let maximumDisplayCurrentPage = self.github30people.count - 1
        let presentUser = Array(self.github30people.prefix(maximumDisplayCurrentPage))

        // When
        interactor.interactorGetMoreData()

        // Then
        XCTAssertTrue(presenter.presentGithubUserCalled)
        XCTAssertEqual(presenter.presentGithubUserResponse!.githubUser?.count, 20)
        XCTAssertFalse(presenter.presentGithubUserResponse!.isError)
    }
    
    func testInteractorGetMoreDataWithMaximumPage() {
        // Given
        interactor.currentPage = 4 // Set the current page
        interactor.isLoadingData = false // Set isLoadingData to false
        interactor.allUser = self.github30people
        
        // Set maximumDisplayCurrentPage such that it reaches the maximum
        let maximumDisplayCurrentPage = self.github30people.count - 1

        // When
        interactor.interactorGetMoreData()

        // Then
        XCTAssertFalse(presenter.presentGithubUserCalled)

//        XCTAssertFalse(interactor.isLoadingData)
//        XCTAssertEqual(interactor.currentPage, ) // Check if currentPage remains the same
//        XCTAssertEqual(maximumDisplayCurrentPage, totalUser)
        // Add more assertions based on your logic
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
