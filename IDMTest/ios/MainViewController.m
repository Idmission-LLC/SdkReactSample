//
//  MainViewController.m
//  idmission
//

#import "MainViewController.h"
#import "IDMissionSDK.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  NSLog(@"View Did Load");
}

- (void)captureImageResponse:(NSMutableDictionary *)result
{
  NSLog(@"captureImageResponse Response : %@ ", result);
  
  NSMutableDictionary *nsDict = [[NSMutableDictionary alloc] init];
  
  NSString *statusCode = [result objectForKey:@"statusCode"];
  NSString *statusMessage = [result objectForKey:@"statusMessage"];
  
  [nsDict setObject:statusMessage forKey:@"statusMessage"];
  [nsDict setObject:statusCode forKey:@"statusCode"];
    
  if([[result objectForKey:@"statusCode"] isEqualToString:@"0"]) {
    NSString *front = [result objectForKey:@"FRONT"];
    NSString *back = [result objectForKey:@"BACK"];
    
    if(nil != front){
      [nsDict setObject:front forKey:@"front"];
    }else if(nil != back){
      [nsDict setObject:back forKey:@"back"];
    }
  }

  NSLog(@"Response : %@ ", nsDict);
  [IDMissionSDK getEvent:@"DataCallback" dict:nsDict];
}

- (void)faceDetectionResponse:(NSMutableDictionary *)result
{
  NSLog(@"faceDetectionResponse Response : %@ ", result);
  
  NSMutableDictionary *nsDict = [[NSMutableDictionary alloc] init];
  
  NSString *statusCode = [result objectForKey:@"statusCode"];
  NSString *statusMessage = [result objectForKey:@"statusMessage"];
  
  [nsDict setObject:statusMessage forKey:@"statusMessage"];
  [nsDict setObject:statusCode forKey:@"statusCode"];
  
  if([[result objectForKey:@"statusCode"] isEqualToString:@"0"]) {
    NSString *face = [result objectForKey:@"FACE"];
    NSString *processed_face = [result objectForKey:@"PROCESSED_FACE"];
    NSString *oval_face = [result objectForKey:@"OVAL_FACE"];
    
    if(nil != face){
      [nsDict setObject:face forKey:@"face"];
    }else if(nil != processed_face){
      [nsDict setObject:processed_face forKey:@"processed_face"];
    }else if(nil != oval_face){
      [nsDict setObject:oval_face forKey:@"oval_face"];
    }
  }
  
  NSLog(@"Response : %@ ", nsDict);
  [IDMissionSDK getEvent:@"DataCallback" dict:nsDict];
}

- (void)processImageAndFaceMatchingResponse:(NSMutableDictionary *)result
{
  NSLog(@"processImageAndFaceMatchingResponse Response : %@ ", result);
  
  NSMutableDictionary *nsDict = [[NSMutableDictionary alloc] init];
  
  NSString *statusCode = [result objectForKey:@"statusCode"];
  NSString *statusMessage = [result objectForKey:@"statusMessage"];
  
  [nsDict setObject:statusMessage forKey:@"statusMessage"];
  [nsDict setObject:statusCode forKey:@"statusCode"];
  
  if([[result objectForKey:@"statusCode"] isEqualToString:@"0"]) {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:result options:NSJSONWritingPrettyPrinted error:&error];

    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [nsDict setObject:jsonString forKey:@"data"];
    }
  }
  
  NSLog(@"Response : %@ ", nsDict);
  [IDMissionSDK getEvent:@"DataCallback" dict:nsDict];
}

@end

