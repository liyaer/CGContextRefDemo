//
//  ViewController.h
//  CGContextRefDemo
//
//  Created by 杜文亮 on 2017/8/25.
//  Copyright © 2017年 杜文亮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

/*
    1.Quartz 2D是什么?
        •Quartz 2D以PDF的规范为基础的图形库，用来绘制二维文字和图形，允许相同的绘图指令在任何装置上，使用可以得到的最佳分辨率，产生相同的输出.
 
    2.Quartz2D能做什么?
        •Quartz 2D API可以实现许多功能，如基于路径的绘图、透明度、阴影、颜色管理、反锯齿、PDF文档生成和PDF元数据访问等
 
    3.Quartz2D和CoreGraphic什么关系
        •Quartz 2D API是Core Graphic框架的一部分，因此其中的很多数据类型和方法都是以CG开头的。会经常见到Quartz 2D（Quartz）和Core Graphics两个术语交互使用
 
    4.Quartz2D有什么特性吗?
        •Quartz 2D与分辨率和设备无关，因此在使用Quartz 2D绘图时，无需考虑最终绘图的目标设备
 
    5.Core Graphic是什么?
        •Core Graphic框架是一组基于C的API，可以用于一切绘图操作，这个框架的重要性，仅次于UIKit和Foundation
 
    6.Core Graphic有什么用?
        •当使用UIKit创建按钮、标签或者其他UIView的子类时，UIKit会用Core Graphics将这些元素绘制在屏幕上。此外，UIEvent（UIKit中的事件处理类）也会使用Core Graphics，用来帮助确定触摸事件在屏幕上所处的位置
 
    7.怎么引入Core Graphic?
        •因为UIKit依赖于Core Graphics，所以当引入<UIKit/Uikit.h>时，Core Graphics框架会被自动引入，即UIKit内部已经引入了Core Graphics框架的主头文件：<CoreGraphics/CoreGraphics.h>
        •为了让开发者不必触及底层的Core Graphics的C接口，UIKit内部封装了Core Graphics的一些API，可以快速生成通用的界面元素。但是，有时候直接利用Core Graphics的C接口是很有必要和很有好处的，比如创建一个自定义的界面元素

--------------------------------------------------------------------------------------
 
    1.Quartz2D是用来绘图的,但是在哪里绘图?怎么绘制?
        •在哪里绘图？
            1.图形上下文（Graphics Context），对应的API是CGContextRef
        •如何绘图？
            1.Quartz 2D坐标系
            2.绘图顺序
            3.UIView的drawRect:方法
            4.Quartz 2D的内存管理
 
    2.Graphics Context(绘图目标)是什么?
        •Graphics Context是一个数据类型(CGContextRef)，封装了Quartz绘制图像到输出设备的信息。输出设备可以是PDF文件、Bitmap或者显示器的窗口上
        •Quartz中所有的对象都是绘制到一个Graphics Context中
        •当用Quartz绘图时，所有设备相关的特性都包含在Graphics Context中。换句话说，我们可以简单地给Quartz绘图序列指定不同的Graphics Context，就可将相同的图像绘制到不同的设备上。而不需要任何设备相关的计算，这些都由Quartz替我们完成
 
    3.指定不同的上下文便可以在不同的设备上绘图,那一共有几种上下文呢?
        1.Bitmap Graphics Context
        2.PDF Graphics Context
        3.Window Graphics Context
        4.Layer Graphics Context
        5.Printer Graphics Context
 
    4.Graphics Context包含了什么?怎么用?????
        •一个Graphics Context表示一个绘制目标。它包含绘制系统用于完成绘制指令的绘制参数和设备相关信息
        •Graphics Context定义了基本的绘制属性，如颜色、裁减区域、线条宽度和样式信息、字体信息、混合模式等
        •在iOS应用程序中，如果要在屏幕上进行绘制，需要创建一个UIView对象，并实现它的drawRect:方法。视图的drawRect:方法在视图显示在屏幕上及它的内容需要更新时被调用(drawRect:方法更详细的介绍请移步苹果官方文档)
        •在调用自定义的drawRect:后，视图对象自动配置绘图环境以便能立即执行绘图操作
        •作为配置的一部分，视图对象将为当前的绘图环境创建一个Graphics Context。通过调用UIGraphicsGetCurrentContext()方法可以获取当前的Graphics Context
 
--------------------------------------------------------------------------------------
 
    开发介绍如下:
        1.如果要开发iOS程序,我们大部分使用就是UIKit框架里面提供的控件,而其坐标系介绍如下:
            •原点(0,0)在屏幕的左上角，X轴向右正向延伸，Y轴向下正向延伸
            •iOS的像素分辨率会随设备的硬件而变化，iPhone4第一次引入了视网膜屏幕，像素分辨率为960 * 640，刚好是前一代iPod和iPhone像素分辨率（ 480 * 320）的两倍
            •在绘图时，需要使用“点”的概念来思考问题，而不是像素。也就是说在点坐标系中绘图，不是硬件的像素坐标系
            •虽然这些设备的像素分辨率不同，但用到的坐标系保持不变(以点为单位)。在iPhone4上，一个点会用2像素宽度来绘制
            •提示：如果绘图的上下文，是使用UIGraphicsGetCurrentContext或者其他以UI开头的方法获取到的，在绘图时无需进行坐标转换(和下面2中的第二条照应)
 
        2.但是Quartz2D绘图时使用的坐标系是跟UIKit坐标系不同的,介绍如下::
            •Quartz中默认的坐标系统是：原点(0, 0)在左下角。沿着X轴从左到右坐标值逐渐增大；沿着Y轴从下到上坐标值逐渐增大
            •有一些技术在设置它们的graphics context时使用了不同于Quartz的默认坐标系统。最常见的一种修改的坐标系统是原点位于左上角，而沿着Y轴从上到下坐标值逐渐增大。例如：UIView中的UIGraphicsGetCurrentContext方法返回的图形上下文就是用的是这种坐标系
 
        3.Quartz2D坐标转换如下:(这三种操作会改变当前坐标系)
            1.CGContextRotateCTM(CGContextRef c, CGFloat angle)方法可以相对原点旋转上下文坐标系
            2.CGContextTranslateCTM(CGContextRef c, CGFloat tx, CGFloat ty)方法可以相对原点平移上下文坐标系
            3.CGContextScaleCTM(CGContextRef c, CGFloat sx, CGFloat sy)方法可以缩放上下文坐标系
         •注意：
            –转换坐标系（执行上面三种操作）前，使用CGContextSaveGState(CGContextRef c)保存当前上下文状态
            –坐标系转换后，使用CGContextRestoreGState(CGContextRef c)可以恢复之前保存的上下文状态
            如不过不使用CGContextSaveGState、CGContextRestoreGState，那么需要手动去恢复对坐标系的改变，比如之前顺时针旋转了30°，那么绘制结束需要逆时针旋转30°。
 
        4.如何利用Quartz2D绘制UIView
            •当在UIView子类中重写drawRect:方法时，iOS会自动准备好一个图形上下文，可以通过调用UIGraphicsGetCurrentContext()来获取
            •只要一个UIView需要被刷新或者重绘，drawRect:方法就会被调用，所以drawRect:的调用频率很高
            •需要注意的是：重绘时应该调用setNeedsDisplay，而不能直接调用drawRect:，setNeedsDisplay会自动调用drawRect:
 
        5.drawRect:方法注意事项::::
            •drawRect:是在UIViewController的loadView和viewDidLoad两方法之后调用的
            •如果在UIView初始化时没有设置CGRect，drawRect:将不会被自动调用
            •如果设置UIView的contentMode属性值为UIViewContentModeRedraw，那么将在每次更改frame时自动调用drawRect:
            •如果使用UIView绘图，只能在drawRect:方法中获取相应的CGContextRef并绘图。而在其他方法中获取的CGContextRef不能用于绘图
 
        6.Quartz2D是C语言的框架,并且部分需要自己管理内存:
            •使用含有“Create”或“Copy”的函数创建的对象，使用完后必须释放，否则将导致内存泄露
            •使用不含有“Create”或“Copy”的函数获取的对象，则不需要释放
            •如果retain了一个对象，不再使用时，需要将其release掉。可以使用Quartz 2D的函数来指定retain和release一个对象。例如，如果创建了一个CGColorSpace对象，则使用函数CGColorSpaceRetain和CGColorSpaceRelease来retain和release对象。也可以使用Core Foundation的CFRetain和CFRelease。注意不能传递NULL值给这些函数
 
 -------------------------------------------------------------------------------------
 
    关于一些API的使用教程：http://www.mamicode.com/info-detail-841887.html 链接失效可以查看印象笔记中存的HTML网页
 
 -------------------------------------------------------------------------------------
 
     此外图形和图像有什么区别?
     ---图形：以路径的方式描述的一个形状，在应用程序运行时，实时绘制（渲染/Rending）的形状
     ---图像：是以二进制数据的形式描述的一块像素点阵，在应用程序运行时，直接将该像素点阵逐一绘制在屏幕上
     所以不难看出图形的性能一般都会比图像高
 */

@end

