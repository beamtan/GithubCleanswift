//
//  ViewController.swift
//  GIthubListClean
//
//  Created by A667243 A667243 on 8/9/2566 BE.
//

import Foundation
import UIKit

//push
//let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//self.present(loginVC, animated: true, completion: nil)


//present
//let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//self.navigationController?.pushViewController(loginVC, animated: true)

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hello world")
    }
    
    @IBAction func changeScene(_ sender: UIButton) {
//        // Load the "Github" storyboard
//        let storyboard = UIStoryboard(name: "Github", bundle: nil)
//
//        if let githubViewController = storyboard.instantiateViewController(withIdentifier: "GithubViewController") as? GithubViewController {
//            // Create a UINavigationController and set your view controller as its root
//            let navigationController = UINavigationController(rootViewController: githubViewController)
//
//            if let existingNavController = self.navigationController {
//                // Push the navigation controller onto the navigation stack if self has a navigation controller
//                existingNavController.pushViewController(githubViewController, animated: true)
//            } else {
//                // Otherwise, present the navigation controller modally
//                self.present(navigationController, animated: true, completion: nil)
//            }
//        } else {
//            // Handle any errors or issues with the storyboard or view controller instantiation
//            print("Failed to instantiate GithubViewController from storyboard")
//        }
        
        let storyboard = UIStoryboard(name: "Github", bundle: nil)
        
        if let githubViewController = storyboard.instantiateViewController(withIdentifier: "GithubViewController") as? GithubViewController {
            // Create a UINavigationController
            let navigationController = UINavigationController(rootViewController: githubViewController)
            
            // Set the navigation controller as the root view controller of the window
            UIApplication.shared.windows.first?.rootViewController = navigationController
            
            print("Pushed")
        } else {
            // Handle any errors or issues with the storyboard or view controller instantiation
            print("Failed to instantiate GithubViewController from storyboard")
        }
    }
    
}
