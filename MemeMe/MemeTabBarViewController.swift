//
//  MemeTabBarViewController.swift
//  MemeMe
//
//  Created by Marwa Abou Niaaj on 4/3/17.
//  Copyright © 2017 Marwa Abou Niaaj. All rights reserved.
//

import UIKit

class MemeTabBarViewController: UITabBarController {

    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if memes.count == 0 {
            DispatchQueue.main.async(execute: {
                self.performSegue(withIdentifier: "initialSegue", sender: self)
            })
        }
    }
}
