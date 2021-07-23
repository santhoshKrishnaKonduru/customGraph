//
//  AlamofireAPIResponse.swift
//  LivePlanet
//
//  Created by Ashish on 06/02/17.
//  Copyright © 2017 Bitcot. All rights reserved.
//

import UIKit

/* AlamofireAPIResponse object holds the API response from the server containing either error or a response based on the result of an API call
 */

class AlamofireAPIResponse: NSObject {
    
    let errorMsg: String?
    let errorCode: Int
    let responseObject: JSON?
    let isSuccessful: Bool
    
    init(response: JSON?, errorCode: Int, errorMessage: String, successful: Bool) {
        
        self.responseObject = response
        self.errorCode = errorCode
        self.errorMsg = errorMessage
        self.isSuccessful = successful
    }
}
