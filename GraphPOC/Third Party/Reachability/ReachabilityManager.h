//
//  ReachabilityManager.h
//  IUPro
//
//  Created by Bitcot Inc on 4/22/15.
//
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
@interface ReachabilityManager : NSObject

@property (strong, nonatomic) Reachability *reachability;

#pragma mark -
#pragma mark Shared Manager
+ (ReachabilityManager *)sharedManager;

#pragma mark -
#pragma mark Class Methods
+ (BOOL)isReachable;
+ (BOOL)isUnreachable;
+ (BOOL)isReachableViaWWAN;
+ (BOOL)isReachableViaWiFi;
@end
