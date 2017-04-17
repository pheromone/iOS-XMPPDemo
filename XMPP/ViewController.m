//
//  ViewController.m
//  XMPP
//
//  Created by  XXXX on 15/8/26.
//  Copyright (c) 2015年 shaoting. All rights reserved.
//

#import "ViewController.h"
#import "XMPPManager.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *JIDTextField;
@property (weak, nonatomic) IBOutlet UITextField *pswTextField;

@end

@implementation ViewController
- (IBAction)loginClick:(id)sender {
    [[XMPPManager defaultManager]loginInWithID:self.JIDTextField.text password:self.pswTextField.text success:^{
        [[[UIAlertView alloc]initWithTitle:@"登录成功" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil] show];
        //记录登陆数据
        [[NSUserDefaults standardUserDefaults]setObject:self.JIDTextField.text forKey:@"jid"];
        [[NSUserDefaults standardUserDefaults]setObject:self.pswTextField.text forKey:@"psw"];
          //登陆成功,页面跳转
        [self performSegueWithIdentifier:@"login" sender:nil];
    } fail:^{
        [[[UIAlertView alloc]initWithTitle:@"登录失败" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil] show];
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
