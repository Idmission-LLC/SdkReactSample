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

RCT_EXPORT_METHOD(detectFace)
{
  UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
  
  dispatch_async(dispatch_get_main_queue(), ^{
    
    NSMutableDictionary *nsDict = [[NSMutableDictionary alloc] init];
    [AppItSDK detectFace:rootViewController faceCaptureConfig:nsDict];
    
  });
}

RCT_EXPORT_METHOD(captureIDFront:(NSString *)country id_type:(NSString *)ids)
{
  UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
  
  dispatch_async(dispatch_get_main_queue(), ^{
    
    NSMutableDictionary *nsDict = [[NSMutableDictionary alloc] init];
    [nsDict setObject:country forKey:@"country_code"];
    [nsDict setObject:@"" forKey:@"state_code"];
    [nsDict setObject:ids forKey:@"id_type"];
    [nsDict setObject:ids forKey:@"id_type"];
    
    //To Capture ID in Portarit Mode
    [nsDict setObject:@"Y" forKey:@"id_capture_portrait"];
    [nsDict setObject:@"1170" forKey:@"id_image_height"];
    [nsDict setObject:@"800" forKey:@"id_image_width"];
    
    //To Capture ID in Landscape Mode
    //[nsDict setObject:@"N" forKey:@"id_capture_portrait"];
    //[nsDict setObject:@"800" forKey:@"id_image_height"];
    //[nsDict setObject:@"1170" forKey:@"id_image_width"];
    
    [AppItSDK captureFrontImage:rootViewController additionalDictionary:nil uiConfigDictionary:nsDict];
    
  });
}

RCT_EXPORT_METHOD(captureIDBack:(NSString *)country id_type:(NSString *)ids)
{
  UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
  
  dispatch_async(dispatch_get_main_queue(), ^{

    NSMutableDictionary *nsDict = [[NSMutableDictionary alloc] init];
    [nsDict setObject:country forKey:@"country_code"];
    [nsDict setObject:@"" forKey:@"state_code"];
    [nsDict setObject:ids forKey:@"id_type"];
    
    //To Capture ID in Portarit Mode
    [nsDict setObject:@"Y" forKey:@"id_capture_portrait"];
    [nsDict setObject:@"1170" forKey:@"id_image_height"];
    [nsDict setObject:@"800" forKey:@"id_image_width"];
    
    //To Capture ID in Landscape Mode
    //[nsDict setObject:@"N" forKey:@"id_capture_portrait"];
    //[nsDict setObject:@"800" forKey:@"id_image_height"];
    //[nsDict setObject:@"1170" forKey:@"id_image_width"];
    
    [AppItSDK captureBackImage:rootViewController additionalDictionary:nil uiConfigDictionary:nsDict];
  });
}

RCT_EXPORT_METHOD(processImageAndMatchFace:(NSString *)country id_type:(NSString *)ids)
{
  UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
  
  dispatch_async(dispatch_get_main_queue(), ^{
    
    NSMutableDictionary *nsDict = [[NSMutableDictionary alloc] init];
    
    [nsDict setObject:@"N" forKey:@"Manual_Review_Required"];
    [nsDict setObject:@"N" forKey:@"Bypass_Age_Validation"];
    [nsDict setObject:@"N" forKey:@"Bypass_Name_Matching"];
    [nsDict setObject:@"N" forKey:@"Deduplication_Required"];
    [nsDict setObject:@"N" forKey:@"Need_Immediate_Response"];
    [nsDict setObject:@"N" forKey:@"POST_Data_API_Required"];
    [nsDict setObject:@"N" forKey:@"Send_Input_Images_in_POST"];
    [nsDict setObject:@"N" forKey:@"Send_Processed_Images_in_POST"];
    [nsDict setObject:@"N" forKey:@"Capture_Secondary_ID"];
    [nsDict setObject:@"N" forKey:@"Deduplication_Manual_Review_Required"];
    [nsDict setObject:@"Y" forKey:@"ID_Back_Image_Required"];
    [nsDict setObject:@"N" forKey:@"Verify_Data_With_Host"];
    [nsDict setObject:@"10" forKey:@"Service_ID"];
    [nsDict setObject:@"M" forKey:@"Customer_Gender"];
    
    [AppItSDK processImageAndMatchFace:rootViewController countryCode:country stateCode:@"" idType:ids faceImageType:@"FACE_IMAGE" additionalDictionary:nsDict finalSubmit:true clearFormKey:true];
    
  });
}

RCT_EXPORT_MODULE(IDMissionSDK);

+ (void)getEvent: (NSString*)type dict:(NSMutableDictionary*) dict
{
 
  [gInstance sendEventWithName:type body:dict];

}
@end
