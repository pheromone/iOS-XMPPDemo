//
//  RegisterViewController.m
//  
//
//  Created by  XXXX on 15/8/26.
//
//

#import "RegisterViewController.h"
#import "XMPPManager.h"
@interface RegisterViewController () <XMPPManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *registerID;
@property (weak, nonatomic) IBOutlet UITextField *registerPsd;

@end

@implementation RegisterViewController
- (IBAction)regidter:(id)sender {
    XMPPManager * manager = [XMPPManager defaultManager];
    manager.delegate = self;
    [manager registerWithID:self.registerID.text password:self.registerPsd.text];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)registerSuccess{
    [[[UIAlertView alloc]initWithTitle:@"注册成功" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil] show];
    }
-(void)registerFailWithError:(DDXMLElement *)error{
   [[[UIAlertView alloc]initWithTitle:@"注册失败" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil] show];
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
