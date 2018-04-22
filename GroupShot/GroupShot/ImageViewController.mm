//
//  ImageViewController.m
//  GroupShot
//
//  Created by kjh on 2018/3/22.
//  Copyright © 2018年 kjh. All rights reserved.
//

#import "ImageViewController.h"
#import "MTCollectionView.h"
#import "WDDrawPath.h"
#import "WDDrawView.h"
#import "UIImage+ImageData.h"
#import "GSDefine.hpp"
#import <math.h>
#import "ChangeImageViewController.h"
#import "AutoRotateNavigationController.h"
#import "EffectViewController.h"
@interface ImageViewController ()<UIScrollViewDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    WDDrawView *drawView;
    bool isReloadData;
    CGRect realRect;
}
@property (weak,nonatomic) IBOutlet UIScrollView *scrollView;
//@property (nonatomic) UIImageView *imageView;
@property (weak,nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) CGPoint maxPoint;
@property (nonatomic) CGPoint minPoint;

@property (nonatomic) CGPoint leftTopPoint;
@property (nonatomic) CGPoint rightBottomPoint;
@property (strong,nonatomic) UIImage *srcImage;
//@property (nonatomic, weak) NSMutableArray<UIImage *> *showPhotos;
@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isReloadData = false;
    UIBarButtonItem *leftBarButtonItem1=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    UIBarButtonItem *leftBarButtonItem2 = [[UIBarButtonItem alloc]initWithTitle:@"撤销" style:UIBarButtonItemStylePlain target:self action:@selector(undo)];
    
    UIBarButtonItem *leftBarButtonItem3 = [[UIBarButtonItem alloc]initWithTitle:@"切换图片" style:UIBarButtonItemStylePlain target:self action:@selector(changeImage)];
    
    UIBarButtonItem *leftBarButtonItem4 = [[UIBarButtonItem alloc]initWithTitle:@"滤镜" style:UIBarButtonItemStylePlain target:self action:@selector(changeEffect)];
    self.navigationItem.leftBarButtonItems = @[leftBarButtonItem1,leftBarButtonItem2,leftBarButtonItem3,leftBarButtonItem4];
    
   // _scrollView.backgroundColor = [UIColor blackColor];
    _srcImage = [_selectPhotos objectAtIndex:0];
//    _imageView = [[UIImageView alloc]initWithFrame:_scrollView.bounds];
//    _imageView.image = _srcImage;
//
//    //[self cutImage:image Left:0 Right:720 Top:0 Bottom:1080];
//    _imageView.contentMode = UIViewContentModeScaleAspectFit;//设置自适应图片的宽高
    //设置UIScrollView的滚动范围和图片的真实尺寸一致
    _scrollView.scrollEnabled = NO;//设置禁止滚动
    _scrollView.backgroundColor = [UIColor whiteColor];
    //_scrollView.contentSize = _scrollView.bounds.size;
    //[_scrollView addSubview:_imageView];
    CGSize size = _srcImage.size;
    float ratio  = size.width / size.height;//图片宽高比
    CGSize scrollViewSize = _scrollView.bounds.size;
    float srollRatio = scrollViewSize.width / scrollViewSize.height;
    //图片显示设计
    if(srollRatio > ratio){//图片比较窄
        float rectWidth = ratio * scrollViewSize.height;
        realRect =CGRectMake((scrollViewSize.width - rectWidth)/2, _scrollView.bounds.origin.y, rectWidth,scrollViewSize.height);//图片显示的rect
    }
    else{//图片比较宽
        float rectHeight = scrollViewSize.width / ratio;//ratio = scrollViewSize.width / x
        realRect =CGRectMake(_scrollView.bounds.origin.x,(scrollViewSize.height - rectHeight)/2,scrollViewSize.width ,rectHeight);//图片显示的rect
    }
    drawView = [[WDDrawView alloc]initWithFrame:realRect];
    
    drawView.backgroundColor = [UIColor whiteColor];
    //drawView.image = image;
    drawView.pathColor = [UIColor blackColor];
    drawView.lineWidth = 15;
    drawView.image = _srcImage;
    drawView.contentMode = UIViewContentModeScaleAspectFit;//设置自适应图片的宽高
    [_scrollView addSubview:drawView];
    //设置实现缩放
    //设置代理scrollview的代理对象
    _scrollView.delegate=self;
    //设置最大伸缩比例
    _scrollView.maximumZoomScale=2.0;
    //设置最小伸缩比例
    //_scrollView.minimumZoomScale=0.0;
    [self initCollectionView];
    // Do any additional setup after loading the view from its nib.
    
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(drawPathInfoNotificationAction:) name:@"drawpath" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selcectPhotoInfoNotificationAction:) name:@"selcectPhoto" object:nil];
    _minPoint = CGPointMake(0.0, 0.0);
    _maxPoint = CGPointMake(_srcImage.size.width, _srcImage.size.height);
}
- (void)initCollectionView{
    //collectionView横向滑动
    self.automaticallyAdjustsScrollViewInsets = NO;
    CGRect screenRect = [ UIScreen mainScreen ].bounds;
    CGFloat itemWidth = screenRect.size.width - 56;
    CGFloat itemHeight= itemWidth / 318 * 170 + (251 - 170);
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    //self.collectionView.scrollsToTop = NO;
    self.collectionView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0];
    self.collectionView.alwaysBounceHorizontal = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    // 创建流水布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;

    //间距
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 12;
    //每个item的size
    layout.itemSize = CGSizeMake(self.collectionView.bounds.size.width - 8, 120);
    self.collectionView.collectionViewLayout = layout;
