//
//  ViewController.swift
//  eNIKKI
//
//  Created by KFCC on 2015/09/27.
//  Copyright (c) 2015年 KFCC. All rights reserved.
//

import UIKit
import Photos
import Foundation

//ステップ４
class ViewController: UIViewController, UIImagePickerControllerDelegate,
                        UINavigationControllerDelegate, PhotoViewControllerDelegate {
    
    var imagePickerController: UIImagePickerController = UIImagePickerController()
    var photoAsset: PHAsset?
    
    let saveData: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    let saveNumber: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var imgNumber: Int!
    
    let maxLength = 50
    var previousText = ""
    
    var lastReplaceRange: NSRange?
    var lastReplacementString = ""
    
    var imgData: NSData!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addScroll: UIScrollView!
    @IBOutlet weak var eNIKKItext: UITextView!
    // for test
    @IBOutlet weak var testView: UIImageView!
    @IBOutlet weak var testNumber: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
        
        imgNumber = saveNumber.objectForKey("Number") as? Int
        
        if imgNumber == nil {
            imgNumber = 0
        }else{
            testNumber.text = String(imgNumber)
            imgData = saveData.objectForKey("History\(imgNumber)") as! NSData
            testView.image = UIImage(data: imgData)
        }
        print(imgNumber)
        
        addScroll.contentOffset.y = 0
    }
    
    override func viewWillAppear(animated: Bool) {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "handleKeyboardWillShowNotification:",
            name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "handleKeyboardWillHideNotification:",
            name: UIKeyboardWillHideNotification, object: nil)
        addScroll.contentOffset.y = 0
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        let PhotoViewControllerModal = PhotoViewController()
        PhotoViewControllerModal.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        addScroll.contentOffset.y = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange,
        replacementText text: String) ->Bool{
        self.previousText = eNIKKItext.text
        self.lastReplaceRange = range
        self.lastReplacementString = text
        
        return true
    }
    
//    func textViewDidChange(textView:UITextView) {
//        if eNIKKItext.markedTextRange != nil {
//            return
//        }
//        
//        if String(eNIKKItext).characters.count > maxLength {
//            var offset = maxLength - String(eNIKKItext).characters.count
//            var replacementString = (lastReplacementString as NSString).substringToIndex(String(lastReplacementString).characters.count + offset)
//            var text = (previousText as NSString).stringByReplacingCharactersInRange(lastReplacementString, withString: replacementString)
//            var position = textView.positionFromPosition(eNIKKItext.selectedTextRange!.start
//                , offset: position)
//            var selectedTextRange = eNIKKItext.textRangeFromPosition(position, toPosition: position)
//            
//            eNIKKItext.text = text
//            eNIKKItext.selectedTextRange = selectedTextRange
//        }
//    }
    
    func handleKeyboardWillShowNotification(notification: NSNotification) {
        let userInfo = notification.userInfo!
    //キーボードの大きさを取得
        let keyboardRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
    // 画面のサイズを取得
        let myBoundSize: CGSize = UIScreen.mainScreen().bounds.size
    //　ViewControllerを基準にtextFieldの下辺までの距離を取得
        let txtLimit = eNIKKItext.frame.origin.y + eNIKKItext.frame.height + 8.0
    // ViewControllerの高さからキーボードの高さを引いた差分を取得
        let kbdLimit = myBoundSize.height - keyboardRect.size.height
    // こうすることで高さを確認できる（なくてもいい）
        print("テキストフィールドの下辺：(\(txtLimit))")
        print("キーボードの上辺：(\(kbdLimit))")
    //スクロールビューの移動距離設定
        if txtLimit >= kbdLimit {
            addScroll.contentOffset.y = txtLimit - kbdLimit
        }
    }
    
    func handleKeyboardWillHideNotification(notification: NSNotification) {
        addScroll.contentOffset.y = 0
    }
    
    @IBAction func tapScreen(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func photo(){
        imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePickerController.allowsEditing = true
        self.presentViewController(imagePickerController,animated: true, completion: nil)
    }
    
    @IBAction func saveeNIKKI(){
        saveData.setObject(eNIKKItext.text, forKey: "eNIKKI")
        saveData.synchronize()
        
        let rect: CGRect = CGRectMake(0, 30, 320, 500)
        UIGraphicsBeginImageContext(rect.size)
        self.view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        
        let capture = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        UIImageWriteToSavedPhotosAlbum(capture, nil, nil, nil)
        print(capture)
        
        imgData = UIImageJPEGRepresentation(capture, 1.0)!
        saveData.setObject(imgData, forKey: "History\(imgNumber)")
        saveNumber.setObject(imgNumber, forKey: "Number")
        
        imgNumber = imgNumber+1
        
        saveNumber.synchronize()
        saveData.synchronize()
        
        print("番号は\(imgNumber)")
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image: UIImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        imageView.image = image
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let photoViewController = segue.destinationViewController as! PhotoViewController
        
        //ステップ５
        photoViewController.delegate = self
    }

    //ステップ６
    func didSelectImage(image: PHAsset) {
        photoAsset = image
        let manager: PHImageManager = PHImageManager()
        manager.requestImageForAsset(photoAsset!,
            targetSize: imageView.frame.size,
            contentMode: .AspectFill,
            options: nil) { (image, info) -> Void in
                self.imageView.image = image
        }
    }
}

