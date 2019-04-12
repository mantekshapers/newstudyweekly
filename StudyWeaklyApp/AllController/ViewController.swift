//
//  ViewController.swift
//  StudyWeaklyApp
//
//  Created by Man Singh on 7/12/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit
//import Realm
import Retrolux

class ViewController: UIViewController, UITextFieldDelegate, URLSessionDelegate, URLSessionDataDelegate, CustomAlertBtnDelegate
{
     let customAlertController = CustomController()
    
    @IBOutlet weak var txtLogin : UITextField!
    @IBOutlet weak var txtPwd: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnForgot: UIButton!
    @IBOutlet weak var viewLogin: UIView!
    @IBOutlet weak var viewPwd: UIView!

    var strLogin = ""
    var strPwd = ""
    
    //MARK: - UIView Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        viewLogin.layer.cornerRadius = 5.0
        viewLogin.layer.masksToBounds = true
        
        viewPwd.layer.cornerRadius = 5.0
        viewPwd.layer.masksToBounds = true
        
        btnLogin.layer.cornerRadius = 5.0
        btnLogin.layer.masksToBounds = true
    }
    
    //MARK: - User Define Method
    func navigateMethod()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.createTabbarMethod(getIndex: 0)
    }
    
    func customAlertBtnClick(getAlertTitle: String)
    {
        if getAlertTitle == "sessionExpired" {
        }
    }

    //MARK: - Ws Method
    func wsCallForLogin()
    {
        NetworkCheckReachbility.isConnectedToNetwork
            { (boolTrue) in
                if boolTrue == false
                {
                    CustomController.showMessage(message: AlertTitle.networkStr)
                    return
                }
                
                self.customAlertController.showActivityIndicatory(uiView: self.view)
                let parameters = LoginParameters(username:Field(self.strLogin),password: Field(self.strPwd))
                NetworkAPI.login(parameters).enqueue { [weak self] response in
                    
                    switch response.interpreted
                    {
                    case .success(let value):
                        NetworkAPI.setLoginCookie(using: response)
                        
                        if (value.success == nil)
                        {
                            DispatchQueue.main.async { self?.customAlertController.hideActivityIndicator(uiView: (self?.view)!)}
                            CustomController.showMessage(message: value.error!)
                            self?.txtLogin.text = ""
                            self?.txtPwd.text = ""
                        }
                        else
                        {
                            guard let userID = value.success?.user_id
                                else {
                                    return
                            }
                            print("success: \(userID) && \(value.success?.role ?? "")")
                            NetworkAPI.setUserID(userID)
                            
                            let parameters = ["user_id": userID]
                            CommonWebserviceClass.makeHTTPGetRequest(path: BaseUrlOther.baseURLOther + WebserviceName.userWebName, postString: parameters, httpMethodName: "GET")
                            { (response, bool) in
                                print("response:- \(String(describing: response))")
                                
                                if bool == false
                                {
                                    DispatchQueue.main.async { self?.customAlertController.hideActivityIndicator(uiView: (self?.view)!)}
                                    CustomController.showMessage(message: "Error: Something went wrong!")
                                }
                                else
                                {
                                    let getDict =   response as? [String: Any]
                                    print("response:->",getDict as Any)

                                    CDBManager().addCDBData(object: getDict!)
                                    CommonWebserviceClass.makeHTTPGetRequest(path: BaseUrlOther.baseURLOther + WebserviceName.user_publication_ids, postString: parameters, httpMethodName: "GET") { (response, bool) in
                                        if bool == false
                                        {
                                            DispatchQueue.main.async { self?.customAlertController.hideActivityIndicator(uiView: (self?.view)!)}
                                            CustomController.showMessage(message: "Error: Something went wrong!")
                                        }
                                        else
                                        {
                                            DispatchQueue.main.async{
                                                print("fIND second RESPOSE\(String(describing: response))")
                                                self?.customAlertController.hideActivityIndicator(uiView: (self?.view)!)
                                              //  self?.navigateMethod()
                                                
                                                let homeVC = self?.storyboard?.instantiateViewController(withIdentifier: StoryBoardId.HomeFileViewControllerID) as! HomeFileViewController
                                                self?.navigationController?.pushViewController(homeVC, animated: true)

                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                    case .failure(let error):
                        DispatchQueue.main.async
                            {
                                DispatchQueue.main.async { self?.customAlertController.hideActivityIndicator(uiView: (self?.view)!)}
                                print("Login failed: \(error)")
                                self?.customAlertController.delegate = self
                                CustomController.showMessage(message: error.localizedDescription.description)
                        }
                    }
                }
        }
    }
    
    //MARK: - UIButton Methods
    @IBAction func loginBtnClick(_ sender: Any)
    {
        self.view.endEditing(true)

        
        if CustomController.checkStringNull(strValue: self.txtLogin.text!).count == 0
        {
            CustomController.showMessage(message: AlertTitle.loginTextStr)
            return
        }
        if CustomController.checkStringNull(strValue: self.txtPwd.text!).count == 0
        {
            CustomController.showMessage(message: AlertTitle.passwordTextStr)
            return
        }

//        if CustomController.checkNullString(strToCompare: self.txtLogin.text!).count == 0
//        {
//            CustomController.showMessage(message: AlertTitle.loginTextStr)
//            return
//        }
//
//        if CustomController.checkNullString(strToCompare: self.txtPwd.text!).count == 0
//        {
//            CustomController.showMessage(message: AlertTitle.passwordTextStr)
//            return
//        }
        
        strLogin = self.txtLogin.text!
        strPwd = self.txtPwd.text!

        self.wsCallForLogin()
    }
    
    @IBAction func forgotPassBtnClick(_ sender: Any)
    {
        self.view.endEditing(true)
        let forgotViewController = self.storyboard?.instantiateViewController(withIdentifier: StoryBoardId.ForgotPasswordVCID) as! ForgotPasswordVC
        self.navigationController?.pushViewController(forgotViewController, animated: true)
    }
    
    //MARK: - UITextField Delegate Method
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if (textField == txtLogin)
        {
            self.txtPwd.becomeFirstResponder()
        }
        
        if (textField == txtPwd)
        {
            self.txtPwd.resignFirstResponder()
        }
        
        return true
    }

    //MARK: - Memory Warning
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
      }
  }

