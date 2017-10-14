//
//  CustomView.m
//  CGContextRefDemo
//
//  Created by 杜文亮 on 2017/8/25.
//  Copyright © 2017年 杜文亮. All rights reserved.
//

#import "CustomView.h"

#define PI 3.14159265358979323846


@implementation CustomView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor grayColor];
    }
    return self;
}

// 覆盖drawRect方法，你可以在此自定义绘画和动画(绘制的内容必须写在这里，不能写在初始化方法中，否则控制台会报错)
- (void)drawRect:(CGRect)rect
{
    [self T1];
    
    //参考资料：http://blog.csdn.net/panwave/article/details/45892879
//    CGContextRef context=UIGraphicsGetCurrentContext();
//    CGContextSetRGBStrokeColor(context,1,0,0,1);
////    CGContextMoveToPoint(context,150,50);
////    CGContextAddLineToPoint(context,100,80);
////    CGContextAddLineToPoint(context,130,150);
//    
//    CGContextMoveToPoint(context,150,50);//圆弧的起始点
//    CGContextAddArcToPoint(context,100,80,130,150,200);
//    CGContextStrokePath(context);
    
}



-(void)T1
{
    //一个不透明类型的Quartz 2D绘画环境,相当于一个画布,你可以在上面任意绘画
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //绘制规则圆形和扇形
    [self drawCircle:context];
    
    //绘制圆弧、圆角矩形
    [self drawArc:context];
    
    //绘制椭圆
    [self drawAnomalyCircle:context];
    
    //绘制直线、折线、三角形
    [self drawLine:context];
    
    //绘制矩形
    [self drawRectangle:context];
    
    //绘制渐变色
    [self drawGradient:context];
    
    //画贝塞尔曲线
    [self drawBessel:context];
    
    //绘制文字
    [self drawText:context];
    
    //图片
    [self drawImage:context];
}

//绘制规则圆形和扇形
-(void)drawCircle:(CGContextRef)context
{
    /*
     *                             三种绘制圆形的方式
     *   总结：三种圆本质上是一样的，唯一的区别就是绘制方式的不同【CGContextDrawPath(context, 绘制方式)】
     *   注意：1.绘制完整圆形（CGContextAddArc中参数填0，2π），那么此时无需移动画笔到圆心处【CGContextMoveToPoint(context, 圆, 心);】直接CGContextAddArc即可。
              2.而且无需调用【CGContextClosePath(context);】，因为完整圆形本身就是闭合的。
     */
    
    //边框圆
    CGContextSetRGBStrokeColor(context,1,1,1,1.0);//画笔线的颜色(stroke)
    CGContextSetLineWidth(context, 2.0);//线的宽度
    /*
     *   void CGContextAddArc(CGContextRef c,CGFloat x, CGFloat y,CGFloat radius,CGFloat startAngle,CGFloat endAngle, int clockwise)
     
     *   x,y为圆心坐标，radius半径，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针。
     
     *   1弧度＝180°/π（≈57.3°）      度＝弧度×180°/π------>360°＝360×π/180 ＝2π 弧度
     */
    CGContextAddArc(context, 100, 70, 15, 0, 2*PI, 0); //添加一个圆
    /*
     *   void CGContextDrawPath(CGContextRef cg_nullable c, CGPathDrawingMode mode)
     
     *   mode表示绘制方式，有以下5种
             kCGPathFill            填充非零绕数规则
             kCGPathEOFill          表示用奇偶规则
             kCGPathStroke          路径
             kCGPathFillStroke      路径+填充
             kCGPathEOFillStroke    表示描线，不是填充
     */
    CGContextDrawPath(context, kCGPathStroke); //绘制路径（stroke）
    
    
    
    //填充圆，无边框
    CGContextAddArc(context, 140, 70, 15, 0, 2*PI, 0); //添加一个半圆
    CGContextDrawPath(context, kCGPathFill);//绘制填充（fill）
    
    
    
    //画大圆并填充颜
    UIColor *aColor = [UIColor colorWithRed:1 green:0.0 blue:0 alpha:1];
    CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色(另一种设置fill颜色的方法，stroke也有相应方法)
    CGContextSetLineWidth(context, 3.0);//线的宽度
    CGContextAddArc(context, 200, 70, 20, 0, 2*PI, 0); //添加一个圆
    CGContextDrawPath(context, kCGPathFillStroke); //绘制路径加填充
    
    
    /*
     *                              绘制扇形
     *   总结：画扇形，也就是画圆，只不过是设置角度的大小，形成一个扇形
     *   注意：1.必须先移动画笔到圆心的位置【CGContextMoveToPoint(context, 250, 70)】
              2.调用CGContextDrawPath绘制方法前，必须先调用【CGContextClosePath(context)】
     */
    aColor = [UIColor colorWithRed:0 green:1 blue:1 alpha:1];
    CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
    CGContextMoveToPoint(context, 250, 70);
    CGContextAddArc(context, 250, 70, 30,  -60 * PI / 180, -120 * PI / 180, 1);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke); //绘制路径
}

