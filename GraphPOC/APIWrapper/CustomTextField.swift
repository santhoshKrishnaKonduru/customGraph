//
//  CustomTextField.swift
//  iCampSavvy
//
//  Created by Santosh on 16/06/17.
//  Copyright © 2017 bitcot. All rights reserved.
//

import UIKit

@objc protocol CustomTextFieldDelegate:AnyObject {
    @objc optional func customTextFieldShouldReturn(customView: CustomTextField) -> Bool
    @objc optional func customTextFieldDidBeginEditing(customView: CustomTextField)
    @objc optional func customTextFieldShouldBeginEditing(customView: CustomTextField) -> Bool
    @objc optional func customTextField(customView: CustomTextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    @objc optional func customTextFieldShouldClear(customView: CustomTextField) -> Bool
    @objc optional func customTextFieldDidEndEditing(customView: CustomTextField)
}

class CustomTextField: UIView{
    
    @IBOutlet weak var textFieldTopConstarint: NSLayoutConstraint!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet var view: UIView!
    @IBOutlet weak var placeHolderLabel: UILabel!
    @IBOutlet weak var placeHolderHorizontalConstraint: NSLayoutConstraint!
    @IBOutlet weak var textFieldTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var placeHolderLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var textFieldLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var borderView: UIView!
    
    @IBOutlet weak var down_icon: UIImageView!
    
    
    
    
    var delegate: CustomTextFieldDelegate? = nil
    var placeHolderRevertAnimationPoint: CGFloat?
    var placeHolderAnimationPoint: CGFloat?
    var textFieldTopConstraintAnimationPoint: CGFloat?
    var errorText = ""
    var showDefaultTextFiledBehaviour = false
    var isSecureTextEntry = false
    
    required  init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadView()
    }
    
    func loadView(){
        let _ = Bundle.main.loadNibNamed("CustomTextField", owner: self, options: nil)?.first
        view.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        textField.delegate = self
        addSubview(view)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func animatePlaceHolder() {
        textFieldTopConstarint.constant = textFieldTopConstraintAnimationPoint == nil ? 17 : textFieldTopConstraintAnimationPoint!
        UIView.animate(withDuration: 0.3) {
            self.placeHolderLabel.font = self.placeHolderLabel.font.withSize(14.0)
            self.placeHolderHorizontalConstraint.constant = self.placeHolderAnimationPoint == nil ? -13.0 : self.placeHolderAnimationPoint!
            self.layoutIfNeeded()
        }
    }
    
    func revertPlaceHolderAnimation() {
        textFieldTopConstarint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.placeHolderLabel.font = self.placeHolderLabel.font.withSize(16.0)
            self.placeHolderLabel.textColor = UIColor.darkGray
            self.placeHolderHorizontalConstraint.constant = self.placeHolderRevertAnimationPoint == nil ? 0 : self.placeHolderRevertAnimationPoint!
            self.layoutIfNeeded()
        }
    }
    
    func loadTextField(text: String) {
        animatePlaceHolder()
        textField.text = text
        placeHolderLabel.textColor = UIColor.darkGray
    }
    
    func revertTextFieldData() {
        revertPlaceHolderAnimation()
        textField.text = ""
    }
    
    func getText() -> String {
        return textField.text ?? ""
    }
    
    
    func placeHolderTextStartAnimation() {
        
    }
    
    func placeHolderTextReverseAnimation() {
        
    }
    
    func updateCornerRadius() {
        //addCornerRadius(view: textField, radius: textField.frame.height/2.0)
    }
    
    func configureField(tag: Int = 0, placeholder: String, keyboardType: UIKeyboardType = .default, returnType: UIReturnKeyType = .done, isSecureTextEntry: Bool = false, showDefaultTextFiledBehaviour: Bool = false, defaultPlaceholderText: String = "", showDownIcon: Bool = false) {
        if keyboardType == .emailAddress {
            self.textField.autocorrectionType = .no
            self.textField.autocapitalizationType = .none
        }
        self.isSecureTextEntry = isSecureTextEntry
        self.textField.tag = tag
        self.textField.isSecureTextEntry = isSecureTextEntry
        placeHolderLabel.text = placeholder
        self.textField.keyboardType = keyboardType
        self.textField.returnKeyType = returnType
        self.showDefaultTextFiledBehaviour = showDefaultTextFiledBehaviour
        self.down_icon.isHidden = !showDownIcon
        if showDefaultTextFiledBehaviour {
            animatePlaceHolder()
            self.textField.placeholder = defaultPlaceholderText
        }
    }
    
    func validateTextField(textFieldError:String,showError:Bool) -> Bool {
        if self.textField.text?.isEmpty == true || self.textField.text == textFieldError || self.textField.text?.trimmingCharacters(in: .whitespaces).isEmpty == true {
            self.textField.isSecureTextEntry = false
            self.enableErrorAppearance(enable: showError, errorText: textFieldError)
            return true
        } else {
            return false
        }
    }
    
    func enableErrorAppearance(enable: Bool, errorText: String = "") {
        if enable {
            borderView.backgroundColor = UIColor.red
            placeHolderLabel.textColor = UIColor.darkGray
            if errorText != "" {
                animatePlaceHolder()
            }
            if isSecureTextEntry {
                textField.isSecureTextEntry = false
            }
            self.errorText = errorText
            textField.text = errorText
            textField.textColor = UIColor.red
        } else {
            if isSecureTextEntry {
                textField.isSecureTextEntry = true
            }
            borderView.backgroundColor = UIColor.darkGray
            textField.textColor = UIColor.black
            if textField.text == self.errorText {
                textField.text = ""
            }
            
        }
        
        borderView.backgroundColor = enable ? UIColor.red : UIColor.darkGray
    }
    
    func setText(text:String){
        textField.text = text
        placeHolderLabel.textColor = UIColor.darkGray
        animatePlaceHolder()
    }
}

extension CustomTextField:UITextFieldDelegate{
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        if textField.text == "" && showDefaultTextFiledBehaviour == false {
            revertPlaceHolderAnimation()
        }
        if let _ = delegate {
            if let val = delegate?.customTextFieldShouldReturn?(customView: self) {
                return val
            }
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if showDefaultTextFiledBehaviour == false {
            if textField.text == "" {
                revertPlaceHolderAnimation()
            }else {
                if textField.resignFirstResponder() {
                    placeHolderLabel.textColor = UIColor.darkGray
                }
            }
        }
        
        
        if let _ = delegate {
            if let val = delegate?.customTextFieldDidEndEditing?(customView: self) {
                return val
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if showDefaultTextFiledBehaviour == false {
            animatePlaceHolder()
        }
        if let _ = delegate {
            if let val = delegate?.customTextFieldDidBeginEditing?(customView: self) {
                return val
            }
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        enableErrorAppearance(enable: false)
        if let _ = delegate {
            if let val = delegate?.customTextFieldShouldBeginEditing?(customView: self) {
                return val
            }
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let _ = delegate {
            if let val = delegate!.customTextField?(customView: self, shouldChangeCharactersIn: range, replacementString: string) {
                return val
            }
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    //MARK:end
}
