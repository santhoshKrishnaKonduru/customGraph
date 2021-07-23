//
//  Array+CollectionGenerics.swift
//  InHarmony
//
//  Created by Santhosh Konduru on 17/10/20.
//  Copyright © 2020 Bitcot. All rights reserved.
//

import Foundation

extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()

        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }

        return result
    }
}

extension Array {

    func filterDuplicates(includeElement: (_ lhs:Element, _ rhs:Element) -> Bool) -> [Element]{
        var results = [Element]()

        forEach { (element) in
            let existingElements = results.filter {
                return includeElement(element, $0)
            }
            if existingElements.count == 0 {
                results.append(element)
            }
        }

        return results
    }
    
    /// Picks `n` random elements (partial Fisher-Yates shuffle approach)
        subscript (randomPick n: Int) -> [Element] {
            var copy = self
            for i in stride(from: count - 1, to: count - n - 1, by: -1) {
                copy.swapAt(i, Int(arc4random_uniform(UInt32(i + 1))))
            }
            return Array(copy.suffix(n))
        }
}
