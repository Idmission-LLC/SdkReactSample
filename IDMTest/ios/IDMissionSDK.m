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

RCT_EXPORT_METHOD(videoConferencing)
{
  UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
  
  dispatch_async(dispatch_get_main_queue(), ^{
    
    NSMutableDictionary *nsDict = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *videoConfDict = [NSMutableDictionary new];
    //[videoConfDict setObject:formID forKey:@"FORM_ID"];

    [AppItSDK startVideoConferencing:rootViewController videoConferenceData:nsDict];

  });
}

RCT_EXPORT_METHOD(genericDocument)
{
  UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
  
  dispatch_async(dispatch_get_main_queue(), ^{
    
    NSMutableDictionary *nsDict = [[NSMutableDictionary alloc] init];
    
    [nsDict setObject:@"N" forKey:@"id_generic_file_upload_enable"];
    NSString *documentName = @"Generic_Document"; //As Configured In your Product

    [AppItSDK captureGenericDocument:rootViewController additionalDictionary:nil uiConfigDictionary:nsDict fieldName:documentName];

    
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

RCT_EXPORT_METHOD(captureFingerprints)
{
  UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
  
  dispatch_async(dispatch_get_main_queue(), ^{

    NSMutableDictionary *fingerprint_Dict = [[NSMutableDictionary alloc] init];
    [fingerprint_Dict setObject:@"cfc_indexfinger_min_threshold" forKey:@"40"];
    [fingerprint_Dict setObject:@"cfc_middlefinger_min_threshold" forKey:@"40"];
    [fingerprint_Dict setObject:@"cfc_ringfinger_min_threshold" forKey:@"40"];
    [fingerprint_Dict setObject:@"cfc_babyfinger_min_threshold" forKey:@"40"];

    [fingerprint_Dict setObject:@"cfc_indexfinger_threshold" forKey:@"100"];
    [fingerprint_Dict setObject:@"cfc_middlefinger_threshold" forKey:@"100"];
    [fingerprint_Dict setObject:@"cfc_ringfinger_threshold" forKey:@"100"];
    [fingerprint_Dict setObject:@"cfc_babyfinger_threshold" forKey:@"70"];

    [fingerprint_Dict setObject:@"cfc_process_indexfinger" forKey:@"Y"];
    [fingerprint_Dict setObject:@"cfc_process_middlefinger" forKey:@"N"];
    [fingerprint_Dict setObject:@"cfc_process_ringfinger" forKey:@"N"];
    [fingerprint_Dict setObject:@"cfc_process_babyfinger" forKey:@"N"];

    [fingerprint_Dict setObject:@"cfc_keep_index_finger" forKey:@"Y"];
    [fingerprint_Dict setObject:@"cfc_keep_middle_finger" forKey:@"N"];
    [fingerprint_Dict setObject:@"cfc_keep_ring_finger" forKey:@"N"];
    [fingerprint_Dict setObject:@"cfc_keep_baby_finger" forKey:@"N"];

    [fingerprint_Dict setObject:@"cfc_zoom_camera" forKey:@"1"];
    [fingerprint_Dict setObject:@"cfc_process_4k_image" forKey:@"N"];
    [fingerprint_Dict setObject:@"cfc_show_instruction_screen" forKey:@"Y"];
    [AppItSDK captureFourFingerprint:rootViewController cameraFingerCaptureConfig:fingerprint_Dict];
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
