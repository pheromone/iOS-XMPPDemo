//
//  XMPPManager.h
//  XMPP
//
//  Created by  XXXX on 15/8/26.
//  Copyright (c) 2015年 shaoting. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DDXMLElement;//引入类
@class XMPPMessage;
@class XMPPManager;
typedef  void (^SuccessBlock)();
//制定协议
@protocol XMPPManagerDelegate <NSObject>
-(void)registerSuccess; // 注册成功
-(void)registerFailWithError:(DDXMLElement *)error;//注册失败
-(void)xmppManager:(XMPPManager *)manager recieveMessage:(XMPPMessage *)message;//接收到消息
-(void)xmppManager:(XMPPManager *)manager sendMessageSuccess:(XMPPMessage *)message;//发送消息成功
-(void)xmppManager:(XMPPManager *)manager sendMessageFail:(XMPPMessage *)message error:(NSError *)error;//发送消息成功
@end

@interface XMPPManager : NSObject
@property (nonatomic,weak)id <XMPPManagerDelegate> delegate;

+(XMPPManager *)defaultManager;
-(void)loginInWithID:(NSString *)aID password:(NSString *)psw success:(SuccessBlock)suc fail:(SuccessBlock)fai;
- (void)registerWithID:(NSString *)aID password:(NSString *)psd;
-(void)sendMessageTo:(NSString *)jid body:(NSString *)body;
@end