//    //注册cell
    [self.collectionView registerClass:[MTCollectionView class] forCellWithReuseIdentifier:@"cells"];
}

//消息回调
- (void)drawPathInfoNotificationAction:(NSNotification *)notification{
    //NSLog(@"change collectionView");
    NSDictionary *dict = notification.object;
    _maxPoint.x = [[dict objectForKey:@"maxPoint_x"] floatValue];
    _maxPoint.y = [[dict objectForKey:@"maxPoint_y"] floatValue];
    _minPoint.x = [[dict objectForKey:@"minPoint_x"] floatValue];
    _minPoint.y = [[dict objectForKey:@"minPoint_y"] floatValue];
    [self.collectionView reloadData];
}

//消息回调
- (void)selcectPhotoInfoNotificationAction:(NSNotification *)notification{
    _srcImage = notification.object;
    drawView.image = _srcImage;
}
//返回
-(void)back
{
    //编写点击返回按钮的点击事件
    //点击返回按钮，移除当前模态窗口
//    [self.navigationController dismissViewControllerAnimated:YES completion:^{
//        NSLog(@"移除模态窗口");
//    }];
    
// 如果一个控制器是以模态的形式展现出来的, 可以调用该控制器以及该控制器的子控制器让让控制器消失
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"返回");
    }];
}
//撤销
-(void)undo
{
    NSLog(@"撤销");
    [drawView undo];
    
}
//清除
-(void)clearPath
{
    NSLog(@"撤销");
    [drawView clear];
    
}
//切换图片
- (void)changeImage{
    NSLog(@"切换图片");
    [self nextViewController];
}
//调整界面
- (void)nextViewController
{
    ChangeImageViewController *nextView = [[ChangeImageViewController alloc]init];
    nextView.selectPhotos = _selectPhotos;
    AutoRotateNavigationController *nvc=[[AutoRotateNavigationController alloc]initWithRootViewController:nextView];
    [self presentViewController:nvc animated:YES completion:^{
        NSLog(@"跳转页面");
    }];
}

//切换滤镜
- (void)changeEffect{
    NSLog(@"切换滤镜效果");
    [self changeToEffectViewController];
}
//调整界面
- (void)changeToEffectViewController
{
    EffectViewController *nextView = [[EffectViewController alloc]init];
    nextView.srcImage = _srcImage;
    AutoRotateNavigationController *nvc=[[AutoRotateNavigationController alloc]initWithRootViewController:nextView];
    [self presentViewController:nvc animated:YES completion:^{
        NSLog(@"跳转到页面effect");
    }];
}
#pragma mark - collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //TODO 素材的数量
    return _selectPhotos.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MTCollectionView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cells" forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor colorWithRed:arc4random()%256/256.0 green:arc4random()%256/256.0 blue:arc4random()%256/256.0 alpha:0.4];
