//
//  EffectViewController.m
//  GroupShot
//
//  Created by kjh on 2018/4/22.
//  Copyright © 2018年 kjh. All rights reserved.
//

#import "EffectViewController.h"
#import "AutoRotateNavigationController.h"
#import "MTCollectionView.h"
#import "PublicFunction.h"
#import "EffectRender.h"
#import "UIImage+ImageData.h"
@interface EffectViewController ()<UIScrollViewDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    EffectRender *effectRender;
    UILongPressGestureRecognizer *longPressGestureRecognizer;
}
@property (weak,nonatomic) IBOutlet UIScrollView *scrollView;
//@property (nonatomic) UIImageView *imageView;
@property (weak,nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong,nonatomic) UIImageView *imageView;
@property (nonatomic, strong) NSMutableArray *dataArray;//存放滤镜文件
@end

@implementation EffectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _dstImage = _srcImage;
    UIBarButtonItem *leftBarButtonItem1=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    [leftBarButtonItem1 setImage:[UIImage imageNamed:@"resource/icon/back.png"]];
    self.navigationItem.leftBarButtonItems = @[leftBarButtonItem1];
    _imageView = [[UIImageView alloc]initWithFrame:_scrollView.bounds];
    _imageView.image = _dstImage;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;//设置自适应图片的宽高
    _imageView.userInteractionEnabled = YES;
    _scrollView.userInteractionEnabled = YES;
    [_scrollView addSubview:_imageView];
    //设置实现缩放
    //设置代理scrollview的代理对象
    _scrollView.delegate=self;
    _scrollView.backgroundColor = [UIColor colorWithRed:(41.0f/255.0f) green:(36.0f/255.0f) blue:(33.0f/255.0f) alpha:1.0];
    //设置最大伸缩比例
    _scrollView.maximumZoomScale=2.0;
    //设置最小伸缩比例
    //_scrollView.minimumZoomScale=0.0;
    [self loadEffectFile];
    [self initCollectionView];
    effectRender = [[EffectRender alloc]init];
    longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self
                                action:@selector(handleLongPressGestures:)];
    longPressGestureRecognizer.numberOfTouchesRequired = 1;
    //longPressGestureRecognizer.minimumPressDuration = 1.0;
    [_imageView addGestureRecognizer:longPressGestureRecognizer];
    [_scrollView addGestureRecognizer:longPressGestureRecognizer];
    
}
- (void) handleLongPressGestures:(UILongPressGestureRecognizer *)paramSender{

//    if ([paramSender isEqual:longPressGestureRecognizer]){
//        NSLog(@"receive long press");
//
//    }
    if (paramSender.state ==UIGestureRecognizerStateBegan) {
        NSLog(@"UIGestureRecognizerStateBegan");
        _imageView.image = _srcImage;

    }
//    if (paramSender.state == UIGestureRecognizerStateChanged) {
//        NSLog(@"UIGestureRecognizerStateChanged");
//        _imageView.image = _dstImage;
//    }
    if (paramSender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"UIGestureRecognizerStateEnded");
        _imageView.image = _dstImage;
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
-(void)loadEffectFile
{
    NSString *inputPath = [[NSString alloc]initWithUTF8String:getEffectBundle()];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *fileList = [[NSArray alloc] init];
    //获取文件夹名称
    fileList = [fileManager contentsOfDirectoryAtPath:inputPath error:&error];
    self.dataArray = [[NSMutableArray alloc]init];
    for(int i = 0;i <fileList.count;i++)
    {
        NSString *path = [fileList objectAtIndex:i];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@",inputPath,path];
        [self.dataArray addObject:filePath];
    }
}
#pragma mark - collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //TODO 素材的数量
    return self.dataArray.count;
}

//返回
-(void)back
{
    //编写点击返回按钮的点击事件
// 如果一个控制器是以模态的形式展现出来的, 可以调用该控制器以及该控制器的子控制器让让控制器消失
    [self dismissViewControllerAnimated:YES completion:^{
        //NSLog(@"返回");
    }];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MTCollectionView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cells" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:arc4random()%256/256.0 green:arc4random()%256/256.0 blue:arc4random()%256/256.0 alpha:0.4];
//    NSString *textString = [NSString stringWithFormat:@"%d",_nIndex];;
//    //MTCollectionView *tempCell =cell;
//    _nIndex++;
//    cell.titleLabel.text = textString;
//    NSString *bundle = [[NSBundle mainBundle]bundlePath];
//    NSString *path = [NSString stringWithFormat:@"%@/Assets/Filter/lookup_table.png",bundle];
//    UIImage *image = [UIImage imageNamed:path];
    //tod

    return cell;
}
// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *folderName = [self.dataArray objectAtIndex:indexPath.row];
    NSString *filterConfig = [folderName stringByAppendingString:@"/configuration.plist"];
    [effectRender loadConfig:[filterConfig UTF8String]];
    unsigned char * pData = [_srcImage RGBAData];
    int width = _srcImage.size.width ;
    int height = _srcImage.size.height;
    [effectRender render:pData Width:width Height:height];
    _dstImage  = [UIImage imageWithRGBAData:pData withWidth:width withHeight:height];
    _imageView.image = _dstImage;
    
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
