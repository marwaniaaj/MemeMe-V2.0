//
//  Meme.swift
//  MemeMe
//
//  Created by Marwa Abou Niaaj on 3/26/17.
//  Copyright © 2017 Marwa Abou Niaaj. All rights reserved.
//

import Foundation
import UIKit

// MARK: Meme

struct Meme {
    
    // MARK: Properties
    var top: String = ""
    var bottom: String = ""
    var title: String = ""
    var image: UIImage? = nil
    var memedImage: UIImage? = nil
    
    // MARK: Initializer
    init(top: String, bottom: String, image: UIImage, memedImage: UIImage) {
        self.top = top
        self.bottom = bottom
        self.title = top + " ... " + bottom
        self.image = image
        self.memedImage = memedImage
    }
    
}
