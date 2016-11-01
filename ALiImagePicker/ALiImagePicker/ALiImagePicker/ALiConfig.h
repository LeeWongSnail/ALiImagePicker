//
//  ALiConfig.h
//  ALiImagePicker
//
//  Created by LeeWong on 2016/10/28.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, EALiPickerResourceType){
    EALiPickerResourceTypeUnknown = 0,
    EALiPickerResourceTypeImage   = 1,
    EALiPickerResourceTypeVideo   = 2,
    EALiPickerResourceTypeAudio   = 3,
};

typedef NS_ENUM(NSInteger, EALiImageContentMode) {
    EALiImageContentModeAspectFit = 0,
    EALiImageContentModeAspectFill = 1,
    EALiImageContentModeDefault = PHImageContentModeAspectFit
};

static const NSString *kPHImage = @"PHImage";
static const NSString *kPHTitle = @"PHTitle";
static const NSString *kPHCount = @"PHCount";


@interface ALiConfig : NSObject

@end
