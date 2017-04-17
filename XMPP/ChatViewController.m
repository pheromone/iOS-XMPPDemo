//
//  ChatViewController.m
//  XMPP
//
//  Created by  XXXX on 15/8/26.
//  Copyright (c) 2015年 shaoting. All rights reserved.
//

#import "ChatViewController.h"
#import "XMPPManager.h"
#import "XMPPMessage.h"
#import "MessageNode.h"
@interface ChatViewController ()<UITableViewDelegate,UITableViewDataSource,XMPPManagerDelegate,UITextFieldDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *myTitleLabel;
@property (nonatomic,strong)NSMutableArray * messageArray;//存放消息
@property (weak, nonatomic) IBOutlet UITableView *table;
@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [XMPPManager defaultManager].delegate = self;
    self.myTitleLabel.text = self.jid;
    self.messageArray = [@[] mutableCopy];
    
    //通知监听键盘弹出
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //通知监听键盘回收
    // Do any additional setup after loading the view.
}
-(void)keyBoardWillShow:(NSNotification *)noti{
    NSLog(@"%f",[noti.userInfo[UIKeyboardBoundsUserInfoKey ] CGRectValue].size.height);
    [UIView animateWithDuration:[noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        UITextField * textField = [self.view viewWithTag:998];
        CGRect rect = textField.frame;
        rect.origin.y = [UIScreen mainScreen].bounds.size.height - [noti.userInfo[UIKeyboardBoundsUserInfoKey]CGRectValue].size.height-rect.size.height;
        textField.frame = rect;
    }completion:^(BOOL finished) {
 
    
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"cell"];
    }
//    XMPPMessage * message = self.messageArray[indexPath.row];
    MessageNode *message = self.messageArray[indexPath.row];
    cell.detailTextLabel.text = message.body;
    cell.textLabel.text = message.user;
    return cell;
}
-(void)xmppManager:(XMPPManager *)manager recieveMessage:(XMPPMessage *)message{
//    [self.messageArray addObject:message];
    MessageNode * messageN = [MessageNode messageNodeWithIsMain:NO user:message.from.user body:message.body];
    [self.messageArray addObject:messageN];
    
    [self.table reloadData];//需要再次刷新
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [[XMPPManager defaultManager]sendMessageTo:self.jid body:textField.text];
    
    return YES;
}
//
-(void)xmppManager:(XMPPManager *)manager sendMessageFail:(XMPPMessage *)message error:(NSError *)error{
     [[[UIAlertView alloc]initWithTitle:@"消息发送失败" message:@"是否重新发送" delegate:@"不发" cancelButtonTitle:nil otherButtonTitles:@"发", nil] show];
}
-(void)xmppManager:(XMPPManager *)manager sendMessageSuccess:(XMPPMessage *)message{
//    [self.messageArray addObject:message];
    MessageNode *messageN = [MessageNode messageNodeWithIsMain:YES user:[[NSUserDefaults standardUserDefaults]objectForKey:@"jid"] body:message.body];
    [self.messageArray addObject:messageN];
    
    [self.table reloadData];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        //父视图通过tag值找到子视图
        UITextField * textField = (UITextField *)[self.view viewWithTag:998];
        [[XMPPManager defaultManager] sendMessageTo:self.jid body:textField.text];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
