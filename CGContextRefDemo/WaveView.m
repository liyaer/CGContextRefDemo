//
//  WaveView.m
//  AnimationSets
//
//  Created by 杜文亮 on 2017/10/14.
//  Copyright © 2017年 杜文亮. All rights reserved.
//

#import "WaveView.h"

@implementation WaveView
{
    CGRect _MYframe;
    CGFloat _fa;
    CGFloat _bigNumber;
    UILabel *_presentLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _MYframe = frame;
        self.backgroundColor = [UIColor whiteColor];
        _presentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _presentLabel.textAlignment = 1;
        [self addSubview:_presentLabel];
        _presentLabel.font = [UIFont systemFontOfSize:15];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self drawWave:rect];
    
//    [self reDrawTest:rect];测试每次调用[self setNeedsDisplay]，之前绘制的内容会被清除掉，然后重新绘制新的。
}

-(void)drawWave:(CGRect)rect
{
    //第一条曲线
    //画布的简单设置
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    CGContextSetLineWidth(context, 1);
    UIColor * blue = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.3];
    CGContextSetFillColorWithColor(context, [blue CGColor]);
    
    //将生成的多个（x，y）点链接成一条曲线
    float y= (1 - self.present) * rect.size.height;
    CGPathMoveToPoint(path, NULL, 0, y);
    for(float x=0;x<=rect.size.width * 3.0;x++)
    {
        //正弦函数
        y = _bigNumber * sin( x/rect.size.width*M_PI + _fa/rect.size.width*M_PI ) + (1 - self.present) * rect.size.height;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    CGPathAddLineToPoint(path, nil, rect.size.width , rect.size.height );
    CGPathAddLineToPoint(path, nil, 0, rect.size.height );
    
    //绘制
    CGContextAddPath(context, path);
    CGContextFillPath(context);
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(path);
    
    
    
    //第二条曲线
    //画布的简单设置
    CGMutablePathRef path1 = CGPathCreateMutable();
    CGContextSetLineWidth(context, 1);
    UIColor * blue1 = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.8];
    CGContextSetFillColorWithColor(context, [blue1 CGColor]);
    
    //将生成的多个（x，y）点链接成一条曲线
    float y1= (1 - self.present) * rect.size.height;
    CGPathMoveToPoint(path1, NULL, 0, y1);
    for(float x=0;x<=rect.size.width;x++)
    {
        /*
         *   y=Asin(ωx+φ)+k
         *       A——振幅，当物体作轨迹符合正弦曲线的直线往复运动时，其值为行程的1/2。
         (ωx+φ)——相位，反映变量y所处的状态。
         φ——初相，x=0时的相位；反映在坐标系上则为图像的左右移动。
         k——偏距，反映在坐标系上则为图像的上移或下移。
         ω——角速度， 控制正弦周期(单位角度内震动的次数)。
         */
        
        y1 = _bigNumber * sin( x/rect.size.width*M_PI + _fa/rect.size.width *M_PI  +M_PI) + (1 - self.present) * rect.size.height;//和y的初相不同，多+了个M_PI
        CGPathAddLineToPoint(path1, nil, x, y1);
    }
    CGPathAddLineToPoint(path1, nil, rect.size.height, rect.size.width );
    CGPathAddLineToPoint(path1, nil, 0, rect.size.height );
    
    //绘制
    CGContextAddPath(context, path1);
    CGContextFillPath(context);
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(path1);
    
    
    
    //添加文字
    NSString *str = [NSString stringWithFormat:@"%.2f%%",self.present * 100.0];
    _presentLabel.text = str;
}

-(void)reDrawTest:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();//获取上下文对象  只要是用了 CoreGraPhics  就必须创建他
    CGContextSetLineWidth(context, 5);//显然是设置线宽
    CGContextSetRGBStrokeColor(context, 1, 0, 0, 1);// 设置颜色
    CGContextAddArc(context, rect.size.width/2.0, rect.size.height/2.0, rect.size.width/2.0 -5 -_present*100, 0 , 2*M_PI, 0);//这就是画曲线了
    CGContextStrokePath(context);
}




- (void)setPresent:(CGFloat)present
{
    _present = present;
    
    //修改A
    if (present <= 0.5)
    {
        _bigNumber = _MYframe.size.height * 0.1 * present * 2;
    }
    else
    {
        _bigNumber = _MYframe.size.height * 0.1 * (1 - present) * 2;
    }
    //修改_fa
    [self createTimer];
}

- (void)createTimer
{
    if (!_myTimer)
    {
        _myTimer = [NSTimer scheduledTimerWithTimeInterval:.02 repeats:YES block:^(NSTimer * _Nonnull timer)
        {
            //让波浪移动效果
            _fa = _fa+10;
            if (_fa >= _MYframe.size.width * 2.0)
            {
                _fa = 0;
            }
            [self setNeedsDisplay];//每隔0.02会重新绘制两条新的曲线
            NSLog(@"=====%.2f",_fa);
        }];
    }
}

@end
