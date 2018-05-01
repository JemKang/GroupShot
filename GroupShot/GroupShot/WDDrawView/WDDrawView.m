//
//  WDDrawView.m
//  WDDrawingBoardDemo
//
//  Created by WD on 16/9/21.
//  Copyright © 2016年 WD. All rights reserved.
//

#import "WDDrawView.h"
#import "WDDrawPath.h"

@interface WDDrawView ()
@property (nonatomic, strong) WDDrawPath *path;
@property (nonatomic, strong) NSMutableArray *paths;
@property (nonatomic) CGPoint maxPoint;
@property (nonatomic) CGPoint minPoint;
@end

@implementation WDDrawView

- (void)awakeFromNib
{
    [self setUp];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _maxPoint = CGPointMake(0.0, 0.0);
        _minPoint = CGPointMake(frame.size.width, frame.size.height);
        [self setUp];
        
    }
    return self;
}
// 初始化设置
- (void)setUp
{
    // 添加pan手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    
    [self addGestureRecognizer:pan];
    
    _lineWidth = 1;
    _pathColor = [UIColor blackColor];
    //_imageView.contentMode = UIViewContentModeScaleAspectFit;
}
//得到最大点
- (CGPoint)pathMaxPoint:(CGPoint)point
{
    if(point.x > _maxPoint.x && point.x < self.bounds.size.width){
        _maxPoint.x = point.x;
    }
    if(point.y > _maxPoint.y && point.y < self.bounds.size.height){
        _maxPoint.y = point.y;
    }
    return _maxPoint;
}

- (CGPoint)pathMinPoint:(CGPoint)point
{
    if(point.x < _minPoint.x && point.x > 0.0f){
        _minPoint.x = point.x;
    }
    if(point.y < _minPoint.y && point.y > 0.0f){
        _minPoint.y = point.y;
    }
    return _minPoint;
}
// 当手指拖动的时候调用
- (void)pan:(UIPanGestureRecognizer *)pan
{
    
    // 获取当前手指触摸点
    CGPoint curP = [pan locationInView:self];
    _maxPoint = [self pathMaxPoint:curP];
    _minPoint = [self pathMinPoint:curP];
    // 获取开始点
    if (pan.state == UIGestureRecognizerStateBegan) {
        // 创建贝瑟尔路径
        _path = [[WDDrawPath alloc] init];
        
        // 设置线宽
        _path.lineWidth = _lineWidth;
        
        // 给路径设置颜色
        _path.pathColor = _pathColor;
        
        _path.lineCapStyle = kCGLineCapRound;
        _path.lineJoinStyle = kCGLineJoinBevel;
        // 设置路径的起点
        [_path moveToPoint:curP];
        
        // 保存描述好的路径
        [self.paths addObject:_path];
        //NSLog(@"11111");
        
    }
    //NSLog(@"2222");
//    NSLog(@"point x = %f,y = %f",curP.x,curP.y);
    //NSLog(@"point x = %f,y = %f",_minPoint.x,_minPoint.y);
    // 手指一直在拖动
    // 添加线到当前触摸点
    [_path addLineToPoint:curP];
    
    // 重绘
    [self setNeedsDisplay];
    
    //绘制结束，发送通知
    if(pan.state == UIGestureRecognizerStateEnded){
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
        [dict setObject:[NSString stringWithFormat:@"%f",_maxPoint.x] forKey:@"maxPoint_x"];
        [dict setObject:[NSString stringWithFormat:@"%f",_maxPoint.y] forKey:@"maxPoint_y"];
        [dict setObject:[NSString stringWithFormat:@"%f",_minPoint.x] forKey:@"minPoint_x"];
        [dict setObject:[NSString stringWithFormat:@"%f",_minPoint.y] forKey:@"minPoint_y"];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"drawpath" object:dict];
    }
}


- (void)setImage:(UIImage *)image
{
    _image = image;
    [self.paths addObject:_image];

    // 重绘
    [self setNeedsDisplay];
}

//- (void)setImageView:(UIImageView *)imageView
//{
//    _imageView = imageView;
//    [self addSubview:_imageView];
//}
- (void)clear
{
    int count = self.paths.count;
    for(int i = 0;i < count - 1;i++){
        [self.paths removeLastObject];
    }

    [self setNeedsDisplay];
    _maxPoint = CGPointMake(0.0, 0.0);
    _minPoint = CGPointMake(self.frame.size.width,self.frame.size.height);
}


- (void)undo
{
    if(self.paths.count != 1){
        [self.paths removeLastObject];
    }
    if(self.paths.count == 1){
        _maxPoint = CGPointMake(0.0, 0.0);
        _minPoint = CGPointMake(self.frame.size.width,self.frame.size.height);
    }
    [self setNeedsDisplay];
}

- (NSMutableArray *)paths
{
    if (_paths == nil) {
        _paths = [NSMutableArray array];
    }
    return _paths;
}

// 绘制图形
// 只要调用drawRect方法就会把之前的内容全部清空
- (void)drawRect:(CGRect)rect
{
    for (WDDrawPath *path in self.paths) {
        
        if ([path isKindOfClass:[UIImage class]]) {
            // 绘制图片
            UIImage *image = (UIImage *)path;
            //self.layer.contents = (id)image.CGImage;
            //背景透明加上这一句
            //self.layer.backgroundColor = [UIColor clearColor].CGColor;
            [image drawInRect:rect];
        }
        else{
        
            // 画线
            [path.pathColor set];
            
            [path stroke];
        }
        
    }
}

@end
