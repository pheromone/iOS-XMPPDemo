//
//  MessageNode.m
//  XMPP
//
//  Created by  XXXX on 15/8/26.
//  Copyright (c) 2015年 shaoting. All rights reserved.
//

#import "MessageNode.h"

@implementation MessageNode
+(MessageNode *)messageNodeWithIsMain:(BOOL)isM user:(NSString *)user body:(NSString *)body{
    MessageNode * node = [[MessageNode alloc]init];
    node.isMain = isM;
    node.user = user;
    node.body = body;
    return node;
}

@end
