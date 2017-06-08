//
//  QRScannerViewController.m
//  QRcode
//
//  Created by wheng on 17/6/8.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "QRScannerViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface QRScannerViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong)AVCaptureDevice            *device;
@property (nonatomic, strong)AVCaptureDeviceInput       *input;
@property (nonatomic, strong)AVCaptureMetadataOutput    *output;
@property (nonatomic, strong)AVCaptureSession           *session;
@property (nonatomic, strong)AVCaptureVideoPreviewLayer *previewlayer;

@end

@implementation QRScannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initDevice];
}

- (void)initDevice {
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.input  = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    self.output = [[AVCaptureMetadataOutput alloc] init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    self.session = [[AVCaptureSession alloc] init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
    }
    
    [self.output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    self.previewlayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    [self.previewlayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    [self.previewlayer setFrame:self.view.layer.bounds];
    
    [self.view.layer insertSublayer:self.previewlayer atIndex:0];
    
    [self.session startRunning];
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    NSString *stringValue;
    if ([metadataObjects count] >0){
        //停止扫描
        [self.session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        
        UIAlertController *alerController = [UIAlertController alertControllerWithTitle:@"扫描结果" message:stringValue preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.session startRunning];
        }];
        [alerController addAction:action];
        [self presentViewController:alerController animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
