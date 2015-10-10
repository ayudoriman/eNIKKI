//
//  PhotoViewController.swift
//  eNIKKI
//
//  Created by KFCC on 2015/09/27.
//  Copyright © 2015年 KFCC. All rights reserved.
//

import UIKit
import Photos

//ステップ１
@objc protocol PhotoViewControllerDelegate {
    func didSelectImage(image: PHAsset)
}


class PhotoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var photoAssets = [PHAsset]()

    @IBOutlet var photoCollectionView: UICollectionView!
    
    //ステップ２
    weak var delegate: PhotoViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark))
        visualEffectView.frame = self.view.bounds
        self.view.backgroundColor = UIColor.clearColor()
        self.view.addSubview(visualEffectView)
        self.view.sendSubviewToBack(visualEffectView)
        
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
        photoCollectionView.allowsMultipleSelection = true
        
        reload()
        photoCollectionView.registerNib(UINib(nibName: "PhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoAssets.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: PhotoCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! PhotoCollectionViewCell
        
        let selectedView = UIView(frame: cell.frame)
        selectedView.backgroundColor = UIColor.grayColor()
        cell.selectedBackgroundView = selectedView
        
        let asset = photoAssets[indexPath.row]
        let imageView = cell.PhotoCell
        
        let manager: PHImageManager = PHImageManager()
        manager.requestImageForAsset(asset,
            targetSize: imageView.frame.size,
            contentMode: .AspectFill,
            options: nil) { (image, info) -> Void in
                imageView.image = image
        }
        return cell
    }
    
    private func reload() {
        getAllPhotosInfo()
        photoCollectionView.reloadData()
    }
    
    
    private func getAllPhotosInfo() {
        photoAssets = []
        
        let date = NSDate()
        let changedate: NSDateFormatter = NSDateFormatter()
        changedate.dateFormat = "yyy-MM-dd 00:00:00"
        let newdate1 = changedate.stringFromDate(date)
        
        let changedate2: NSDateFormatter = NSDateFormatter()
        changedate2.dateFormat = "yyy-MM-dd HH:mm:ss"
        
        let newdate2 = changedate2.dateFromString(newdate1)!
        
        print(date)
        
        
        let options = PHFetchOptions()
        //options.predicate = NSPredicate(format: "creationDate > %@", newdate2)
        
        options.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        
        let assets: PHFetchResult = PHAsset.fetchAssetsWithMediaType(.Image, options: options)
        assets.enumerateObjectsUsingBlock { (asset, index, stop) -> Void in
            self.photoAssets.append(asset as! PHAsset)
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        NSLog("%@が選択されました", photoAssets[indexPath.row])
        let image: PHAsset = photoAssets[indexPath.row]
        let cell: PhotoCollectionViewCell = collectionView.cellForItemAtIndexPath(indexPath) as! PhotoCollectionViewCell
        // performSegueWithIdentifier("PushToResultViewController",sender: image)
        
        //ステップ３
        self.delegate?.didSelectImage(image)
        
        dismissViewControllerAnimated(true, completion: nil)
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


