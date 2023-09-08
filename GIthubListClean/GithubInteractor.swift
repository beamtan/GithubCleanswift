//
//  GithubInteractor.swift
//  GIthubListClean
//
//  Created by A667243 A667243 on 30/8/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol GithubBusinessLogic {
    func interactorCallApi()
    func interactorGetMoreData()
    func interactorLikeUser(request: Github.UserIsLiked.Request)
}

protocol GithubDataStore {
    //var name: String { get set }
}

class GithubInteractor: GithubBusinessLogic, GithubDataStore {
    
    var presenter: GithubPresentationLogic?
    var worker: GithubWorkerProtocol?
    
    var allUser: [GitHubUser] = []
    var isLoadingData: Bool = false
    var currentPage: Int = 1
    
    let defaults = UserDefaults.standard
    let likeUserIDForUserDefault = "LikedUserIDs"
    
    // MARK: Do something
    
    func interactorCallApi() {
        worker?.getGithubUserData() { [weak self] user, error  in
            var response: Github.UserDetail.Response
            if let allUser = user {
                
                self?.allUser = allUser

                let listOfLikedUsers = self!.defaults.stringArray(forKey: self!.likeUserIDForUserDefault) ?? []
                for user in 0...allUser.count - 1 {
                    if let userNodeID = allUser[user].nodeID, listOfLikedUsers.contains(userNodeID) {
                        self!.allUser[user].isLiked = true
                    }
                }
        
                response = Github.UserDetail.Response(
                    githubUser: Array(self?.allUser.prefix(10) ?? []),
                    isError: false,
                    errorMessage: ""
                )
                self?.presenter?.presentGithubUser(response: response)
            } else {
                response = Github.UserDetail.Response(
                    githubUser: [],
                    isError: true,
                    errorMessage: error!.localizedDescription
                )
                print("errorMessages!!!", response.errorMessage)
                self?.presenter?.presentError(response: response)
            }
        }
    }
    
    func interactorGetMoreData() {
        
        let totalUser: Int = self.allUser.count - 1
        
        if !isLoadingData {
            isLoadingData = true
            
            currentPage += 1
            var maximumDisplayCurrentPage = currentPage * 10
            print(currentPage * 10, maximumDisplayCurrentPage)
            
            if maximumDisplayCurrentPage >= totalUser {
                maximumDisplayCurrentPage = totalUser
                print("reach maximum")
                return
            }
            
            let presentUser = Array(self.allUser.prefix(maximumDisplayCurrentPage))
            let response = Github.UserDetail.Response(
                githubUser: presentUser,
                isError: false,
                errorMessage: ""
            )
            
            self.presenter?.presentGithubUser(response: response)
            isLoadingData = false
        }
    }
    
    func interactorLikeUser(request: Github.UserIsLiked.Request) {
        let row = request.updateAt
        let listOfLikedUsers = defaults.stringArray(forKey: likeUserIDForUserDefault) ?? []
        let UUID = allUser[row].nodeID!
        
        switch request.reaction {
        case .like:
            saveToLocalLikeUser(list: listOfLikedUsers, id: UUID)
        case .unlike:
            unsaveToLocalUser(list: listOfLikedUsers, id: UUID)
        }
        allUser[row].isLiked = !allUser[row].isLiked
        
        let response = Github.UserIsLiked.Response(
            updateAt: row
        )
        presenter?.presentRefreshTable(response: response)
    }
    
    func saveToLocalLikeUser(list listOfLikedUsers: Array<String>, id: String) {
        let uniqueLikedUsers: [String] = Array(Set(listOfLikedUsers + [id]))
        defaults.set(uniqueLikedUsers, forKey: likeUserIDForUserDefault)
    }
    
    func unsaveToLocalUser(list listOfLikedUsers: Array<String>, id: String) {
        var tempList = listOfLikedUsers
        tempList.removeAll { $0 == id }
        defaults.set(tempList, forKey: likeUserIDForUserDefault)
    }
    
    func getLikeDataFromUserDefault(_ listOfLikeUsers: Array<String>, githubUsers: inout [GitHubUser]) {
        for i in githubUsers.indices {
            if listOfLikeUsers.contains(githubUsers[i].nodeID!) {
                githubUsers[i].isLiked = true
            }
        }
    }
}
