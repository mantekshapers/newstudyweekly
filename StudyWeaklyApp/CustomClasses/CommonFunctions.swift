//
//  CommonFunctions.swift
//  StudiesWeekly
//
//  Created by Abha Parihar on 3/20/19.
//  Copyright © 2019 TekShapers. All rights reserved.
//

import UIKit

let _sharedCommonFns = CommonFunctions()

class CommonFunctions: NSObject
{
    class var sharedInstance : CommonFunctions
    {
        return _sharedCommonFns
    }

    //MARK: - Open And Close Left Menu
    public class func openMenu(view: UIView)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //bgView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.4)
        view.frame = CGRect(x: appDelegate.window!.frame.size.width-view.frame.size.width, y: 60, width: view.frame.size.width, height: view.frame.size.height)
        UIView.commitAnimations()
    }
    
    public class func closeMenu(view: UIView)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //bgView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.4)
        view.frame = CGRect(x: appDelegate.window!.frame.size.width-view.frame.size.width, y: (appDelegate.window?.frame.origin.y)!-view.frame.size.height, width: view.frame.size.width, height: view.frame.size.height)
        UIView.commitAnimations()
    }
    
    public class func btnBackClicked(_ sender: UIButton)
    {
       // self.navigatio
    }
    
    public class func btnNextClicked(_ sender: UIButton)
    {
    }

    public class func btnCopyClicked(_ sender: UIButton)
    {
    }

    public class func btnSearchClicked(_ sender: UIButton)
    {
    }

    public class func btnPlayClicked(_ sender: UIButton)
    {
    }

}
