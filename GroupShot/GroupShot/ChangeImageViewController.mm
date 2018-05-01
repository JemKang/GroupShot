//
//  ChangeImageViewController.m
//  GroupShot
//
//  Created by kjh on 2018/4/5.
//  Copyright © 2018年 kjh. All rights reserved.
//

#import "ChangeImageViewController.h"
#import "MTCollectionView.h"
@interface ChangeImageViewController ()<UIScrollViewDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak,nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation ChangeImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *leftBarButtonItem1=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    [leftBarButtonItem1 setImage:[UIImage imageNamed:@"resource/icon/back.png"]];
    
    UIBarButtonItem *leftBarButtonItem2=[[UIBarButtonItem alloc]initWithTitle:@"选择一组好看的图片" style:UIBarButtonItemStylePlain target:self action:@selector(selectimage)];
    leftBarButtonItem2.width = 200;
    self.navigationItem.leftBarButtonItems = @[leftBarButtonItem1,leftBarButtonItem2];
    
    [self initCollectionView];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initCollectionView{
    //collectionView横向滑动
    self.automaticallyAdjustsScrollViewInsets = NO;
    CGRect screenRect = [ UIScreen mainScreen ].bounds;
    CGFloat itemWidth = screenRect.size.width - 300;
    CGFloat itemHeight= itemWidth / 318 * 170 + (251 - 170);
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    //self.collectionView.scrollsToTop = NO;
    self.collectionView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0];
    self.collectionView.alwaysBounceHorizontal = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    // 创建流水布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    //间距
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 12;
    //每个item的size
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
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

    UIImage *image = [_selectPhotos objectAtIndex:indexPath.row];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.imageView.image = image;
    return cell;
}
// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //
    UIImage *image = [_selectPhotos objectAtIndex:indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selcectPhoto" object:image];
    [self back];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
