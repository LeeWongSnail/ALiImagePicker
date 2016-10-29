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
    }
    return self;
}

- (void)fetchImageGroupWithTypes:(EALiPickerResourceType)sourceType completion:(void (^)(PHFetchResult *result))aCompletion;
{
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.includeAssetSourceTypes = PHAssetSourceTypeUserLibrary;
    
    PHAssetCollectionSubtype subType = 0;
    if (sourceType == EALiPickerResourceTypeImage) {
        subType = PHAssetCollectionSubtypeSmartAlbumUserLibrary|PHAssetCollectionSubtypeSmartAlbumRecentlyAdded|PHAssetCollectionSubtypeSmartAlbumSelfPortraits|PHAssetCollectionSubtypeSmartAlbumScreenshots|PHAssetCollectionSubtypeSmartAlbumFavorites|PHAssetCollectionSubtypeSmartAlbumPanoramas;
    } else if (sourceType == EALiPickerResourceTypeVideo){
        subType = PHAssetCollectionSubtypeSmartAlbumVideos|PHAssetCollectionSubtypeSmartAlbumSlomoVideos|PHAssetCollectionSubtypeSmartAlbumTimelapses;
    }
    
    PHFetchResult *result = [PHAssetCollection fetchAssetCollectionsWithType:(PHAssetCollectionTypeSmartAlbum) subtype:subType options:option];
    if (aCompletion) {
        aCompletion(result);
    }
}

- (NSArray *)fectchAssetsWithMediaType:(EALiPickerResourceType)aType
{
   return [self fetchAssetsWithMediaType:aType options:nil];
}

- (NSArray *)fetchAssetsWithMediaType:(EALiPickerResourceType)aType options:(PHFetchOptions *)aOptions
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

- (void)startCachingImagesForAssets:(NSArray<ALiAsset *> *)assets
{
     PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
    [self startCachingImagesForAssets:assets targetSize:CGSizeMake(SCREEN_W, SCREEN_H) contentMode:PHImageContentModeAspectFill options:imageRequestOptions];
}


- (void)startCachingImagesForAssets:(NSArray<ALiAsset *> *)assets targetSize:(CGSize)targetSize contentMode:(PHImageContentMode)contentMode options:(PHImageRequestOptions *)options
{
//    [[PHCachingImageManager defaultManager] startCachingImagesForAssets:assets targetSize:targetSize contentMode:contentMode options:options];
}

@end
