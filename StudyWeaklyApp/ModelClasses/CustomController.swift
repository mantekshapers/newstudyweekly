//
//  CustomActivityController.swift
//  StudyWeaklyApp
//
//  Created by Man Singh on 7/30/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit

protocol CustomAlertBtnDelegate: class {
    func customAlertBtnClick()
}
class CustomController: NSObject{
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
      // MARK:  Here is code for alert3
    weak var delegate: CustomAlertBtnDelegate?
    class var customAllMethodClass: CustomController {
        struct Static {
            static let instance = CustomController()
        }
        return Static.instance
      }
    public func showCustomAlert3(getMesage: String , getView: UIViewController){
        let uiAlert = UIAlertController(title: "Alert", message: getMesage, preferredStyle: UIAlertControllerStyle.alert)
          uiAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
            print("Click of default button")
            //self.delegate?.customAlertBtnClick()
          }))
        
         uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            print("Click of default button")
            
            self.delegate?.customAlertBtnClick()
            
         }))
        getView.present(uiAlert, animated: true, completion: nil)
        }
    
     public func showActivityIndicatory(uiView: UIView) {
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColorFromRGB(rgbValue: 0x444444,alpha: 0.7)//UIColorFromHex(0x444444, alpha: 0.7).cgColor
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        DispatchQueue.main.async {
            self.loadingView.addSubview(self.activityIndicator)
            //container.addSubview(loadingView)
            uiView.addSubview(self.loadingView)
            self.activityIndicator.startAnimating()
         }
         }
     public  func hideActivityIndicator(uiView: UIView) {
        print("show ActivityIndicator remove ")
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.loadingView.removeFromSuperview()
            }
         }
    func UIColorFromRGB(rgbValue: UInt,alpha: Float) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}