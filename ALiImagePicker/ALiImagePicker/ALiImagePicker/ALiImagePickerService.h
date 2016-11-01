//
//  ALiImagePickerService.h
//  ALiImagePicker
//
//  Created by LeeWong on 2016/10/17.
//  Copyright © 2016年 LeeWong. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "ALiConfig.h"
@class ALiAsset;


@interface ALiImagePickerService : NSObject

+ (nonnull instancetype)shared;


/**
 获取某个分组的所有图片或者所有分组

 @param aType       资源来兴
 @param aCompletion 完成之后的回调
 */
- (void)fectchAssetsWithMediaType:(EALiPickerResourceType)aType completion:(void (^)(NSString *title,NSArray *assets))aCompletion;



/**
 获取指定分组的资源

 @param aType       获取的资源来兴
 @param aTitle      制定分组的标题
 @param aCompletion 完成的回调
 */
- (void)fetchAssetsWithMediaType:(EALiPickerResourceType)aType groupTitle:(NSString *)aTitle completion:(void (^)(NSString *title,NSArray *assets))aCompletion;



/**
 获取相册中的分组

 @param sourceType      需要获取的类型集合
 @param aCompletion 获取分组完成的回调
 */
- (void)fetchImageGroupWithTypes:(EALiPickerResourceType)sourceType completion:(void (^)(NSArray *info))aCompletion;


/**
 开始缓存图片(使用默认的一些配置)

 @param assets 需要缓存的内容
 */
- (void)startCachingImagesForAssets:(NSArray<ALiAsset *> *)assets;


/**
 开始缓存图片(使用自定义的一些配置)

 @param assets      图片自选
 @param targetSize  图片尺寸
 @param contentMode 图片展示方式
 @param options     图片的一些筛选条件，可能会影响到要展示图片的质量
 */
- (void)startCachingImagesForAssets:(NSArray<ALiAsset  *>  * )assets targetSize:(CGSize)targetSize contentMode:(PHImageContentMode)contentMode options:(nullable PHImageRequestOptions *)options;


@end