//绘制圆弧、圆角矩形
-(void)drawArc:(CGContextRef)context
{
    /*
     *   画笑脸弧线
     */
    
    //左
    CGContextSetRGBStrokeColor(context, 0, 0, 1, 1);//改变画笔颜色
    CGContextMoveToPoint(context, 140, 110);//开始坐标p1
    /*
     *   CGContextAddArcToPoint(CGContextRef c, CGFloat x1, CGFloat y1,CGFloat x2, CGFloat y2, CGFloat radius)
     
     *   p2(x1,y1)跟p1形成一条线(p1到p2)，结束坐标p3(x2,y2)跟p2形成一条线(p2到p3),radius半径
     
     *   注意:最终的圆弧与这两条直线相切，为了保证让p1,p3点都落在圆弧上，所以需要提前算好半径的长度，否则就会出现多余的线；那么为什么会出现多余的线呢？
     
     *   因为绘制的过程是：
     1.先从p1绘制到圆弧与p1,p2形成直线的那个相切的点，此时绘制的是一条线段。如果p1就是那个切点（也就是说p1这个点落在圆弧上）那么这条线段就是从p1到p1,最终绘制出来也就看不到线段（上面所说的提前计算好半径就是为了让p1,p3就是那两个切点，这样不会产生多余的线段）；如果p1不是那个切点，就会产生p1到切点的那段多余的线段（当然切点依然是在p1与p2形成的那条直线上）
     2.从p1,p2形成直线上的切点到p2,p3形成直线上的切点绘制圆弧
     */
    CGContextAddArcToPoint(context, 148, 98, 156, 110, 10);
    CGContextStrokePath(context);//绘画路径
    
    //右
    CGContextMoveToPoint(context, 160, 110);//开始坐标p1
    CGContextAddArcToPoint(context, 168, 98, 176, 110, 10);
    CGContextStrokePath(context);//绘画路径
    
    //下
    CGContextMoveToPoint(context, 150, 120);//开始坐标p1
    CGContextAddArcToPoint(context, 158, 132, 166, 120, 10);
    CGContextStrokePath(context);//绘画路径
    //注，如果还是没弄明白怎么回事，请参考：http://donbe.blog.163.com/blog/static/138048021201052093633776/
    
    
    
    /*
     *   圆角矩形
     */
    float fw = 250;
    float fh = 140;
    
    CGContextMoveToPoint(context, fw, fh-20);  // 开始坐标右边开始
    CGContextAddArcToPoint(context, fw, fh, fw-20, fh, 5);  // 右下角角度
    CGContextAddArcToPoint(context, 190, fh, 190, fh-20, 10); // 左下角角度
    CGContextAddArcToPoint(context, 190, 100, fw-20, 100, 15); // 左上角
    CGContextAddArcToPoint(context, fw, 100, fw, fh-20, 20); // 右上角
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke); //根据坐标绘制路径

}

//绘制椭圆
-(void)drawAnomalyCircle:(CGContextRef)context
{
    CGContextAddEllipseInRect(context, CGRectMake(100, 170, 50, 40));
    CGContextDrawPath(context, kCGPathFillStroke);//可以更换绘制方式
}

//绘制直线、折线、三角形（这种方式可以通过直线构造各种形状，包括规则不规则的。例如，三角形，矩形，多边形等）
-(void)drawLine:(CGContextRef)context
{
    /*
     *   总结：2           折线（减少一个点就是直线了）
              1+2         边框三角形
              1+3         填充三角形
              1+4         边框+填充的三角形
     */

    //实测对于CGContextAddLines方法，指定初始点【CGContextMoveToPoint(context, 110, 60)】无效果，初始点始终是aPoints[0]
    CGPoint aPoints[3];//坐标点(表示有3个坐标点)
    aPoints[0] =CGPointMake(200, 250);//坐标1
    aPoints[1] =CGPointMake(250, 250);//坐标2
    aPoints[2] =CGPointMake(220, 210);//坐标3
    /*
     *   CGContextAddLines(CGContextRef c, const CGPoint points[],size_t count)
     
     *   points[]坐标数组，和count大小
     
     *   效果：p1-p2  p2-p3的两条线段
     */
    CGContextAddLines(context, aPoints, 3);//添加线
//    CGContextClosePath(context);//封起来----1
    CGContextDrawPath(context, kCGPathStroke); //边框-----2
//    CGContextDrawPath(context, kCGPathFill); //填充-----3
//    CGContextDrawPath(context, kCGPathFillStroke); //边框+填充------4

}

