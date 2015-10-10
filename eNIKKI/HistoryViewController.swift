//
//  HistoryViewController.swift
//  eNIKKI
//
//  Created by KFCC on 2015/10/10.
//  Copyright © 2015年 KFCC. All rights reserved.
//

import UIKit


class HistoryViewController: UIViewController {
    
    let saveData: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    let saveNumber: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var imgData: NSData!
    var imgNumber: Int!
    var HistoryNumber: Int!
    
    @IBOutlet var HistoryImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            imgNumber = saveNumber.objectForKey("Number") as? Int
        
        if imgNumber == nil {
            imgNumber = 0
            HistoryNumber = 0
        }else{
            imgData = saveData.objectForKey("History\(imgNumber)") as! NSData
            HistoryNumber = imgNumber
            HistoryImg.image = UIImage(data: imgData)
            
            addSwipeRecognizer()
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addSwipeRecognizer() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: "swiped:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: "swiped:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        
        self.view.addGestureRecognizer(swipeLeft)
        self.view.addGestureRecognizer(swipeRight)
    }
    
    func swiped(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Left:
                // 左
                print("left")
                if HistoryNumber >= 1 {
                    HistoryNumber = HistoryNumber - 1
                    imgData = saveData.objectForKey("History\(HistoryNumber)") as! NSData
                    HistoryImg.image = UIImage(data: imgData)
                    print(HistoryNumber)
                }else{
                    print("これ以下は存在しません")
                }
            case UISwipeGestureRecognizerDirection.Right:
                // 右
                print("right")
                if HistoryNumber < imgNumber {
                    HistoryNumber = HistoryNumber + 1
                    imgData = saveData.objectForKey("History\(HistoryNumber)") as! NSData
                    HistoryImg.image = UIImage(data: imgData)
                    print(HistoryNumber)
                    }
                if HistoryNumber >= imgNumber {
                    print("これ以上は存在しません")
                    }
            default:
                // その他
                print("other")
                break
            }
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
