//
//  CustomActivityController.swift
//  StudyWeaklyApp
//
//  Created by Man Singh on 7/30/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit

protocol CustomAlertBtnDelegate: class
{
    func customAlertBtnClick(getAlertTitle: String)
}

class CustomController: NSObject
{
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    weak var delegate: CustomAlertBtnDelegate?
    
    class var customAllMethodClass: CustomController
    {
        struct Static
        {
            static let instance = CustomController()
          }
        return Static.instance
      }
    
    public class func showMessage(message : String)
    {
        let rootViewController: UIViewController = UIApplication.shared.windows[0].rootViewController!
        let Alert = UIAlertController(title: "Studies Weekly", message: (message), preferredStyle: UIAlertControllerStyle.alert)
        
        Alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
        }))
        rootViewController.present(Alert, animated: true, completion: nil)
    }
    
    public func showCustomAlert3(getMesage: String , getView: UIViewController)
    {
        let uiAlert = UIAlertController(title: "Studies Weekly", message: getMesage, preferredStyle: UIAlertControllerStyle.alert)
            print("Click of default button")
         uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            print("Click of default button")
         }))
        getView.present(uiAlert, animated: true, completion: nil)
    }
    
    public func showCustomServerErrorAlert(getMesage: String , getView: UIViewController)
    {
        let uiAlert = UIAlertController(title: "Studies Weekly", message: getMesage, preferredStyle: UIAlertControllerStyle.alert)
        uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            print("Click of default button")
           self.delegate?.customAlertBtnClick(getAlertTitle: "sessionExpired")
        }))
        getView.present(uiAlert, animated: true, completion: nil)
    }
    
     public func showActivityIndicatory(uiView: UIView)
     {
         DispatchQueue.main.async {
            self.loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
            self.loadingView.center = uiView.center
            self.loadingView.backgroundColor = self.UIColorFromRGB(rgbValue: 0x444444,alpha: 0.7)//UIColorFromHex(0x444444, alpha: 0.7).cgColor
            self.loadingView.clipsToBounds = true
            self.loadingView.layer.cornerRadius = 10
        
            self.activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
            self.activityIndicator.center = CGPoint(x: self.loadingView.frame.size.width / 2, y: self.loadingView.frame.size.height / 2)
            
            self.loadingView.addSubview(self.activityIndicator)
            //container.addSubview(loadingView)
            uiView.addSubview(self.loadingView)
            self.activityIndicator.startAnimating()
        }
    }
    
    public  func hideActivityIndicator(uiView: UIView)
    {
        print("show ActivityIndicator remove ")
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.loadingView.removeFromSuperview()
        }
    }

    func UIColorFromRGB(rgbValue: UInt,alpha: Float) -> UIColor
    {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    public class func checkNullString(strToCompare: String) -> String
    {
        if let str = strToCompare as? String {
            var myString: String? = str
            
            if (myString ?? "").isEmpty {
                myString = ""
            }
            return myString!
        }
        return ""
    }
    public class func checkStringNull(strValue: String) -> String
    {
        if !strValue.isEmpty {
            let str = strValue.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            return str
        }
        return ""
    }
    
    class func spaceStrRemovefromStr(getString:String)->String
    {
        let newString = getString.replacingOccurrences(of: " ", with: "%")
        ///let trimmedString = getString.trimmingCharacters(in: .whitespaces)
        return newString
    }
    
    class func backSlaceRemoveFromUrl(urlStr:String)->String
    {
        var newString = (urlStr as NSString).replacingOccurrences(of: "\"/", with: "")
        newString = newString.replacingOccurrences(of: " ", with: "%20")
        return newString
     }
    
class func stringFromHtml(string: String) -> NSAttributedString?
{
        do {
            let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
            if let d = data {
                let str = try NSAttributedString(data: d,
                                                 options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                                                 documentAttributes: nil)
                return str
              }
        } catch {
        }
        return nil
    }
    
    class func htmlTagRemoveFromString(getString:String)->String
    {
//        let str = getString.stringByReplacingOccurrencesOfString("<[^>]+>", withString: "", options: .regularExpression, range: nil)
        //        print(str)
        let str = getString.replacingOccurrences(of: "<[^>]+>", with: "",options: .regularExpression, range: nil)
        //        print(str)
        return str
    }
    
    public class func isValid(Email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: Email)
    }

     func showLoader()->UIActivityIndicatorView
     {
         activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
       // activityIndicator.startAnimating()
        return activityIndicator
    }
    
    func hideLoader()
    {
        activityIndicator.stopAnimating()
    }
}
