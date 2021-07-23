//
//  ReachabilityManager.swift
//  CommonLib
//
//  Created by Santosh on 06/12/17.
//  Copyright © 2017 sahil jain. All rights reserved.
//

import UIKit

class ReachabilityManager: NSObject {
    
    static let sharedInstance = ReachabilityManager()
    var reachability: Reachability? = Reachability.networkReachabilityForInternetConnection()
    
    override init() {
        super.init()
        _ =  reachability?.startNotifier()
    }
    
    deinit {
        reachability?.stopNotifier()
    }
    
    func isReachable() -> Bool {
        guard let reachablility = reachability else { return false }
        if reachablility.isReachable  {
            return true
        } else {
            return false
        }
    }
    
    func isReachableViaWWAN() -> Bool {
        ReachabilityManager.sharedInstance.reachability = Reachability.networkReachabilityForInternetConnection()
        return ReachabilityManager.sharedInstance.isReachable()
    }
    
    func isReachableViaWiFi() -> Bool {
        ReachabilityManager.sharedInstance.reachability = Reachability.networkReachabilityForLocalWiFi()
        return ReachabilityManager.sharedInstance.isReachable()
    }

}
