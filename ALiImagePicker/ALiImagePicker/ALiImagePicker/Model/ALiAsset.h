//
//  ALiAsset.h
//  ALiImagePicker
//
//  Created by LeeWong on 2016/10/15.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALiAsset : NSObject

@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, assign, getter=isFullImage) BOOL fullImage;   //是否选择的原图
@property (nonatomic, assign, getter=isSelected) BOOL selected;      //是否被选中


/**
 获取图片的原图（同步方法，不推荐,图片过大可能阻塞主线程）
 
 @return 图片的原图
 */
- (UIImage *)orignImage;

/**
 *  异步请求 Asset 的原图，包含了系统照片“编辑”功能处理后的效果（剪裁，旋转和滤镜等），可能会有网络请求
 *
 *  @param completion        完成请求后调用的 block，参数中包含了请求的原图以及图片信息，在 iOS 8.0 或以上版本中，
 *                           这个 block 会被多次调用，其中第一次调用获取到的尺寸很小的低清图，然后不断调用，直接获取到高清图，
 *                           获取到高清图后 ALiAsset 会缓存起这张高清图，这时 block 中的第二个参数（图片信息）返回的为 nil。
 *  @param phProgressHandler 处理请求进度的 handler，不在主线程上执行，在 block 中修改 UI 时注意需要手工放到主线程处理。
 *
 *  @wraning iOS 8.0 以下中并没有异步请求预览图的接口，因此实际上为同步请求，这时 block 中的第二个参数（图片信息）返回的为 nil。
 */
- (void)fetchOriginImageWithCompletion:(void (^)(UIImage *orignImage, NSDictionary *info))completion withProgressHandler:(PHAssetImageProgressHandler)phProgressHandler;

/**
 *  Asset 的缩略图
 *
 *  @param size 指定返回的缩略图的大小
 *
 *  @return Asset 的缩略图
 */
- (UIImage *)thumbnailWithSize:(CGSize)size;

/**
 *  异步请求 Asset 的缩略图，不会产生网络请求
 *
 *  @param size       指定返回的缩略图的大小
 *  @param completion 完成请求后调用的 block，参数中包含了请求的缩略图以及图片信息，这个 block 会被多次调用，
 *                    其中第一次调用获取到的尺寸很小的低清图，然后不断调用，直接获取到高清图，获取到高清图后 ALiAsset 会缓存起这张高清图，
 *                    这时 block 中的第二个参数（图片信息）返回的为 nil。
 *
 */
- (void)fetchThumbnailImageWithSize:(CGSize)size completion:(void (^)(UIImage *, NSDictionary *))completion;

/**
 *  Asset 的预览图
 *
 *  @warning 仿照 ALAssetsLibrary 的做法输出与当前设备屏幕大小相同尺寸的图片，如果图片原图小于当前设备屏幕的尺寸，则只输出原图大小的图片
 *  @return Asset 的全屏图
 */
- (UIImage *)previewImage;

/**
 *  异步请求 Asset 的预览图，可能会有网络请求
 *
 *  @param completion        完成请求后调用的 block，参数中包含了请求的预览图以及图片信息，
 *                           这个 block 会被多次调用，其中第一次调用获取到的尺寸很小的低清图，然后不断调用，直接获取到高清图，
 *                           获取到高清图后 QMUIAsset 会缓存起这张高清图，这时 block 中的第二个参数（图片信息）返回的为 nil。
 *  @param phProgressHandler 处理请求进度的 handler，不在主线程上执行，在 block 中修改 UI 时注意需要手工放到主线程处理。
 *
 *  @wraning iOS 8.0 以下中并没有异步请求预览图的接口，因此实际上为同步请求，这时 block 中的第二个参数（图片信息）返回的为 nil。
 */
- (void)fetchPreviewImageWithCompletion:(void (^)(UIImage *, NSDictionary *))completion withProgressHandler:(PHAssetImageProgressHandler)phProgressHandler;
@end
