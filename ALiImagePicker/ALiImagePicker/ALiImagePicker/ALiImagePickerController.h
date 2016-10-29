//
//  ALiImagePickerController.h
//  ALiImagePicker
//
//  Created by LeeWong on 2016/10/15.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALiConfig.h"


@interface ALiImagePickerController : UIViewController

@property (nonatomic, assign) EALiPickerResourceType sourceType;

@property (nonatomic, copy) void (^photoChooseBlock)(NSArray *selectAssets);

@end
