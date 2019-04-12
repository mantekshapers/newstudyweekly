//
//  CustomCircularClass.swift
//  StudyWeaklyApp
//
//  Created by Man Singh on 7/31/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//
import UIKit
import Foundation

class circularImage
{
    class func isCircularImg(imgView: UIImageView)->UIImageView
    {
        imgView.layer.cornerRadius = imgView.frame.size.width/2
        imgView.backgroundColor = CustomBGColor.profileBGColor
        return imgView
     }
 }
