//
//  XMPPManager.m
//  XMPP
//
//  Created by XXXX on 15/8/26.
//  Copyright (c) 2015年 shaoting. All rights reserved.
//
#import "XMPPManager.h"
#import "XMPPFramework.h"

typedef enum {
    XMPPManagerLogin = 100,
    XMPPManagerRegister
}XMPPManagerType;

@interface XMPPManager()  <XMPPStreamDelegate,XMPPRosterDelegate>
//stream类作用
//1.连接服务器
//2.登录
//3.发送个人状态和消息
@property (nonatomic, strong) XMPPStream *stream;
//花名册
@property (nonatomic,strong)XMPPRoster * roster;
//好友列表
@property (nonatomic, strong)NSMutableArray  *friendList;
//密码
@property (nonatomic, copy) NSString *password;
//记录是哪种类型,100是登录,101是注册
@property (nonatomic,assign)XMPPManagerType type;
//设置block属性,属性的属性使用copy
@property (nonatomic, copy) SuccessBlock successBlock;
@property (nonatomic, copy) SuccessBlock failBlock;
@end

@implementation XMPPManager
+(XMPPManager *)defaultManager{
    static XMPPManager * manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[XMPPManager alloc]init];
    });
    return manager;
}
//重写init
-(instancetype)init{
    self = [super init];
    if (self) {
        self.stream = [[XMPPStream alloc]init];
        //设置服务器地址
        self.stream.hostName = @"127.0.0.1";
        //设置端口号
        self.stream.hostPort = 5222;
        //设置代理
        [self.stream addDelegate:self delegateQueue:dispatch_get_main_queue()];
        //初始化花名册
        self.roster = [[XMPPRoster alloc]initWithRosterStorage:[XMPPRosterCoreDataStorage sharedInstance]];
        //设置代理
        [self.roster addDelegate:self delegateQueue:dispatch_get_main_queue()];
        //激活花名册
        [self.roster activate:self.stream];
    }
    return self;
}
//登录
-(void)loginInWithID:(NSString *)aID password:(NSString *)psw success:(SuccessBlock)suc fail:(SuccessBlock)fai{
    self.type = XMPPManagerLogin;
    //连接服务器必须要有JID
    self.stream.myJID = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@liu.local",aID]];
    //先断开服务器
    [self.stream disconnect];
    //连接服务器
    [self.stream connectWithTimeout:-1 error:nil];
    //用属性记住登录密码
    self.password = psw;
    
    self.successBlock = suc;
    self.failBlock = fai;
}
//连接服务器成功触发
-(void)xmppStreamDidConnect:(XMPPStream *)sender{
    NSLog(@"连接服务器成功");
    if (self.type == XMPPManagerLogin) {
        //连接成功后开始登录
        [self.stream authenticateWithPassword:self.password error:nil];
    }else{
        //连接成功后,开始注册
        [self.stream registerWithPassword:self.password error:nil];
    }
    
}
//连接服务器失败时触发
-(void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    NSLog(@"连接服务器失败");
    //连接失败,一直连接
    [self.stream connectWithTimeout:-1 error:nil];
}
//登录的两个代理方法
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    //登录成功
    NSLog(@"登录成功");
    //发送当前用户状态
    XMPPPresence * presence = [XMPPPresence presence];
    [sender sendElement:presence];
    
    self.successBlock();
}
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
    NSLog(@"登录失败");
    self.failBlock();
}
//注册
- (void)registerWithID:(NSString *)aID password:(NSString *)psd{
    self.type = XMPPManagerRegister;
    //设置JID
    self.stream.myJID = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@liu.local",aID]];
    //断开服务器
    [self.stream disconnect];
    //连接服务器
    [self.stream connectWithTimeout:-1 error:nil];
    //记住注册密码
    self.password = psd;
}
-(void)sendMessageTo:(NSString *)jid body:(NSString *)body{
    XMPPMessage * message = [XMPPMessage messageWithType:@"chat" to:[XMPPJID jidWithString:jid]];
    [message addBody:body];
    [self.stream sendElement:message];//发送消息
    
}
//发送消息的两个代理
-(void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message{
    NSLog(@"发送成功");
    if (self.delegate && [self.delegate respondsToSelector:@selector(xmppManager:sendMessageSuccess:)]) {
        [self.delegate xmppManager:self sendMessageSuccess:message];
    }
}

-(void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error{
    NSLog(@"发送失败");
    if (self.delegate && [self.delegate respondsToSelector:@selector(xmppManager:sendMessageFail:error:)]) {
        [self.delegate xmppManager:self sendMessageFail:message error:error];
    }
}

//注册的两个代理方法
-(void)xmppStreamDidRegister:(XMPPStream *)sender{
    NSLog(@"注册成功");
    //首先,self.delegate需要存在
    //其次.self.delegate需要响应具体的方法
    if (self.delegate && [self.delegate respondsToSelector:@selector(registerSuccess)]) {
        [self.delegate registerSuccess];
    }
}
-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    NSLog(@"注册失败");
    NSLog(@"%@",error);
    if (self.delegate && [self.delegate respondsToSelector:@selector(registerFailWithError:)]) {
        [self.delegate registerFailWithError:error];
    }
}
//获取花名册的代理方法
//开始拉取花名册
- (void)xmppRosterDidBeginPopulating:(XMPPRoster *)sender{
    self.friendList = [NSMutableArray arrayWithCapacity:0];//初始化
    
}
//接收到花名册数据
-(void)xmppRoster:(XMPPRoster *)sender didReceiveRosterItem:(DDXMLElement *)item{
    [self.friendList addObject:item];
    
}
//结束拉取
-(void)xmppRosterDidEndPopulating:(XMPPRoster *)sender{
    NSLog(@"%@",self.friendList);
    [[NSNotificationCenter defaultCenter]postNotificationName:@"KPOSTFRIENDSLIST" object:nil userInfo:@{@"list":self.friendList}];
}
//获取消息代理
-(void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    if (!message.body) {
        return;
    }
    NSLog(@"%@",message.body);
    if (self.delegate && [self.delegate respondsToSelector:@selector(xmppManager:recieveMessage:)]) {
        [self.delegate xmppManager:self recieveMessage:message];
    }
    
}

//
@end