//绘制矩形
-(void)drawRectangle:(CGContextRef)context
{
    /*
     *   总结：1.CGContextStrokeRect、CGContextFillRect、CGContextAddRect三种方式无需移动画笔【CGContextMoveToPoint(context, x, y);】只要在参数中指定CGRectMake即可
              2.三种方式都无需【CGContextClosePath(context)】
     */
    
    //画方框
    CGContextStrokeRect(context,CGRectMake(100, 300, 40, 20));
    
    
    //填充框
    CGContextFillRect(context,CGRectMake(160, 300, 30, 30));
    
    
    
    //方框+填充的矩形
    CGContextSetLineWidth(context, 2.0);//线的宽度
    UIColor *aColor;
    aColor = [UIColor greenColor];
    CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
    aColor = [UIColor yellowColor];
    CGContextSetStrokeColorWithColor(context, aColor.CGColor);//线框颜色
    CGContextAddRect(context,CGRectMake(240, 290, 60, 40));//画方框
    CGContextDrawPath(context, kCGPathFillStroke);//方框+填充
}

//绘制渐变色
-(void)drawGradient:(CGContextRef)context
{
    //关于颜色参考http://blog.sina.com.cn/s/blog_6ec3c9ce01015v3c.html
              //http://blog.csdn.net/reylen/article/details/8622932
    
    /*
     *   绘制矩形并填充渐变色
     */
    
    //第一种填充方式，第一种方式必须导入类库quartcore并#import <QuartzCore/QuartzCore.h>，这个就不属于在context上画，而是将层插入到view层上面。那么这里就设计到Quartz Core 图层编程了。
    CAGradientLayer *gradient1 = [CAGradientLayer layer];
    gradient1.frame = CGRectMake(100, 340, 60, 60);
    gradient1.colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor,
                        (id)[UIColor grayColor].CGColor,
                        (id)[UIColor blackColor].CGColor,
                        (id)[UIColor yellowColor].CGColor,
                        (id)[UIColor blueColor].CGColor,
                        (id)[UIColor redColor].CGColor,
                        (id)[UIColor greenColor].CGColor,
                        (id)[UIColor orangeColor].CGColor,
                        (id)[UIColor brownColor].CGColor,nil];
    [self.layer insertSublayer:gradient1 atIndex:0];
    
    
    //第二种填充方式
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGFloat colors[] =
    {
        1,1,1, 1.00,
        1,1,0, 1.00,
        1,0,0, 1.00,
        1,0,1, 1.00,
        0,1,1, 1.00,
        0,1,0, 1.00,
        0,0,1, 1.00,
        0,0,0, 1.00,
    };
    CGGradientRef gradient = CGGradientCreateWithColorComponents
    (rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));//形成梯形，渐变的效果
    CGColorSpaceRelease(rgb);
    /*
     *                        CGContextSaveGState与CGContextRestoreGState的作用
        CGContextSaveGState函数的作用是将当前图形状态推入堆栈。之后，您对图形状态所做的修改会影响随后的描画操作，但不影响存储在堆栈中的拷贝。在修改完成后，您可以通过CGContextRestoreGState函数把堆栈顶部的状态弹出，返回到之前的图形状态。这种推入和弹出的方式是回到之前图形状态的快速方法，避免逐个撤消所有的状态修改；这也是将某些状态（比如裁剪路径）恢复到原有设置的唯一方式。
     */
    CGContextSaveGState(context);//把当前的context备份（因为下面用了裁剪，为了保证先前绘制的内容，需要这样做）
    //画线形成一个矩形
    CGContextMoveToPoint(context, 180, 340);
    CGContextAddLineToPoint(context, 240, 340);
    CGContextAddLineToPoint(context, 240, 400);
    CGContextAddLineToPoint(context, 180, 400);
    CGContextClip(context);//context裁剪路径,后续操作的路径(这句话执行完context就只剩下那个裁剪下来的区域了)
    /*
     *   CGContextDrawLinearGradient(CGContextRef context,CGGradientRef gradient, CGPoint startPoint, CGPoint endPoint,CGGradientDrawingOptions options)
     
     *   gradient渐变颜色,startPoint开始渐变的起始位置,endPoint结束坐标,options开始坐标之前or开始之后开始渐变
     */
    CGContextDrawLinearGradient(context, gradient,CGPointMake
                                (180,340) ,CGPointMake(240,400),
                                kCGGradientDrawsAfterEndLocation);//这里的点不一定非要写顶点哦
    CGContextRestoreGState(context);// 恢复到之前的context(最终效果就是将这片裁剪区域重新添加到了执行裁剪前的原context中,此时的context不再是裁剪区域，而是裁剪之前的原context)
    
    
    //第二种填充方式，再写一个看看效果
    CGContextSaveGState(context);
    CGContextMoveToPoint(context, 260, 360);
    CGContextAddLineToPoint(context, 260, 390);
    CGContextAddLineToPoint(context, 300, 390);
    CGContextAddLineToPoint(context, 300, 360);
    CGContextClip(context);//裁剪路径
    //说白了，开始坐标和结束坐标是控制渐变的方向和形状
    CGContextDrawLinearGradient(context, gradient,CGPointMake
                                (260, 360) ,CGPointMake(260, 390),
                                kCGGradientDrawsAfterEndLocation);
    CGContextRestoreGState(context);// 恢复到之前的context
    
    
    
    /*
     *   绘制圆形并填充渐变色（圆形可以直接一步调用这样写，但是矩形必须按上述步骤先绘制，再裁剪，然后调用）
     */
    CGContextDrawRadialGradient(context, gradient, CGPointMake(320, 370), 0.0, CGPointMake(320, 370), 20, kCGGradientDrawsBeforeStartLocation);
}

