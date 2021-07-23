//
//  UIViewController+Progress.swift
//  NimbusCard
//
//  Created by Bitcot Inc on 17/12/15.
//  Copyright © 2015 Bitcot. All rights reserved.
//

import UIKit
import SVProgressHUD

extension UIViewController{
    
    //        MARK: progress bar functionality
    func showSVProgress(message: String?) {
        self.setUp()
        if let msg = message {
            SVProgressHUD.show(withStatus: msg)
        } else {
            SVProgressHUD.show()
        }
    }

    func showSVProgressForCompletion(completed: Float) {
        self.setUp()
        SVProgressHUD.showProgress(completed)
    }

    func hideSVProgress() {
        SVProgressHUD.dismiss()
    }

    func hideSVProgressWithSuccess(message: String?) {
        setUp()
        SVProgressHUD.showSuccess(withStatus: message)
    }

    func hideSVProgressWithFailure(message: String?) {
        setUp()
        SVProgressHUD.showError(withStatus: message)
    }
    
    private func setUp() {
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setDefaultStyle(.custom)
        // SVProgressHUD.setSuccessImage(UIImage(named: "Checkmark")!)
        SVProgressHUD.setBackgroundColor(UIColor.black.withAlphaComponent(0.85))
        SVProgressHUD.setForegroundColor(UIColor.white)
    }
}
