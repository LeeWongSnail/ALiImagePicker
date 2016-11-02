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
@property (nonatomic, assign) CGFloat imageSize;

@end

@implementation ALiAsset

- (void)setAsset:(PHAsset *)asset
{
    _asset = asset;
}

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

//如果需要获取任何图片相关的信息可以使用这个方法
//UIImage *displaySizeImage;
//NSURL *fullSizeImageURL;
//fullSizeImageOrientation; // EXIF value

- (CGFloat)imageSize
{
    if (_imageSize == 0) {
        [self getImageInfo];
    }
    return _imageSize;
}

- (void)getImageInfo
{
    PHContentEditingInputRequestOptions *options = [[PHContentEditingInputRequestOptions alloc] init];
     [self.asset requestContentEditingInputWithOptions:options completionHandler:^(PHContentEditingInput *contentEditingInput, NSDictionary *info) {
        
//        CIImage *fullImage = [CIImage imageWithContentsOfURL:contentEditingInput.fullSizeImageURL];
//        NSLog(@"%@",contentEditingInput.fullSizeImageURL);//get url
//        NSLog(@"%@", fullImage.properties.description);//get {TIFF}, {Exif}
         
         long long fileSize = [ALiAsset fileSizeAtPath:contentEditingInput.fullSizeImageURL.path];
         self.imageSize = fileSize/1000000.;
    }];
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
    phImageRequestOptions.synchronous = YES;
    // 在 PHImageManager 中，targetSize 等 size 都是使用 px 作为单位，因此需要对targetSize 中对传入的 Size 进行处理，宽高各自乘以 ScreenScale，从而得到正确的图片
    
    CGSize imageSize = CGSizeMake(size.width * screenScale, size.height * screenScale);
    [[PHImageManager defaultManager] requestImageForAsset:self.asset
                                              targetSize:imageSize
                                             contentMode:PHImageContentModeAspectFill options:phImageRequestOptions
                                           resultHandler:^(UIImage *result, NSDictionary *info) {
                                               if ([[info valueForKey:@"PHImageResultIsDegradedKey"]integerValue]==0){
                                                   // Do something with the FULL SIZED image
                                                   resultImage = result;
                                               } else {
                                                   // Do something with the regraded image
                                                   resultImage = result;
                                               }
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
        //resizeMode设置为PHImageRequestOptionsResizeModeExact 则返回图像必须和目标大小相匹配，并且图像质量也为高质量图像，而设置为 PHImageRequestOptionsResizeModeFast 则请求的效率更高，但返回的图像可能和目标大小不一样并且质量较低。
//        synchronous: Bool // 请求是同步还是异步的，默认是异步（false）。
//        deliveryMode: PHImageRequestOptionsDeliveryMode // 图片质量，默认是 PHImageRequestOptionsDeliveryModeOpportunistic，在同步请求时会回调一次，在异步请求时会回调多次。另两个参数则只会回调一次。
//        networkAccessAllowed: Bool // 是否允许网络请求（如果需要从iCloud下载图片），默认是不允许（false）
    //        imageRequestOptions.networkAccessAllowed = YES;
    //        imageRequestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    //        imageRequestOptions.synchronous = YES;
//        imageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeFast;
        imageRequestOptions.version = PHImageRequestOptionsVersionCurrent;
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


#pragma mark - Private Method
+ (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
@end
