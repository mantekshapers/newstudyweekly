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
                self.customAlertController.showCustomAlert3(getMesage: AlertTitle.networkStr, getView: self)
                 return
                }
                 self.customAlertController.showActivityIndicatory(uiView: self.view)
            let parameters = LoginParameters(username:Field((self.login_txtField?.text)!),password: Field((self.password_txtField?.text)!))
                   NetworkAPI.login(parameters).enqueue { [weak self] response in
                    guard let me = self else {
                       DispatchQueue.main.async { self?.customAlertController.hideActivityIndicator(uiView: (self?.view)!)
                        }
                        return
                         }
                    DispatchQueue.main.async{
                    self?.customAlertController.hideActivityIndicator(uiView: (self?.view)!)
                        }
                     switch response.interpreted {
                     case .success(let value):
                         NetworkAPI.setLoginCookie(using: response)
                        guard let userID = value.success?.user_id else {
                            return
                         }
                          DispatchQueue.main.async {
                            print("success \(userID) && \(value.success?.role ?? "")")
                         }
                        NetworkAPI.setUserID(userID)
                         let parameters = ["user_id": userID]
                         CommonWebserviceClass.makeHTTPGetRequest(path: BaseUrlOther.baseURLOther + WebserviceName.userWebName, postString: parameters, httpMethodName: "GET") { (response, booll) in
                            if booll == false {
                                 DispatchQueue.main.async {
                                print(booll)
                                }
                            }else{
                                 DispatchQueue.main.async {
                                print("fIND RESPOSE",response ?? "")
                                }
                              //  let getDict = (response!["success"] as? [String:Any])?["Type"]
                                //var getDict = response!["success"] as? Any as! [String: AnyObject]
                              //  let getDict = response["success"] as! Any
                               let getDict =   response as? [String: Any]
                                CDBManager().addCDBData(object: getDict!)
                                CommonWebserviceClass.makeHTTPGetRequest(path: BaseUrlOther.baseURLOther + WebserviceName.user_publication_ids, postString: parameters, httpMethodName: "GET") { (response, booll) in
                                    if booll == false {
                                         DispatchQueue.main.async {
                                        print(booll)
                                        }
                                    }else{
                                         DispatchQueue.main.async {
                                            print("fIND second RESPOSE")
                                            self?.navigateMethod()
                                        }
                                     }
                                  }
                              }
                          }
                      
                       case .failure(let error):
                         DispatchQueue.main.async {
                        print("Login failed: \(error)")
                        self?.customAlertController.delegate = self
                        self?.customAlertController.showCustomAlert3(getMesage: error.localizedDescription.description, getView: self!)
                        }
                    }
                }
        }
    }
    
    func navigateMethod(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.createTabbarMethod(getIndex: 0)
    }
    // MARK: Custom alert button click here
    func customAlertBtnClick(getAlertTitle: String) {
        print("btn click here")
        if getAlertTitle == "sessionExpired" {
            
            
        }
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

