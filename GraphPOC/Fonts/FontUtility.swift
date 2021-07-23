
//
//  FontUtility.swift
//  Notv
//
//  Created by Bitcot Inc on 1/31/16.
//  Copyright © 2016 bitcot. All rights reserved.
//

import UIKit

public func navigationTitleFont() -> UIFont{

    return UIFont.systemFont(ofSize: 23, weight: .semibold)
}

public func navigationTitleFont(size:CGFloat) -> UIFont{
    return UIFont.systemFont(ofSize: 17.0)
}

public func instructoNavigationTitleFont() -> UIFont{
    return UIFont.systemFont(ofSize: 17.0)
}

public func navigationBarButtonTitleFont() -> UIFont{
    if #available(iOS 8.2, *) {
        return UIFont.systemFont(ofSize: 17.0)
    } else {
        // Fallback on earlier versions
        return UIFont.systemFont(ofSize: 17.0)
    }
}

public func placeHolderFont() -> UIFont{
    return UIFont.systemFont(ofSize: 17.0)
}

public func defaultFont(size:CGFloat) -> UIFont{
    return UIFont(name: "Roboto-Book", size: size)!
}
