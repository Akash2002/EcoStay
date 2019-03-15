//
//  AdminOpeningViewController.swift
//  EcoTourism
//
//  Created by Akash  Veerappan on 3/15/19.
//  Copyright © 2019 Akash Veerappan. All rights reserved.
//

import UIKit

class AdminOpeningViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func onLogoutClicked(_ sender: Any) {
        var storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let StoryBoardViewController: UIViewController = storyBoard.instantiateViewController(withIdentifier: "LoginController")
        self.present(StoryBoardViewController, animated: true, completion: nil)
    }
    

}
