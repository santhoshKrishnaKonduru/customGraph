//
//  AVPlayer+Generics.swift
//  InHarmony
//
//  Created by Santhosh Konduru on 25/10/20.
//  Copyright © 2020 Bitcot. All rights reserved.
//

import Foundation
import AVKit

public extension AVPlayerItem {

    func totalBuffer() -> Double {
        return self.loadedTimeRanges
            .map({ $0.timeRangeValue })
            .reduce(0, { acc, cur in
                return acc + CMTimeGetSeconds(cur.start) + CMTimeGetSeconds(cur.duration)
            })
    }

    func currentBuffer() -> Double {
        let currentTime = self.currentTime()

        guard let timeRange = self.loadedTimeRanges.map({ $0.timeRangeValue })
            .first(where: { $0.containsTime(currentTime) }) else { return -1 }

        return CMTimeGetSeconds(timeRange.end) - currentTime.seconds
    }

}
