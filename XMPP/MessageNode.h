//
//  MessageNode.h
//  XMPP
//
//  Created by  XXXX on 15/8/26.
//  Copyright (c) 2015年 shaoting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageNode : NSObject
@property (nonatomic,assign)BOOL isMain;//是否是我发的
@property (nonatomic,copy)NSString * user; //用户名
@property (nonatomic,copy)NSString * body;//消息内容
+(MessageNode *)messageNodeWithIsMain:(BOOL)isM user:(NSString *)user body:(NSString *)body;
@end
