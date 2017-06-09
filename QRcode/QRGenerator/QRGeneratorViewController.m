//
//  QRGeneratorViewController.m
//  QRcode
//
//  Created by wheng on 17/6/8.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "QRGeneratorViewController.h"

@interface QRGeneratorViewController ()

@end

@implementation QRGeneratorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.center.x - 50, 100, 100, 100)];
    [self.view addSubview:imageView];
    
    imageView.image = [self qrImageWithString:@"https://github.com/DaiUsers/QRcode" size:100];
}

- (UIImage *)qrImageWithString:(NSString *)string size:(CGFloat)size {
    CIImage *qrCIImage = [self qrCIImageFromeString:string];
    
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrCIImage fromRect:qrCIImage.extent];
    UIGraphicsBeginImageContext(CGSizeMake(size, size));
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(contextRef, kCGInterpolationNone);
    CGContextScaleCTM(contextRef, 1.0, -1.0);
    CGContextDrawImage(contextRef, CGContextGetClipBoundingBox(contextRef), cgImage);
    UIImage *qrImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);
    return qrImage;
}

- (CIImage *)qrCIImageFromeString:(NSString *)string {
    NSData *stringData = [string dataUsingEncoding:NSUTF8StringEncoding];
    //滤镜，类型->CIQRCodeGenerator
    CIFilter *qrfilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrfilter setValue:stringData forKey:@"inputMessage"];
    //错误修正容量 L(7%)/M(15%)/Q(25%)/H(30%)
    [qrfilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    UIColor *onColor  = [UIColor blackColor];
    UIColor *offColor = [UIColor whiteColor];
    
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor" keysAndValues:@"inputImage",qrfilter.outputImage,@"inputColor0",[CIColor colorWithCGColor:onColor.CGColor],@"inputColor1",[CIColor colorWithCGColor:offColor.CGColor], nil];
    
    return colorFilter.outputImage;
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
