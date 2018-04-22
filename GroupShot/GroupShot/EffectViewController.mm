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

@interface EffectViewController ()<UIScrollViewDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak,nonatomic) IBOutlet UIScrollView *scrollView;
//@property (nonatomic) UIImageView *imageView;
@property (weak,nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong,nonatomic) UIImageView *imageView;
@end

@implementation EffectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _imageView = [[UIImageView alloc]initWithFrame:_scrollView.bounds];
    _imageView.image = _srcImage;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;//设置自适应图片的宽高
    [_scrollView addSubview:_imageView];
    //设置实现缩放
    //设置代理scrollview的代理对象
    _scrollView.delegate=self;
    //设置最大伸缩比例
    _scrollView.maximumZoomScale=2.0;
    //设置最小伸缩比例
    //_scrollView.minimumZoomScale=0.0;
    [self initCollectionView];
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
#pragma mark - collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //TODO 素材的数量
    return 5;
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
