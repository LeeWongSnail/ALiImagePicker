//
//  ALiImagePickerService.h
//  ALiImagePicker
//
//  Created by LeeWong on 2016/10/17.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ALiAsset;

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

@interface ALiImagePickerService : NSObject

+ (instancetype)shared;

- (NSArray *)aliFectchAssetsWithMediaType:(EALiPickerResourceType)aType;

- (NSArray *)ali_fetchAssetsWithMediaType:(EALiPickerResourceType)aType options:(PHFetchOptions *)aOptions;

- (void)ali_fetchImageForAsset:(ALiAsset *)asset completion:(void (^)(UIImage *image,NSDictionary *info))aCompletion;

- (void)ali_fetchImageForAsset:(ALiAsset *)asset targetSize:(CGSize)aSize contentMode:(EALiImageContentMode)aType options:(PHImageRequestOptions *)options completion:(void (^)(UIImage *image,NSDictionary *info))aCompletion;



@end
