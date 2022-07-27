//
//  IDMissionSDK.m
//  idmission
//

#import "IDMissionSDK.h"
#import <AppItFramework/AppItSDK.h>
#import <React/RCTEventEmitter.h>

@interface IDMissionSDK ()

@end

@implementation IDMissionSDK

static IDMissionSDK *gInstance = NULL;

- (NSArray<NSString *> *)supportedEvents
{
  return @[@"onSessionConnect",@"FaceCallback",@"IDCaptureCallback",@"ImageProcessingAndFaceMatchingCallback",@"DataCallback"];

}

RCT_EXPORT_METHOD(initializeSDK:(NSString *)url loginId:(NSString *)loginId password:(NSString *)password merchantid:(NSString *)merchantid productid:(NSNumber * _Nonnull)productid productname:(NSString *)productname language:(NSString *)language)
{
  UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
  
  gInstance = self;
  
  dispatch_async(dispatch_get_main_queue(), ^{
    NSString *productidString = [productid stringValue];

    [AppItSDK initializeAppItSDK:self url:url loginId:loginId password:password merchantID:merchantid productID:productidString productName:productname Language:language EnableDebug:false enableGPS:false];
    
  });
}

-(void)initializeSDKResponse : (NSMutableDictionary*) result {
  NSMutableDictionary *resultDict = [result objectForKey:@"Result"];
  NSLog(@"Response : %@ ", resultDict);
  [IDMissionSDK getEvent:@"DataCallback" dict:resultDict];
}

RCT_EXPORT_METHOD(customizeUserInterface:(NSString *)uiconfiguration)
{
  dispatch_async(dispatch_get_main_queue(), ^{
    NSError *error;
    NSData* uiconfigurationData = [uiconfiguration dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *uiconfigurationDict = [NSJSONSerialization JSONObjectWithData:uiconfigurationData options:kNilOptions error:&error];
    [AppItSDK customizeUserInterface: uiconfigurationDict];
  });
}

RCT_EXPORT_METHOD(detectFace:(NSString *)faceCaptureConfig uiConfigDictionary:(NSString *)uiConfigDictionary)
{
  UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
  
  dispatch_async(dispatch_get_main_queue(), ^{
    NSError *error;
    NSData* faceCaptureConfigData = [faceCaptureConfig dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *faceCaptureConfigDict = [[NSMutableDictionary alloc] init];
    [faceCaptureConfigDict setObject:faceCaptureConfigData forKey:@"faceCaptureConfig"];    
    NSData* uiConfigDictionaryData = [uiConfigDictionary dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *uiConfigDict = [NSJSONSerialization JSONObjectWithData:uiConfigDictionaryData options:kNilOptions error:&error];
    [AppItSDK detectFace:rootViewController faceCaptureConfig:faceCaptureConfigDict uiConfigDictionary:uiConfigDict];
    
  });
}

RCT_EXPORT_METHOD(captureIDFront:(NSString *)additionalDictionary uiConfigDictionary:(NSString *)uiConfigDictionary)
{
  UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
  
  dispatch_async(dispatch_get_main_queue(), ^{
    NSError *error;
    NSData* additionalDictionaryData = [additionalDictionary dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *additionalDict = [NSJSONSerialization JSONObjectWithData:additionalDictionaryData options:kNilOptions error:&error];
    NSData* uiConfigDictionaryData = [uiConfigDictionary dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *uiConfigDict = [NSJSONSerialization JSONObjectWithData:uiConfigDictionaryData options:kNilOptions error:&error];
    [AppItSDK captureFrontImage:rootViewController additionalDictionary:additionalDict uiConfigDictionary:uiConfigDict];
  });
}

RCT_EXPORT_METHOD(captureIDBack:(NSString *)additionalDictionary uiConfigDictionary:(NSString *)uiConfigDictionary)
{
  UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
  
  dispatch_async(dispatch_get_main_queue(), ^{
    NSError *error;
    NSData* additionalDictionaryData = [additionalDictionary dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *additionalDict = [NSJSONSerialization JSONObjectWithData:additionalDictionaryData options:kNilOptions error:&error];
    NSData* uiConfigDictionaryData = [uiConfigDictionary dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *uiConfigDict = [NSJSONSerialization JSONObjectWithData:uiConfigDictionaryData options:kNilOptions error:&error];
    [AppItSDK captureBackImage:rootViewController additionalDictionary:additionalDict uiConfigDictionary:uiConfigDict];
  });
}

RCT_EXPORT_METHOD(processImageAndMatchFace:(NSString *)countryCode stateCode:(NSString *)stateCode idType:(NSString *)idType additionalDictionary:(NSString *)additionalDictionary)
{
  UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
  
  dispatch_async(dispatch_get_main_queue(), ^{
    NSError *error;
    NSData* additionalDictionaryData = [additionalDictionary dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *additionalDict = [NSJSONSerialization JSONObjectWithData:additionalDictionaryData options:kNilOptions error:&error];
    [AppItSDK processImageAndMatchFace:rootViewController countryCode:countryCode stateCode:stateCode idType:idType faceImageType:@"FACE_IMAGE" additionalDictionary:additionalDict finalSubmit:true clearFormKey:true];
  });
}

RCT_EXPORT_MODULE(IDMissionSDK);

+ (void)getEvent: (NSString*)type dict:(NSMutableDictionary*) dict
{
 
  [gInstance sendEventWithName:type body:dict];

}
@end