//绘制贝塞尔曲线
-(void)drawBessel:(CGContextRef)context
{
    //二次曲线
    CGContextMoveToPoint(context, 120, 430);//设置Path的起点
    CGContextAddQuadCurveToPoint(context,190, 450, 120, 530);//设置贝塞尔曲线的控制点坐标和终点坐标
    CGContextStrokePath(context);
    
    
    
    //三次曲线函数
    CGContextMoveToPoint(context, 200, 470);//设置Path的起点
    CGContextAddCurveToPoint(context,230, 340, 250, 500, 280, 470);//设置贝塞尔曲线的控制点坐标和控制点坐标终点坐标
    CGContextStrokePath(context);
}

//绘制文字
-(void)drawText:(CGContextRef)context
{
    /*
     *   新的接口如果设置了颜色，就相当于重新设置了fill颜色，下面第一句代码中设置的fill颜色就会被新颜色取代,接着在进行绘制，如果不设置画笔颜色，那么会fill颜色一直会是blue(注意是fill调用颜色才是blue，因为此处设置的是fill填充颜色，stroke的颜色可不是blue，而是显示设置的stroke的颜色，也就是说fill和stroke颜色是分开设置的互不影响，使用时注意看清是fill还是stroke)
     */
    CGContextSetRGBFillColor (context,  1, 0, 0, 1.0);//设置填充颜色
    UIFont *font = [UIFont boldSystemFontOfSize:15.0];
    
    //新接口
    [@"圆、扇形:" drawInRect:CGRectMake(10, 60, 80, 20) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor greenColor]}];
    [@"圆弧、圆角矩形:" drawInRect:CGRectMake(10, 120, 100, 20) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor brownColor]}];
    [@"椭圆:" drawInRect:CGRectMake(10, 180, 140, 20) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor blueColor]}];
    
    
    //老接口
    [@"直线、折线、三角形:" drawInRect:CGRectMake(10, 240, 140, 20) withFont:font];
    [@"矩形：" drawInRect:CGRectMake(10, 300, 80, 20) withFont:font];
    [@"渐变色:" drawInRect:CGRectMake(10, 360, 100, 20) withFont:font];
    [@"贝塞尔曲线:" drawInRect:CGRectMake(10, 460, 100, 20) withFont:font];
    [@"图片：" drawInRect:CGRectMake(10, 560, 80, 20) withFont:font];
}

//图片
-(void)drawImage:(CGContextRef)context
{
    UIImage *image = [UIImage imageNamed:@"apple"];
    [image drawInRect:CGRectMake(100, 560, 40, 40)];//在坐标中画出图片
//    [image drawAtPoint:CGPointMake(100, 340)];//保持图片本身大小，并从point点（100，340）开始画图片
    CGContextDrawImage(context, CGRectMake(160, 560, 40, 40), image.CGImage);//使用这个使图片上下颠倒了，参考http://blog.csdn.net/koupoo/article/details/8670024
//    CGContextDrawTiledImage(context, CGRectMake(0, 0, 20, 20), image.CGImage);//平铺图
}

@end
