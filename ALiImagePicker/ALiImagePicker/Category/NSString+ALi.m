//
//  NSString+ALi.m
//  ALiImagePicker
//
//  Created by LeeWong on 2016/11/3.
//  Copyright © 2016年 LeeWong. All rights reserved.
//

#import "NSString+ALi.h"

@implementation NSString (ALi)

-(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

@end
