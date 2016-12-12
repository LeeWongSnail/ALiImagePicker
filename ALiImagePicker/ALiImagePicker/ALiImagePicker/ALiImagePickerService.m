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
    NSString *defaultTitle;
}

@property (nonatomic, strong) NSMutableDictionary *smartAlbums;
@property (nonatomic, strong) NSMutableDictionary *videoAlbums;

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
        self.smartAlbums = [NSMutableDictionary dictionary];
        self.videoAlbums = [NSMutableDictionary dictionary];
        [self fetchAllImages];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
        
    }
    return self;
}

- (void)fetchImageGroupWithTypes:(EALiPickerResourceType)sourceType completion:(void (^)(NSArray *info))aCompletion;
{
    NSMutableArray *arrM = [NSMutableArray array];
    if (sourceType == EALiPickerResourceTypeImage) {
        [self.smartAlbums enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSArray *arrT = obj[kPHImage];
            [arrM addObject:@{kPHImage:arrT.firstObject,kPHTitle:obj[kPHTitle],kPHCount:obj[kPHCount]}];
        }];
    } else if (sourceType == EALiPickerResourceTypeVideo){
        [self.videoAlbums enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSArray *arrT = obj[kPHImage];
            [arrM addObject:@{kPHImage:arrT.firstObject,kPHTitle:obj[kPHTitle],kPHCount:obj[kPHCount]}];
        }];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        aCompletion([arrM copy]);
    });
}

- (void)fectchAssetsWithMediaType:(EALiPickerResourceType)aType  completion:(void (^)(NSString *title,NSArray *assets))aCompletion;
{

   [self fetchAssetsWithMediaType:aType groupTitle:defaultTitle completion:aCompletion];
}

- (void)fetchAssetsWithMediaType:(EALiPickerResourceType)aType groupTitle:(NSString *)aTitle completion:(void (^)(NSString *title,NSArray *assets))aCompletion
{
    if (aType == EALiPickerResourceTypeImage) {
        NSDictionary *dict = [self.smartAlbums valueForKey:aTitle];
        dispatch_async(dispatch_get_main_queue(), ^{
            aCompletion(dict[kPHTitle],dict[kPHImage]);
        });
    } else if (aType == EALiPickerResourceTypeVideo) {
        NSDictionary *dict = [self.videoAlbums valueForKey:aTitle];
        dispatch_async(dispatch_get_main_queue(), ^{
            aCompletion(dict[kPHTitle],dict[kPHImage]);
        });
    }
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

#pragma mark - fetch All Images

- (void)fetchAllImages
{
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d",PHAssetMediaTypeImage];
    [self fetchSmartAlbumGeneric:options];
    [self fetchSmartAlbumScreenshots:options];
    [self fetchSmartAlbumUserLibrary:options];
}

- (void)fetchAllVideos
{
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d",PHAssetMediaTypeVideo];
    [self fetchSmartAlbumGeneric:options];
    [self fetchSmartAlbumScreenshots:options];
    [self fetchSmartAlbumUserLibrary:options];
}


- (void)fetchSmartAlbumUserLibrary:(PHFetchOptions *)options
{
    //1所有照片
    __block NSMutableArray *assets = [NSMutableArray array];
    
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    PHAssetCollection *assetCollection = smartAlbums.firstObject;
    PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:smartAlbums.firstObject options:options];
    NSLog(@"sub album title is %@, count is %ld", assetCollection.localizedTitle, assetsFetchResult.count);
    if (assetsFetchResult.count > 0) {
        for (PHAsset *obj in assetsFetchResult) {
            //you have got your image type asset.
            ALiAsset *asset = [[ALiAsset alloc] init];
            asset.asset = obj;
            [assets addObject:asset];
        }
        NSDictionary *dict = @{kPHImage:[assets copy],kPHTitle:assetCollection.localizedTitle,kPHCount:@(assetsFetchResult.count)};
        [self.smartAlbums setObject:dict forKey:assetCollection.localizedTitle];
        defaultTitle = assetCollection.localizedTitle;
    }    
}

- (void)fetchSmartAlbumScreenshots:(PHFetchOptions *)options
{
    
    __block NSMutableArray *assets = [NSMutableArray array];
    //2 屏幕截图
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumScreenshots options:nil];
    PHAssetCollection *assetCollection = smartAlbums.firstObject;
    PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:smartAlbums.firstObject options:options];
    NSLog(@"sub album title is %@, count is %ld", assetCollection.localizedTitle, assetsFetchResult.count);
    if (assetsFetchResult.count > 0) {
        for (PHAsset *obj in assetsFetchResult) {
            //you have got your image type asset.
            ALiAsset *asset = [[ALiAsset alloc] init];
            asset.asset = obj;
            [assets addObject:asset];
        }
        NSDictionary *dict = @{kPHImage:[assets copy],kPHTitle:assetCollection.localizedTitle,kPHCount:@(assetsFetchResult.count)};
        [self.smartAlbums setObject:dict forKey:assetCollection.localizedTitle];
    }
}

- (void)fetchSmartAlbumGeneric:(PHFetchOptions *)options
{
    __block NSMutableArray *assets = [NSMutableArray array];
    //3、自己生成的
    PHFetchResult<PHAssetCollection *> *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in smartAlbums) {
        PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:options];
        NSLog(@"sub album title is %@, count is %ld", collection.localizedTitle, assetsFetchResult.count);
        
        if (assetsFetchResult.count > 0) {
            for (PHAsset *obj in assetsFetchResult) {
                //you have got your image type asset.
                ALiAsset *asset = [[ALiAsset alloc] init];
                asset.asset = obj;
                [assets addObject:asset];
            }
            NSDictionary *dict = @{kPHImage:[assets copy],kPHTitle:collection.localizedTitle,kPHCount:@(assetsFetchResult.count)};
            [self.smartAlbums setObject:dict forKey:collection.localizedTitle];
        }
        
        
    }
}

- (void)enterForeground:(NSNotification *)noti
{
    if (self.smartAlbums.count > 0) {
        [self fetchAllImages];
    }
}


@end
