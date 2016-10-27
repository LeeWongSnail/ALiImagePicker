//
//  ALiImagePickerFooterView.h
//  ALiImagePicker
//
//  Created by LeeWong on 2016/10/20.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALiImagePickerFooterView : UICollectionReusableView

- (void)configFooterViewImageCount:(NSInteger)imageCount videoCount:(NSInteger)videoCount updateTime:(NSString *)aTime;

@end
