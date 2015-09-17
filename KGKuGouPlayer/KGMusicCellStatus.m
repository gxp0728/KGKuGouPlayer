//
//  KGMusicCellStatus.m
//  KGKuGouPlayer
//
//  Created by neuedu on 15/9/17.
//  Copyright (c) 2015年 gxp. All rights reserved.
//

#import "KGMusicCellStatus.h"

@implementation KGMusicCellStatus
+(instancetype)musicCellStatusWithDict:(NSDictionary *)dictionary{
    KGMusicCellStatus*status=[[KGMusicCellStatus alloc]init];
    if (status) {
        [status setValuesForKeysWithDictionary:dictionary];
    }
    return status;
}
@end
