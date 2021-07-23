//
//  Alerts+Utility.swift
//  CommonLib
//
//  Created by Prakash Mali on 11/4/20.
//  Copyright © 2020 sahil jain. All rights reserved.
//

import Foundation
import SwiftMessages

func showSwiftMessageError(title: String, message: String, layout:MessageView.Layout = .statusLine) {
    let error = MessageView.viewFromNib(layout: layout)
    error.configureTheme(.error)
    error.configureContent(title: title, body: message.capitalized)
    error.button?.isHidden = true
    error.backgroundView.backgroundColor = UIColor.red
    SwiftMessages.show(view: error)
    error.bodyLabel?.font = UIFont.swiftMessagesCardViewBodyFont
}


func showSwiftMessageSuccess(title: String, message: String, layout:MessageView.Layout = .statusLine,duration: Float = 4) {
    let success = MessageView.viewFromNib(layout:layout)
    success.configureTheme(.success)
    success.configureDropShadow()
    success.configureContent(title: title, body: message)
    success.button?.isHidden = true
    var config = SwiftMessages.defaultConfig
    config.duration = .seconds(seconds: TimeInterval(exactly: duration)!)
    success.bodyLabel?.font = UIFont.swiftMessagesCardViewBodyFont
    SwiftMessages.show(config: config, view: success)
}
