//
//  ALiAsset.m
//  ALiImagePicker
//
//  Created by LeeWong on 2016/10/15.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import "ALiAsset.h"

#define screenScale [UIScreen mainScreen].scale

@interface ALiAsset ()

@property (nonatomic, strong) UIImage *orignImage;
@property (nonatomic, strong) UIImage *thumbImage;
@property (nonatomic, strong) UIImage *previewImage;
@end

@implementation ALiAsset

- (UIImage *)orignImage
{
    if (_orignImage) {
        return _orignImage;
    }
    
    __block UIImage *resultImage;
    
    PHImageRequestOptions *phImageRequestOptions = [[PHImageRequestOptions alloc] init];
    phImageRequestOptions.synchronous = YES;
    [[PHImageManager defaultManager] requestImageForAsset:self.asset
                                               targetSize:PHImageManagerMaximumSize
                                              contentMode:PHImageContentModeDefault
                                                  options:phImageRequestOptions
                                            resultHandler:^(UIImage *result, NSDictionary *info) {
                                                resultImage = result;
                                            }];
    _orignImage = resultImage;
    return resultImage;
    
}

- (void)fetchOriginImageWithCompletion:(void (^)(UIImage *, NSDictionary *))completion withProgressHandler:(PHAssetImageProgressHandler)phProgressHandler
{
    if (_orignImage) {
        // 如果已经有缓存的图片则直接拿缓存的图片
        if (completion) {
            completion(_orignImage, nil);
        }
    } else {
        PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
        imageRequestOptions.networkAccessAllowed = YES; // 允许访问网络
        imageRequestOptions.progressHandler = phProgressHandler;
        [[PHImageManager defaultManager] requestImageForAsset:self.asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:imageRequestOptions resultHandler:^(UIImage *result, NSDictionary *info) {
            // 排除取消，错误，低清图三种情况，即已经获取到了高清图时，把这张高清图缓存到 _originImage 中
            BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
            if (downloadFinined) {
                _orignImage = result;
            }
            if (completion) {
                completion(result, info);
            }
        }];
    }
}

- (UIImage *)thumbnailWithSize:(CGSize)size
{
    if (_thumbImage) {
        return _thumbImage;
    }
    __block UIImage *resultImage;

        PHImageRequestOptions *phImageRequestOptions = [[PHImageRequestOptions alloc] init];
        phImageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
        // 在 PHImageManager 中，targetSize 等 size 都是使用 px 作为单位，因此需要对targetSize 中对传入的 Size 进行处理，宽高各自乘以 ScreenScale，从而得到正确的图片
        [[PHImageManager defaultManager] requestImageForAsset:self.asset
                                                  targetSize:CGSizeMake(size.width * screenScale, size.height * screenScale)
                                                 contentMode:PHImageContentModeAspectFill options:phImageRequestOptions
                                               resultHandler:^(UIImage *result, NSDictionary *info) {
                                                   resultImage = result;
                                               }];
       _thumbImage = resultImage;
    return resultImage;
}


- (void)fetchThumbnailImageWithSize:(CGSize)size completion:(void (^)(UIImage *, NSDictionary *))completion
{
    if (_thumbImage) {
        if (completion) {
            completion(_thumbImage, nil);
        }
    } else {
        PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
        imageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
        // 在 PHImageManager 中，targetSize 等 size 都是使用 px 作为单位，因此需要对targetSize 中对传入的 Size 进行处理，宽高各自乘以 ScreenScale，从而得到正确的图片
        [[PHImageManager defaultManager] requestImageForAsset:self.asset targetSize:CGSizeMake(size.width * screenScale, size.height * screenScale) contentMode:PHImageContentModeAspectFill options:imageRequestOptions resultHandler:^(UIImage *result, NSDictionary *info) {
            // 排除取消，错误，低清图三种情况，即已经获取到了高清图时，把这张高清图缓存到 _thumbnailImage 中
            BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
            if (downloadFinined) {
                _thumbImage = result;
            }
            if (completion) {
                completion(result, info);
            }
        }];
    }
}

- (UIImage *)previewImage {
    if (_previewImage) {
        return _previewImage;
    }
    __block UIImage *resultImage;

        PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
        imageRequestOptions.synchronous = YES;
        [[PHImageManager defaultManager]  requestImageForAsset:self.asset
                                                  targetSize:CGSizeMake(SCREEN_W, SCREEN_H)
                                                 contentMode:PHImageContentModeAspectFill
                                                     options:imageRequestOptions
                                               resultHandler:^(UIImage *result, NSDictionary *info) {
                                                   resultImage = result;
                                               }];
       _previewImage = resultImage;
    return resultImage;
}

- (void)fetchPreviewImageWithCompletion:(void (^)(UIImage *, NSDictionary *))completion withProgressHandler:(PHAssetImageProgressHandler)phProgressHandler
{
    if (_previewImage) {
        // 如果已经有缓存的图片则直接拿缓存的图片
        if (completion) {
            completion(_previewImage, nil);
        }
    } else {
        PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
        imageRequestOptions.networkAccessAllowed = YES; // 允许访问网络
        imageRequestOptions.progressHandler = phProgressHandler;
        [[PHImageManager defaultManager] requestImageForAsset:self.asset targetSize:CGSizeMake(SCREEN_W, SCREEN_H) contentMode:PHImageContentModeAspectFill options:imageRequestOptions resultHandler:^(UIImage *result, NSDictionary *info) {
            // 排除取消，错误，低清图三种情况，即已经获取到了高清图时，把这张高清图缓存到 _previewImage 中
            BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
            if (downloadFinined) {
                _previewImage = result;
            }
            if (completion) {
                completion(result, info);
            }
        }];
    }
}

@end
