//
//  ViewController.m
//  ALiImagePicker
//
//  Created by LeeWong on 2016/10/14.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import "ViewController.h"
#import "ALiImagePickerController.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)openPhotoLibary:(UIButton *)sender {
    ALiImagePickerController *imagePicker = [[ALiImagePickerController alloc] init];
    imagePicker.sourceType = EALiPickerResourceTypeImage;
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:imagePicker];
    [self.navigationController presentViewController:navi animated:YES completion:nil];
    
    imagePicker.photoChooseBlock = ^(NSArray *assets){
        NSLog(@"%@",assets);
    };
    
}

- (IBAction)openVideoLibary:(UIButton *)sender {
    ALiImagePickerController *imagePicker = [[ALiImagePickerController alloc] init];
    imagePicker.sourceType = EALiPickerResourceTypeVideo;
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:imagePicker];
    [self.navigationController presentViewController:navi animated:YES completion:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
