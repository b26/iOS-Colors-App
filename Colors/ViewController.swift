//
//  ViewController.swift
//  Colors
//
//  Created by Bashir on 2015-08-24.
//  Copyright © 2015 b26. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var colors:[UIColor] = [UIColor]()
    var hexcode:[String] = [String]()
    var indexPath = NSIndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.generateColors(amount: 250)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.colors.count > 0 {
            return self.colors.count
        }
        else {
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("colorCell", forIndexPath: indexPath) as! ColorCell

        cell.backgroundColor = self.colors[indexPath.row]
        
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.view.frame.height / 2)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.indexPath = indexPath
        let message = self.hexcode[indexPath.row]
        let alert = UIAlertController(title: "Hexcode", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Share", style: UIAlertActionStyle.Default, handler: shareButton))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func shareButton(alert: UIAlertAction!) {
        let hexcode = self.hexcode[self.indexPath.row]
        let colorVC = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/2))
        colorVC.backgroundColor = self.colors[self.indexPath.row]
        self.addLabel(colorVC, hexcode: hexcode)
        let color = saveColor(colorVC)
        let activityVC = UIActivityViewController(activityItems: [hexcode, color], applicationActivities: nil)
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
    
    func addLabel(view: UIView, hexcode: String) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        label.backgroundColor = UIColor.blackColor()
        label.textColor = UIColor.whiteColor()
        label.text = hexcode
        label.sizeToFit()
        view.addSubview(label)
    }
    
    func saveColor(view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, view.opaque, UIScreen.mainScreen().scale)
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
    func randomNumber() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX))
    }
    
    func generateColors(amount amount: Int) {
        for _ in 0..<amount {
            self.makeColor()
        }
        
        self.collectionView.reloadData()
    }
    
    func makeColor() {
        let red = randomNumber()
        let green = randomNumber()
        let blue = randomNumber()
        let backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
        self.hexcode.append(hexy(color: backgroundColor))
        self.colors.append(backgroundColor)
    }
    
    func hexy(color color: UIColor) -> String {
        let components = CGColorGetComponents(color.CGColor)
        var hex = ""
        for i in 0...2 {
            let int = Int(components[i] * 255)
            let hexcode = String(int, radix: 16)
            if hexcode.characters.count < 2 {
                hex = hex + "0\(hexcode)"
            }
            else {
                hex = hex + hexcode
            }
        }
        return "#\(hex)"
    }
}

