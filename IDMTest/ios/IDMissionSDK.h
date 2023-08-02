//
//  IDMissionSDK.h
//  idmission
//
//  Created by apple on 11/12/20.
//

#import <UIKit/UIKit.h>
#import <React/RCTBridgeModule.h>
#import <AppItFramework_IdFace/AppItSDK.h>
#import <React/RCTEventEmitter.h>



NS_ASSUME_NONNULL_BEGIN


@interface IDMissionSDK :RCTEventEmitter <RCTBridgeModule>

+(void) getEvent:(NSString*)type dict:(NSMutableDictionary*)dict;


@end

NS_ASSUME_NONNULL_END
