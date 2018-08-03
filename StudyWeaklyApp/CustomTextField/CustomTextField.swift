
//  CustomTextField.swift
//  StudyWeaklyApp
//
//  Created by Man Singh on 7/12/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import UIKit

class CustomTextField: UITextField ,UITextFieldDelegate{

    required override init(frame: CGRect) {
        super.init(frame: frame)
       // createBorder()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
        self.layer.cornerRadius = 5.0
       // self.layer.borderColor = UIColor.red.cgColor
        //self.layer.borderWidth = 1.5
       // self.backgroundColor = UIColor.blue
       // self.tintColor = UIColor.white
       
    }
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 45, y: bounds.origin.y, width: bounds.width, height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 45, y: bounds.origin.y, width: bounds.width, height: bounds.height)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
}
extension ViewController {
    //MARK: Textfield Delegate
    // When user press the return key in keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldReturn")
        textField.resignFirstResponder()
        return true
    }
    
    // It is called before text field become active
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // textField.backgroundColor = UIColor.lightGrayColor()
        return true
    }
    
    // It is called when text field activated
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing")
    }
    
    // It is called when text field going to inactive
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // textField.backgroundColor = UIColor.whiteColor()
        return true
    }
    
    // It is called when text field is inactive
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textFieldDidEndEditing")
    }
    
    // It is called each time user type a character by keyboard
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        print(string)
        return true
    }
}
