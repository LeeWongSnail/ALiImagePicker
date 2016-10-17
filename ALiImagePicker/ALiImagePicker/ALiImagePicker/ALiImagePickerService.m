//
//  ALiImagePickerService.m
//  ALiImagePicker
//
//  Created by LeeWong on 2016/10/17.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import "ALiImagePickerService.h"
#import "ALiAsset.h"

@interface ALiImagePickerService ()
{
    CGSize imageSize;
    EALiImageContentMode contentMode;
}


@end

@implementation ALiImagePickerService

+ (instancetype)shared
{
    static ALiImagePickerService   *photoAlbumManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        photoAlbumManager = [[self alloc] init];
    });
    
    return photoAlbumManager;
}

- (instancetype)init
{
    if (self = [super init]) {
        imageSize = CGSizeMake(70, 70);
        contentMode = EALiImageContentModeDefault;
    }
    return self;
}


- (NSArray *)aliFectchAssetsWithMediaType:(EALiPickerResourceType)aType
{
   return [self ali_fetchAssetsWithMediaType:aType options:nil];
}



- (NSArray *)ali_fetchAssetsWithMediaType:(EALiPickerResourceType)aType options:(PHFetchOptions *)aOptions
{
    PHFetchResult *result = [PHAsset fetchAssetsWithMediaType:[@(aType) integerValue] options:aOptions];
    
    __block NSMutableArray *assets = [NSMutableArray array];
    
    [result enumerateObjectsUsingBlock:^(PHAsset *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ALiAsset *asset = [[ALiAsset alloc] init];
        asset.asset = obj;
        [assets addObject:asset];
    }];
    
    return [assets copy];
}


- (void)ali_fetchImageForAsset:(ALiAsset *)asset completion:(void (^)(UIImage *image,NSDictionary *info))aCompletion
{
    [self ali_fetchImageForAsset:asset targetSize:imageSize contentMode:contentMode options:nil completion:aCompletion];
}


- (void)ali_fetchImageForAsset:(ALiAsset *)asset targetSize:(CGSize)aSize contentMode:(EALiImageContentMode)aType options:(PHImageRequestOptions *)options completion:(void (^)(UIImage *image,NSDictionary *info))aCompletion
{
    [[PHImageManager defaultManager] requestImageForAsset:asset.asset targetSize:aSize contentMode:[@(aType) integerValue] options:options resultHandler:aCompletion];
}

@end
