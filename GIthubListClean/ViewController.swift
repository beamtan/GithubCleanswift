//
//  ViewController.swift
//  GIthubListClean
//
//  Created by A667243 A667243 on 8/9/2566 BE.
//

import Foundation
import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func changeScene(_ sender: UIButton) {
//        presentView()
        pushView()
    }
    
    func presentView() {
        let storyboard = UIStoryboard(name: "Github", bundle: nil)
        let myViewController = storyboard.instantiateViewController(withIdentifier: "GithubViewController")
        let myNavigationController = UINavigationController(rootViewController: myViewController)
        myNavigationController.modalTransitionStyle = .crossDissolve
        myNavigationController.modalPresentationStyle = .overFullScreen
        self.present(myNavigationController, animated: true) {
        }
    }
    
    func pushView() {
        let storyboard = UIStoryboard(name: "Github", bundle: nil)
        if let githubViewController = storyboard.instantiateViewController(withIdentifier: "GithubViewController") as? GithubViewController {
            self.navigationController?.pushViewController(githubViewController, animated: true)
        } else {
            // Handle the case where the view controller couldn't be instantiated
            print("Failed to instantiate GithubViewController from storyboard")
        }
    }
}
