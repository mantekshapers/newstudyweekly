//
//  ForgotPasswordVC.swift
//  StudyWeaklyApp
//
//  Created by Man Singh on 7/13/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit
import Retrolux

class ForgotPasswordVC: UIViewController , UITextFieldDelegate
{
    @IBOutlet weak var recoverBtn: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var txtEmail : UITextField!
    @IBOutlet weak var viewEmail : UIView!

     let customAlertController = CustomController()
    
    //MARK: - UIView Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true

        viewEmail.layer.cornerRadius = 5.0
        viewEmail.layer.masksToBounds = true
        
        recoverBtn.layer.cornerRadius = 5.0
        recoverBtn.layer.masksToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
         super.viewWillAppear(animated)
    }
    
    //MARK: - Ws Method
    func wsCallForForgot()
    {
        NetworkAPI.passwordReset(Query(self.txtEmail.text!)).enqueue { (response) in
            switch response.interpreted
            {
            case .success(let value):
                if value.success?.boolValue ?? false
                {
                    self.customAlertController.showCustomAlert3(getMesage:  value.message ?? "", getView: self)
                }
                else
                {
                    let alertController = UIAlertController(title: "Studies Weekly", message: value.message, preferredStyle: .alert)
                    let yesAction = UIAlertAction(title: "Ok", style: .default){
                        (result : UIAlertAction) -> Void in
                        self.navigationController?.popViewController(animated: true)
                    }
                    alertController.addAction(yesAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                
            case .failure(let error):
                print("Error - \(error)")
                self.customAlertController.showCustomAlert3(getMesage: error.localizedDescription, getView: self)
            }
        }
    }
    
    //MARK: - UIButton Method
    @IBAction func backBtnClick(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func forgotPassBtnClick(_ sender: Any)
    {
        self.view.endEditing(true)
        if CustomController.checkNullString(strToCompare: self.txtEmail.text!).count == 0
        {
            CustomController.showMessage(message: "Please enter your registered email address")
            return
        }
        
        if CustomController.isValid(Email: CustomController.checkNullString(strToCompare: self.txtEmail.text!))
        {
            CustomController.showMessage(message: AlertTitle.emailEnterId)
            return
        }
    }

    //MARK: - UITextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: - Memory Warning
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
      }
}
