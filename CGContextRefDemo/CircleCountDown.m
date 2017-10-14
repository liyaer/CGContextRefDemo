//
//  CircleCountDown.m
//  AnimationSets
//
//  Created by 杜文亮 on 2017/10/14.
//  Copyright © 2017年 杜文亮. All rights reserved.
//

#import "CircleCountDown.h"

@implementation CircleCountDown
{
    NSInteger _count;
    NSTimer *_timer;
}

//-(instancetype)initWithFrame:(CGRect)frame
//{
//    //绘制内容不能写在这里
//}

//绘制内容必须写在这里，不能写在初始化方法里，否则控制台会报错
-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();//获取上下文对象  只要是用了 CoreGraPhics  就必须创建他
    CGContextSetLineWidth(context, 5);//显然是设置线宽
    CGContextSetRGBStrokeColor(context, 1, 0, 0, 1);// 设置颜色
    CGContextAddArc(context, self.frame.size.width/2.0, self.frame.size.height/2.0, self.frame.size.width/2.0 -5, 0 , _count/50.0 * 2*M_PI, 0);//这就是画曲线了
    CGContextStrokePath(context);
}

-(void)time
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:.1 repeats:YES block:^(NSTimer * _Nonnull timer)
  {
      _count++;
      [self setNeedsDisplay];//立即绘制内容(会立刻调用drawRect方法)。静态绘制一次成型，这句话写不写都行；但是动态绘制需要及时更新UI，必须写这句话
      
      if (_count == 50)
      {
          [_timer invalidate];
          _timer = nil;
      }
      NSLog(@"=====%ld",_count);//测试timer是否真的释放
  }];
}

@end
