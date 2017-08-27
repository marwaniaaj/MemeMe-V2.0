//
//  MemeCollectionViewCell.swift
//  MemeMe
//
//  Created by Marwa Abou Niaaj on 3/30/17.
//  Copyright © 2017 Marwa Abou Niaaj. All rights reserved.
//

import UIKit

class MemeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    func setText(top: String, bottom:String) {
        self.topLabel.attributedText = setLabelAttributedText(for: top)
        self.bottomLabel.attributedText = setLabelAttributedText(for: bottom)
    }
    
    func setLabelAttributedText(for text: String) -> NSAttributedString {
        
        let stringAttributed = NSMutableAttributedString.init(string: text)
        
        stringAttributed.addAttribute(NSStrokeColorAttributeName, value: UIColor.black, range: NSRange.init(location: 0, length: stringAttributed.length))
        stringAttributed.addAttribute(NSStrokeWidthAttributeName, value: -3.0, range: NSRange.init(location: 0, length: stringAttributed.length))
        
        return stringAttributed
    }

}
