//
//  FriendsViewController.m
//  XMPP
//
//  Created by  XXXX on 15/8/26.
//  Copyright (c) 2015年 shaoting. All rights reserved.
//

#import "FriendsViewController.h"
#import "DDXMLElement.h"
#import "ChatViewController.h"
@interface FriendsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (nonatomic, strong) NSMutableArray *dataList;
@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getFriendsList:) name:@"KPOSTFRIENDSLIST" object:nil];
    self.dataList = [@[] mutableCopy];
    // Do any additional setup after loading the view.
}
-(void)getFriendsList:(NSNotification *)noti{
    NSLog(@"%@",noti.userInfo[@"list"]);
    [self.dataList removeAllObjects];//请空数组
    [self.dataList addObjectsFromArray:noti.userInfo[@"list"]];//添加元素
    [self.table reloadData];//刷新页面
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell  * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" ];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"cell"];
    }
    DDXMLElement * element = self.dataList[indexPath.row];
    DDXMLNode * node =  [element attributeForName:@"jid"];
    cell.textLabel.text = [node stringValue];
    return cell;
}
//点击每行触发
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DDXMLElement * element = self.dataList[indexPath.row];
    DDXMLNode * node =  [element attributeForName:@"jid"];
    [self performSegueWithIdentifier:@"chat" sender:[node stringValue]];
}
//传值
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"chat"]) {
        [(ChatViewController *)segue.destinationViewController setJid:sender];
        
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
