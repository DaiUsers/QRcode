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
    [self addBackGroundView];
}

- (void)initDevice {
    //摄像设配
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //输入流
    self.input  = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
   //输出流
    self.output = [[AVCaptureMetadataOutput alloc] init];
    //设置代理 主线程调用
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //连接
    self.session = [[AVCaptureSession alloc] init];
    //分辨度高
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
    }
    //输出流支持的对象格式（QRCode）
    [self.output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    //实时预览层
    self.previewlayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    //AVLayerVideoGravityResizeAspectFill （Preserve aspect ratio; fill layer bounds）
    //AVLayerVideoGravityResizeAspect      (Preserve aspect ratio; fit within layer bounds)
    [self.previewlayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    [self.previewlayer setFrame:self.view.bounds];
    
    [self.view.layer addSublayer:self.previewlayer];
    [self.session startRunning];

    CGRect rect         = CGRectMake(self.view.center.x - 100, 100, 200, 200);
    //it work after session.startRunning (transform rect)
    CGRect interRect    = [self.previewlayer metadataOutputRectOfInterestForRect:rect];
    
    self.output.rectOfInterest = interRect;
    
    
}

- (void)addBackGroundView {
    UIView *frameView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:frameView];
    
    frameView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:self.view.bounds];
    UIBezierPath *centerPath = [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(30, 100, self.view.bounds.size.width - 60, 300) cornerRadius:2.0] bezierPathByReversingPath];;
    [maskPath appendPath:centerPath];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path = maskPath.CGPath;

    frameView.layer.mask = maskLayer;
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
