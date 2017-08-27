//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Marwa Abou Niaaj on 3/30/17.
//  Copyright © 2017 Marwa Abou Niaaj. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    var meme: Meme!
    
    // MARK: Outlets
    
    @IBOutlet weak var imagePicker: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editMeme))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let meme = meme {
            self.imagePicker.image = meme.memedImage
        }
    }
    
    func editMeme(_ sender: UIBarButtonItem) {
        
        let memeEditorVC = storyboard?.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        
        memeEditorVC.meme = meme
        navigationController?.showDetailViewController(memeEditorVC, sender: self)
    }
}




