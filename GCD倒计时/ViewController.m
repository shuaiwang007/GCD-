//
//  ViewController.m
//  GCD倒计时
//
//  Created by Mr.Wang on 16/3/25.
//  Copyright © 2016年 Mr.wang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(nonatomic, copy) UIButton *timerBtn;
@property(nonatomic, strong) dispatch_source_t timer;
@end

static int count = 60;
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self buildUI];
}

- (void)buildUI {
    [self.view addSubview:self.timerBtn];
}


- (void)timerBtnOnClick: (UIButton *)timerBtn {
    
    NSLog(@"---点击了倒计时按钮");
    self.timerBtn.backgroundColor = [UIColor lightGrayColor];
    self.timerBtn.userInteractionEnabled = NO;
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);

    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t) (1.0 * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(1.0 * NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer, start, interval, 0);
    
    // callBack
    dispatch_source_set_event_handler(self.timer, ^{
        
        NSLog(@"-----------%@", [NSThread currentThread]);
        count -= 1;
        [self.timerBtn setTitle:[NSString stringWithFormat:@"%d", count] forState:UIControlStateNormal];
        
        if (count == 0) {
            // 取消定时器
            dispatch_cancel(self.timer);
            self.timer = nil;
            self.timerBtn.userInteractionEnabled = YES;
            [self.timerBtn setTitle:@"60s" forState:UIControlStateNormal];
            self.timerBtn.backgroundColor = [UIColor whiteColor];
            count = 60;
        }
        
    });
    
    // 启动
    dispatch_resume(self.timer);
   
}

- (UIButton *)timerBtn {
    if (!_timerBtn) {
        _timerBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 88, 60, 30)];
        _timerBtn.layer.cornerRadius = 3;
        _timerBtn.layer.borderWidth = 3;
        [_timerBtn setTitle:[NSString stringWithFormat:@"%d", count] forState:UIControlStateNormal];
        [_timerBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _timerBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _timerBtn.backgroundColor = [UIColor whiteColor];
        [_timerBtn addTarget:self action:@selector(timerBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _timerBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
