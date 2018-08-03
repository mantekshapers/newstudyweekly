//
//  ViewController.swift
//  StudyWeaklyApp
//
//  Created by Man Singh on 7/12/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit
//import Alamofire
//import SwiftHash
//import CommonCrypto
import Realm
import Retrolux

class ViewController: UIViewController,UITextFieldDelegate,URLSessionDelegate,URLSessionDataDelegate,CustomAlertBtnDelegate{
    
    
     let customAlertController = CustomController()
    @IBOutlet weak var login_txtField: CustomTextField!
    
    @IBOutlet weak var password_txtField: CustomTextField!
    
    @IBOutlet weak var loginBtn_outlet: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view, typically from a nib.
        login_txtField.delegate = self
        password_txtField.delegate = self
        loginBtn_outlet.backgroundColor = CustomBGBorderBtn.btnBgColor()
        
          }
    
    @IBAction func loginBtnClick(_ sender: Any) {
        
        
       // rxVtdUT6vr82wf9jwowj9fw28rv6TUdtVxr
       // rxVtdUT6vr82wf9jwowj9fw28rv6TUdtVxr
        if login_txtField.text == "" {
            self.customAlertController.showCustomAlert3(getMesage: AlertTitle.loginTextStr, getView: self)
            return
        }else if password_txtField.text == ""{
            self.customAlertController.showCustomAlert3(getMesage: AlertTitle.passwordTextStr, getView: self)
            return
           }
        NetworkCheckReachbility.isConnectedToNetwork { (boolTrue) in
            if boolTrue == false{
                 return
                }else{
                 self.customAlertController.showActivityIndicatory(uiView: self.view)
                  let parameters = LoginParameters(username:Field("ron1234"),password: Field("1195643"))
                   NetworkAPI.login(parameters).enqueue { [weak self] response in
                    guard let me = self else {
                        self?.customAlertController.hideActivityIndicator(uiView: (self?.view)!)
                        return
                         }
                      self?.customAlertController.hideActivityIndicator(uiView: (self?.view)!)
                     switch response.interpreted {
                     case .success(let value):
                         NetworkAPI.setLoginCookie(using: response)
                        guard let userID = value.success?.user_id else {
                            return
                         }
                        print("success \(userID) && \(value.success?.role ?? "")")
                        NetworkAPI.setUserID(userID)
                        
//                        DataManager.getUser(withID: userID, password: "1195643", callback: { [weak self] (user, error) in
//                            guard let me = self else {
//                                return
//                            }
//                            guard let user = user else {
//                                //debug("Failed to get user info", "ERROR")
//                               // me.handleFailedLogin(error: Strings.noServerData.localized)
//                                return
//                            }
//                            print("data get\(user)")
//                        })
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.createTabbarMethod(getIndex: 0)
                       case .failure(let error):
                        print("Login failed: \(error)")
                        self?.customAlertController.delegate = self
                        self?.customAlertController.showCustomAlert3(getMesage: error.localizedDescription.description, getView: self!)
                    }
                }
            }
        }
    }
    
    // MARK: Custom alert button click here
    func customAlertBtnClick() {
        print("btn click here")
    }
    
//    func digestAuthTrip(didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//        if challenge.previousFailureCount < 3 {
//            let credential = URLCredential(user: "swApiUser", password: "rxVtdUT6vr82wf9jwowj9fw28rv6TUdtVxr", persistence: .forSession)
//            completionHandler(.useCredential, credential)
//        } else {
//            completionHandler(.cancelAuthenticationChallenge, nil)
//        }
//    }
//
//    func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//
//        // Look for specific authentication challenges and dispatch those to various helper methods.
//        //
//        // IMPORTANT: It's critical that, if you get a challenge you weren't expecting,
//        // you resolve that challenge with `.performDefaultHandling`.
//
//        switch (challenge.protectionSpace.authenticationMethod, challenge.protectionSpace.host) {
//        case (NSURLAuthenticationMethodHTTPBasic, "httpbin.org"):
//            self.basicAuthTrip(didReceive: challenge, completionHandler: completionHandler)
//        case (NSURLAuthenticationMethodHTTPDigest, "httpbin.org"):
//            self.digestAuthTrip(didReceive: challenge, completionHandler: completionHandler)
//        default:
//            completionHandler(.performDefaultHandling, nil)
//        }
//    }
//
//
//    func basicAuthTrip(didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//        if challenge.previousFailureCount < 3 {
//            let credential = URLCredential(user: "bbbb", password: "bbbb", persistence: .forSession)
//            completionHandler(.useCredential, credential)
//        } else {
//            completionHandler(.cancelAuthenticationChallenge, nil)
//        }
//    }
    
    @IBAction func teacherLoginBtnClick(_ sender: Any) {
     }
    
    @IBAction func forgotPassBtnClick(_ sender: Any) {
        
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        let forgotViewController = story.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(forgotViewController, animated: true)
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
      }
  }

