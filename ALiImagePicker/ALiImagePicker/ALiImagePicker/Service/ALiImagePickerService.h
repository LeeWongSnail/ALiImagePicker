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

+ (instancetype)shared;

/**
 获取某一种类型的所b有资源

 @param aType EALiPickerResourceType  图片 视频和音频

 @return 返回这种类型的所有结果
 */
- (NSArray *)fectchAssetsWithMediaType:(EALiPickerResourceType)aType;


/**
 获取某一种类型的 符合一定筛选条件的资源
 
 @param aType    EALiPickerResourceType  图片 视频和音频
 @param aOptions 筛选条件
 
 @return 符合筛选条件的资源集合
 */
- (NSArray *)fetchAssetsWithMediaType:(EALiPickerResourceType)aType options:(PHFetchOptions *)aOptions;



/**
 获取相册中的分组

 @param sourceType      需要获取的类型集合
 @param aCompletion 获取分组完成的回调
 */
- (void)fetchImageGroupWithTypes:(EALiPickerResourceType)sourceType completion:(void (^)(PHFetchResult *result))aCompletion;


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
- (void)startCachingImagesForAssets:(NSArray<ALiAsset *> *)assets targetSize:(CGSize)targetSize contentMode:(PHImageContentMode)contentMode options:(nullable PHImageRequestOptions *)options;

@end
