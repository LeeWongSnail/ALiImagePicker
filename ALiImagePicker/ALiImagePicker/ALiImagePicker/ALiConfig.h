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


@interface ALiConfig : NSObject

@end
