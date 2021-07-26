//
//  GraphUtility.swift
//  GraphPOC
//
//  Created by Santhosh Konduru on 20/03/21.
//

import Foundation
import UIKit


func getWorldWideConfirmYPoistion(from confirmCases: Double, rowHeight: CGFloat, rangeValues: [Int]) -> (CGFloat, Int) {
    
    var yPosition: CGFloat = 0
    var rowPosition: Int = 0
    for (index, range) in rangeValues.enumerated() {
        if let range2 = rangeValues[safe: index + 1] {
            let range1Double = Double(range)
            let range2Double = Double(range2)
            
            if (range2Double...range1Double).contains(confirmCases) {
                rowPosition = index
                let rangeDiff = abs(range1Double - range2Double)
                let totalDiff = CGFloat(confirmCases) - (CGFloat(4 - index) * CGFloat(rangeDiff))
                if rangeDiff == 0 {
                    yPosition = 0
                }else {
                    yPosition = (rowHeight/CGFloat(rangeDiff)) * totalDiff
                }
                break
            }
        }
    }
    
    return (yPosition, rowPosition)
}
