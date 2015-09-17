//
//  KGMusicCellStatus.h
//  KGKuGouPlayer
//
//  Created by neuedu on 15/9/17.
//  Copyright (c) 2015年 gxp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KGMusicCellStatus : NSObject
@property(assign,nonatomic)BOOL selected;
+(instancetype)musicCellStatusWithDict:(NSDictionary*)dictionary;
@end
