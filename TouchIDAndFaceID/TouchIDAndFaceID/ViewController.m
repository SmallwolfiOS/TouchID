//
//  ViewController.m
//  TouchIDAndFaceID
//
//  Created by baidu on 2018/10/29.
//  Copyright © 2018 mahp. All rights reserved.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)



@interface ViewController ()
@property (nonatomic,strong)LAContext   * LAContext;
@property (nonatomic,strong)UILabel     * lblMsg;
@property (nonatomic,strong)UIButton    * btnCheck;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self intiSubUI];
    [self function];
    
    
}
- (void)intiSubUI{
    self.lblMsg = [[UILabel alloc]initWithFrame:CGRectMake(30, 100, SCREEN_WIDTH - 60, 50)];
    self.lblMsg.textAlignment = NSTextAlignmentCenter;
    self.lblMsg.layer.borderWidth = 0.5f;
    self.lblMsg.layer.borderColor = [UIColor redColor].CGColor;
    [self.view addSubview:self.lblMsg];
    
    self.btnCheck = [[UIButton alloc]initWithFrame:CGRectMake(30, 170, SCREEN_WIDTH - 60, 50)];
    self.btnCheck.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.btnCheck.layer.borderWidth = 0.5f;
    self.btnCheck.layer.borderColor = [UIColor redColor].CGColor;
    [self.view addSubview:self.btnCheck];
    
    
    
}
- (void)function{
    //检测当前设备是否支持TouchID或者FaceID
    if (@available(iOS 8.0, *)) {
        self.LAContext = [[LAContext alloc]init];
        NSError * authError = nil;
         BOOL isCanEvaluatePolicy = [self.LAContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError];
        if (authError) {
            NSLog(@"检测设备是否支持TouchID或者FaceID失败！\n error : == %@",authError.localizedDescription);
            [self showAlertView:[NSString stringWithFormat:@"检测设备是否支持TouchID或者FaceID失败。\n errorCode : %ld\n errorMsg : %@",(long)authError.code, authError.localizedDescription]];
        } else {
            if (isCanEvaluatePolicy) {
                // 判断设备支持TouchID还是FaceID
                if (@available(iOS 11.0, *)) {
                    switch (self.LAContext.biometryType) {
                        case LABiometryTypeNone:
                        {
                            [self justSupportBiometricsType:0];
                        }
                            break;
                        case LABiometryTypeTouchID:
                        {
                            [self justSupportBiometricsType:1];
                        }
                            break;
                        case LABiometryTypeFaceID:
                        {
                            [self justSupportBiometricsType:2];
                        }
                            break;
                        default:
                            break;
                    }
                } else {
                    // Fallback on earlier versions
                    NSLog(@"iOS 11之前不需要判断 biometryType");
                    // 因为iPhoneX起始系统版本都已经是iOS11.0，所以iOS11.0系统版本下不需要再去判断是否支持faceID，直接走支持TouchID逻辑即可。
                    [self justSupportBiometricsType:1];
                }
                
            } else {
                [self justSupportBiometricsType:0];
            }
        }
    }
    
    
    
}
// 判断生物识别类型，更新UI
- (void)justSupportBiometricsType:(NSInteger)biometryType{
    switch (biometryType) {
        case 0:
        {
            NSLog(@"该设备支持不支持FaceID和TouchID");
            self.lblMsg.text = @"该设备支持不支持FaceID和TouchID";
            self.lblMsg.textColor = [UIColor redColor];
            self.btnCheck.enabled = NO;
        }
            break;
        case 1:
        {
            NSLog(@"该设备支持TouchID");
            self.lblMsg.text = @"该设备支持Touch ID";
            [self.btnCheck setTitle:@"点击开始验证Touch ID" forState:UIControlStateNormal];
            self.btnCheck.enabled = YES;
        }
            break;
        case 2:
        {
            NSLog(@"该设备支持Face ID");
            self.lblMsg.text = @"该设备支持Face ID";
            [self.btnCheck setTitle:@"点击开始验证Face ID" forState:UIControlStateNormal];
            self.btnCheck.enabled = YES;
        }
            break;
        default:
            break;
    }
}
// 弹框
- (void)showAlertView:(NSString *)msg
{
    NSLog(@"%@",msg);
    if (@available(iOS 8.0, *)) {
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        //过期的方法
        // Fallback on earlier versions
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
#pragma clang diagnostic pop
       
    }
}

    
    
@end
