//
//  NetworkState.swift
//  skinnyconfidential
//
//  Created by sahil jain on 3/24/20.
//  Copyright © 2020 Pixy Bean LLC. All rights reserved.
//

import Foundation
import Alamofire

class NetworkState {
    class func isConnected() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

