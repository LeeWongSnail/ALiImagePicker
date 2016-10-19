//
//  ALiImagePickerController.h
//  ALiImagePicker
//
//  Created by LeeWong on 2016/10/15.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALiImagePickerController : UIViewController

@property (nonatomic, strong, readonly) NSMutableArray *selectAssets;

@property (nonatomic, copy) void (^photoChooseBlock)(NSArray *selectAssets);

@end
