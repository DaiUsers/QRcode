//
//  ViewController.m
//  QRcode
//
//  Created by wheng on 17/6/7.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "ViewController.h"
#import "QRScannerViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.navigationItem setTitle:@"QRCode"];
    
    [self initQRScannerFeature];
    
}

- (void)initQRScannerFeature {
    UIButton *qrScanner = [[UIButton alloc] initWithFrame:CGRectMake(10, 100, 100, 44)];
    [self.view addSubview:qrScanner];
    
    [qrScanner setBackgroundColor:[UIColor redColor]];
    [qrScanner setTitle:@"QRScanner" forState:UIControlStateNormal];
    [qrScanner addTarget:self action:@selector(scanner) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark Action

- (void)scanner {
    QRScannerViewController *scannerController = [[QRScannerViewController alloc] init];
    [self.navigationController pushViewController:scannerController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