//    NSString *textString = [NSString stringWithFormat:@"%d",_nIndex];;
//    //MTCollectionView *tempCell =cell;
//    _nIndex++;
//    cell.titleLabel.text = textString;
//    NSString *bundle = [[NSBundle mainBundle]bundlePath];
//    NSString *path = [NSString stringWithFormat:@"%@/Assets/Filter/lookup_table.png",bundle];
//    UIImage *image = [UIImage imageNamed:path];
    //todo
    if(!CGPointEqualToPoint(_maxPoint, CGPointMake(_srcImage.size.width, _srcImage.size.height)) || !CGPointEqualToPoint(_minPoint,CGPointMake(0.0f, 0.0f))){
        UIImage *image = [_selectPhotos objectAtIndex:indexPath.row];
        CGSize realSize = realRect.size;
        int left =(int)fmax((_minPoint.x / realSize.width) * image.size.width ,0);
        int right = (int)fmin((_maxPoint.x / realSize.width) * image.size.width ,image.size.width);
        int top = (int)fmax((_minPoint.y / realSize.height) * image.size.height-8,0);
        int bottom = (int)fmin((_maxPoint.y / realSize.height) * image.size.height+8,image.size.height);
        int cutWidth = right -left;
        int cutHeight = bottom - top;
        float cellRatio = cell.bounds.size.width / cell.bounds.size.height;
        float cutRatio = cutWidth / (cutHeight * 1.0f);
        if(fabs(cellRatio - cutRatio) > 0.001){//比例不相等
            //变成相同比例
            if(cellRatio > cutRatio){//如果cell的宽高比大于cut的宽高比，cut的宽需要增大
                int tempWidth = cellRatio * cutHeight;
                int dif = (tempWidth - cutWidth) / 2;
                if(left - dif < 0){
                    right =  (int)fmin(right + 2 * dif ,image.size.width);
                }else{
                    left = (int)fmax(left - dif ,0);
                    right =  (int)fmin(right + dif ,image.size.width);
                }
            }
            else{//如果cell的宽高比小于cut的宽高比，cut的高需要增大
               // cellRatio = cutWidth / cutHeight;
                int tempHeight =  cutWidth / cellRatio;
                int dif = (tempHeight - cutHeight) / 2;
                if(top - dif < 0){
                    bottom = (int)fmin(bottom + 2 * dif,image.size.height);
                }
                else{
                    top = (int)fmax(top - dif,0);
                    bottom = (int)fmin(bottom + dif,image.size.height);
                }
            }
        }
        _leftTopPoint = CGPointMake(left, top);
        _rightBottomPoint = CGPointMake(right, bottom);
        UIImage *cutImage = [self cutImage:image Left:left Right:right Top:top Bottom:bottom];
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
        //NSLog(@"cell x = %f y = %f",cell.bounds.size.width,cell.bounds.size.height);
        cell.imageView.image = cutImage;
    }else{
        UIImage *image = [_selectPhotos objectAtIndex:indexPath.row];
        //cell.imageView.contentMode = UIViewContentModeCenter;
        cell.imageView.image = image;
    }


    return cell;
}
// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //
    UIImage *image = [_selectPhotos objectAtIndex:indexPath.row];
    _srcImage = [self mergeImage:_srcImage SrcImage2:image Left:_leftTopPoint.x Right:_rightBottomPoint.x Top:_leftTopPoint.y Bottom:_rightBottomPoint.y];
    drawView.image = _srcImage;
    //[drawView clear];

}

- (UIImage *)mergeImage:(UIImage *)srcImage1 SrcImage2:(UIImage *)srcImage2 Left:(int)left Right:(int)right Top:(int)top Bottom:(int)bottom
{
    //从src2截取一部分到src1
    UIImage *dstImage = srcImage1;
    unsigned char *srcData1 = [srcImage1 RGBAData];
    unsigned char *srcData2 = [srcImage2 RGBAData];
    int cutWidth = right - left;
    for(int i = top; i < bottom;i++){
        memcpy((void *)(srcData1 + (i * (int)_srcImage.size.width + left) * 4),(void *)(srcData2 + (i * (int)_srcImage.size.width + left) * 4),cutWidth * 4);
    }
    dstImage = [UIImage imageWithRGBAData:srcData1 withWidth:_srcImage.size.width withHeight:_srcImage.size.height];
    SAFE_DELETE_ARRAY(srcData1);
    SAFE_DELETE_ARRAY(srcData2);
    return dstImage;
}
//裁剪图片
- (UIImage *)cutImage:(UIImage *)image Left:(int)left Right:(int)right Top:(int)top Bottom:(int)bottom
{
    unsigned char *data = [image RGBAData];
    int cutWidth = right - left;
    int cutHeight = bottom - top;
    unsigned char *cutData = new unsigned char[cutWidth * cutHeight *4];
    unsigned char *dest = cutData;
    for(int i = top; i < bottom;i++){
        memcpy(dest,(void *)(data + (i * (int)image.size.width + left) * 4),cutWidth * 4);
        dest = dest + cutWidth * 4;
    }
    UIImage *cutImage = [UIImage imageWithRGBAData:cutData withWidth:cutWidth withHeight:cutHeight];
    SAFE_DELETE_ARRAY(cutData);
    return cutImage;
}
//告诉scrollview要缩放的是哪个子控件
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return drawView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//#pragma mark 强制横屏(针对present方式)
//- (BOOL)prefersStatusBarHidden
//{
//    return NO;
//}
- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeRight;
}

@end
