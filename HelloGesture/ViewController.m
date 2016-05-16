//
//  ViewController.m
//  HelloGesture
//
//  Created by Joe Chen on 2016/5/16.
//  Copyright © 2016年 Joe Chen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (strong,nonatomic) NSMutableArray * fonts;
@property (nonatomic) NSUInteger currentFontindex;
@property (nonatomic) CGFloat currentFiontSize; //字型大小
//CGFloat and NSUInteger不是ns物件 不能設定weak strong
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //字型初始化
    self.fonts = [NSMutableArray array];
    //尋訪所有的字型
    for(NSString * familyName in [UIFont familyNames]){
        for (NSString * fontname in [UIFont fontNamesForFamilyName:familyName]) {
            [self.fonts addObject:fontname];
         }
    }
    
    //字型設定在第0個
    self.currentFontindex = 0;
    //字型大小預設12
    self.currentFiontSize = 40.0;
    //更新畫面上的文字
    [self refreshDisplayText];
    
    
    //Swipe(滑動)
    UISwipeGestureRecognizer * leftSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(changeFont:)];
    //設定往左滑動
    leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;

    //向右滑動
    UISwipeGestureRecognizer * rightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(changeFont:)];
    rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;

    [self.label addGestureRecognizer:leftSwipeGesture];
    [self.label addGestureRecognizer:rightSwipeGesture];
    
    //pinch
    UIPinchGestureRecognizer * pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(changeFontSize:)];
    [self.label addGestureRecognizer:pinch];
    
    //DoubleTap
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeText)];
    tap.numberOfTapsRequired = 2;
    [self.label addGestureRecognizer:tap];
    
    
}


-(void)refreshDisplayText{
    //從陣列中拿到字型名稱
    NSString * fontname = [self.fonts objectAtIndex:self.currentFontindex];
    //將自行的名稱轉成字體
    UIFont * font = [UIFont fontWithName:fontname size:self.currentFiontSize];
    //字型指給label
    self.label.font = font;
    
}

-(void)changeText{
    //準備警告窗
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"請輸入文字" message:@"here is the message" preferredStyle:UIAlertControllerStyleAlert];
    //加文字框在警告視窗上
    [alertController addTextFieldWithConfigurationHandler:nil];
    //準備警告要裝設的按鈕
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
    //取得警視窗上的文字框
        UITextField * textFiled = alertController.textFields[0];
    //將文字框上的文字指給
        self.label.text = textFiled.text;
        
    }];
    
    //將按鈕加視窗上
    [alertController addAction:action];
    //顯示警告視窗
    [self presentViewController:alertController animated:true completion:nil];
}


-(void)changeFontSize:(UIPinchGestureRecognizer*)pinch{
    self.currentFiontSize *= pinch.scale;
    pinch.scale = 1.0;
    [self refreshDisplayText];
}



-(void)changeFont:(UISwipeGestureRecognizer*)swipe{
    
    if(swipe.direction == UISwipeGestureRecognizerDirectionRight){
        //前進到下一個字體
        NSLog(@"currentIndex:%lu",(unsigned long)self.currentFontindex);
        if(self.currentFontindex == self.fonts.count-1){
            
            self.currentFontindex = 0;
        }else{
            self.currentFontindex += 1;}
    }else{
        NSLog(@"currentIndex:%lu",(unsigned long)self.currentFontindex);
        if(self.currentFontindex == 0){
            self.currentFontindex = self.fonts.count-1;
        }else{
           self.currentFontindex -= 1;
        }
    }
    
    [self refreshDisplayText];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
