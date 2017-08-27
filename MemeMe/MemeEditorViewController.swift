//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Marwa Abou Niaaj on 3/26/17.
//  Copyright © 2017 Marwa Abou Niaaj. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController,
                                UIImagePickerControllerDelegate,
                                UINavigationControllerDelegate {
    
    // MARK: Outlets
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var imagePicker: UIImageView!
    @IBOutlet weak var startLabel: UILabel!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    
    @IBOutlet weak var navbar: UINavigationBar!
    @IBOutlet weak var toolbar: UIToolbar!
    
    var meme: Meme!
    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    let memeTextAttributes: [String: Any] = [
        NSStrokeWidthAttributeName : -3.0,
        NSStrokeColorAttributeName : UIColor.black,
        NSForegroundColorAttributeName : UIColor.white,
        NSFontAttributeName : UIFont(name: "Impact", size: 40)!,
        NSParagraphStyleAttributeName: NSParagraphStyle.default
    ]
        // MARK: Overridable Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextFieldsAttributes(topTextField)
        setTextFieldsAttributes(bottomTextField)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let meme = meme {
            imagePicker.image = meme.image
            topTextField.text = meme.top
            bottomTextField.text = meme.bottom
        }
        
        if imagePicker.image == nil {
            memeControlles(hide: true)
        }
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        shareButton.isEnabled = imagePicker.image != nil ? true : false
        cancelButton.isEnabled = memes.count > 0 ? true : false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    //MARK: Actions
    
    @IBAction func pickImage(_ sender: AnyObject) {
        
        if let photoButton = sender as? UIBarButtonItem {
            
            if photoButton.tag == 0 {
                pickImage(from: .camera)
            }
            else {
                pickImage(from: .photoLibrary)
            }
        }
    }
    
    @IBAction func shareImage(_ sender: AnyObject) {
        
        let memedImage = generatedMemeImage()
        let shareController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        self.present(shareController, animated: true, completion: nil)
        shareController.completionWithItemsHandler = { (_, successful, _, _) in
            if (successful) {
                self.save(memedImage: memedImage)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func cancelImage(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: Image Picker Controller Delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePicker.image = image
            memeControlles(hide: false)
            dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Meme Image
    
    // Create a meme object and add it to the memes array
    func save(memedImage: UIImage) {
        
        //Create the meme
        let meme = Meme(top: topTextField.text!, bottom: bottomTextField.text!, image: imagePicker.image!, memedImage: memedImage)
        
        // Add it to the memes array in the Application Delegate
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
    }
    
    // Create a UIImage that combines the ImageView and the Labels
    func generatedMemeImage() -> UIImage {
        
        if let image = imagePicker.image {
            
            // aspect ratio for original image height
            let aspectRatio: CGFloat! = image.size.height/imagePicker.frame.size.height
            
            let paraStyle = NSMutableParagraphStyle()
            paraStyle.alignment = NSTextAlignment.center
            
            var textAttributes = memeTextAttributes
            
            // Change the font size to match the original image size
            textAttributes.updateValue(UIFont(name: "Impact", size: 40 * aspectRatio)!, forKey: "NSFont")
            textAttributes.updateValue(paraStyle, forKey: "NSParagraphStyle")
            
            UIGraphicsBeginImageContext(image.size)
            image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
            
            
            // Align the text to the center, and draw it on the image
            topTextField.textAlignment = NSTextAlignment.center
            bottomTextField.textAlignment = NSTextAlignment.center
            
            let topX = topTextField.frame.origin.x
            let topY = (topTextField.frame.origin.y - topTextField.frame.size.height) * aspectRatio

            let bottomX = bottomTextField.frame.origin.x
            let bottomY = (bottomTextField.frame.origin.y -
                (bottomTextField.frame.size.height)) * aspectRatio
            
            let topTextRect = CGRect(origin: CGPoint(x: topX, y: topY), size: image.size)
            let bottomTextRect = CGRect(origin: CGPoint(x: bottomX, y: bottomY), size: image.size)

            topTextField.text?.draw(in: topTextRect, withAttributes: textAttributes)
            bottomTextField.text?.draw(in: bottomTextRect, withAttributes: textAttributes)
        }
        
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return memedImage
    }
    
    //MARK: Keyboard Notifications
    
    func subscibeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscibeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func keyboardWillShow(notification: Notification) {
        
        self.view.frame.origin.y = -getKeyboardHeight(notification: notification)
    }
    
    func keyboardWillHide(notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue //CGRect
        return keyboardSize.cgRectValue.height
    }
    
    //Mark: Helper Methods
    
    func pickImage(from source: UIImagePickerControllerSourceType) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = source
        self.present(pickerController, animated: true, completion: nil)
    }
    
    func memeControlles(hide flag: Bool) {
        self.topTextField.isHidden = flag
        self.bottomTextField.isHidden = flag
        self.imagePicker.isHidden = flag
        self.startLabel.isHidden = !flag
    }
    
    func setTextFieldsAttributes(_ textField: UITextField) {
        
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.delegate = self
    }

}

//MARK: TextField Delegate

extension MemeEditorViewController : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if imagePicker.image == nil {
            return false
        }
        
        if textField == bottomTextField {
            self.subscibeToKeyboardNotifications()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if textField == bottomTextField {
            self.unsubscibeFromKeyboardNotifications()
        }
        
        return true
    }

}








