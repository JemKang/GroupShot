//
//  ViewController.m
//  GroupPhotos
//
//  Created by kjh on 2018/3/22.
//  Copyright © 2018年 kjh. All rights reserved.
//

#import "ViewController.h"
#import <ZLPhotoActionSheet.h>
#import "ZLPhotoManager.h"
@interface ViewController ()

@property (nonatomic, strong) UIImage *srcImage;
@property (nonatomic, strong) UIImage *dstImage;

@property (nonatomic, strong) NSMutableArray<UIImage *> *lastSelectPhotos;
@property (nonatomic, strong) NSMutableArray<PHAsset *> *lastSelectAssets;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *arrDataSources;
@property (weak,nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, assign) BOOL isOriginal;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (ZLPhotoActionSheet *)getPas
{
    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
    
#pragma mark - 参数配置 optional，可直接使用 defaultPhotoConfiguration
    
    //以下参数为自定义参数，均可不设置，有默认值
//    actionSheet.configuration.sortAscending = self.sortSegment.selectedSegmentIndex==0;
//    actionSheet.configuration.allowSelectImage = self.selImageSwitch.isOn;
//    actionSheet.configuration.allowSelectGif = self.selGifSwitch.isOn;
//    actionSheet.configuration.allowSelectVideo = self.selVideoSwitch.isOn;
//    actionSheet.configuration.allowSelectLivePhoto = self.selLivePhotoSwitch.isOn;
//    actionSheet.configuration.allowForceTouch = self.allowForceTouchSwitch.isOn;
//    actionSheet.configuration.allowEditImage = self.allowEditSwitch.isOn;
//    actionSheet.configuration.allowEditVideo = self.allowEditVideoSwitch.isOn;
//    actionSheet.configuration.allowSlideSelect = self.allowSlideSelectSwitch.isOn;
//    actionSheet.configuration.allowMixSelect = self.mixSelectSwitch.isOn;
//    actionSheet.configuration.allowDragSelect = self.allowDragSelectSwitch.isOn;
    //设置相册内部显示拍照按钮
    actionSheet.configuration.allowTakePhotoInLibrary = YES;//self.takePhotoInLibrarySwitch.isOn;
    //设置在内部拍照按钮上实时显示相机俘获画面
    actionSheet.configuration.showCaptureImageOnTakePhotoBtn = YES;//self.showCaptureImageSwitch.isOn;
    //设置照片最大预览数
    actionSheet.configuration.maxPreviewCount = 20;//self.previewTextField.text.integerValue;
    //设置照片最大选择数
    actionSheet.configuration.maxSelectCount = 5;//self.maxSelCountTextField.text.integerValue;
    //设置允许选择的视频最大时长
    actionSheet.configuration.maxVideoDuration = 120;//self.maxVideoDurationTextField.text.integerValue;
    //设置照片cell弧度
    actionSheet.configuration.cellCornerRadio = 0;//self.cornerRadioTextField.text.floatValue;
    //单选模式是否显示选择按钮
//    actionSheet.configuration.showSelectBtn = YES;
    //是否在选择图片后直接进入编辑界面
    actionSheet.configuration.editAfterSelectThumbnailImage = NO;//self.editAfterSelectImageSwitch.isOn;
    //是否保存编辑后的图片
//    actionSheet.configuration.saveNewImageAfterEdit = NO;
    //设置编辑比例
//    actionSheet.configuration.clipRatios = @[GetClipRatio(7, 1)];
    //是否在已选择照片上显示遮罩层
    actionSheet.configuration.showSelectedMask = NO;//self.maskSwitch.isOn;
    //颜色，状态栏样式
//    actionSheet.configuration.selectedMaskColor = [UIColor purpleColor];
//    actionSheet.configuration.navBarColor = [UIColor orangeColor];
//    actionSheet.configuration.navTitleColor = [UIColor blackColor];
//    actionSheet.configuration.bottomBtnsNormalTitleColor = kRGB(80, 160, 100);
//    actionSheet.configuration.bottomBtnsDisableBgColor = kRGB(190, 30, 90);
//    actionSheet.configuration.bottomViewBgColor = [UIColor blackColor];
//    actionSheet.configuration.statusBarStyle = UIStatusBarStyleDefault;
    //是否允许框架解析图片
    actionSheet.configuration.shouldAnialysisAsset = YES;//self.allowAnialysisAssetSwitch.isOn;
    //框架语言
    actionSheet.configuration.languageType = 0;//self.languageSegment.selectedSegmentIndex;
    //自定义多语言
//    actionSheet.configuration.customLanguageKeyValue = @{@"ZLPhotoBrowserCameraText": @"没错，我就是一个相机"};
    
    //是否使用系统相机
//    actionSheet.configuration.useSystemCamera = YES;
//    actionSheet.configuration.sessionPreset = ZLCaptureSessionPreset1920x1080;
//    actionSheet.configuration.exportVideoType = ZLExportVideoTypeMp4;
//    actionSheet.configuration.allowRecordVideo = NO;
    
#pragma mark - required
    //如果调用的方法没有传sender，则该属性必须提前赋值
    actionSheet.sender = self;
    //记录上次选择的图片
//    actionSheet.arrSelectedAssets = self.rememberLastSelSwitch.isOn&&self.maxSelCountTextField.text.integerValue>1 ? self.lastSelectAssets : nil;
    
    zl_weakify(self);
    [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        zl_strongify(weakSelf);
        strongSelf.arrDataSources = images;
        strongSelf.isOriginal = isOriginal;
        strongSelf.lastSelectAssets = assets.mutableCopy;
        strongSelf.lastSelectPhotos = images.mutableCopy;
        [strongSelf.collectionView reloadData];
        NSLog(@"image:%@", images);
        //解析图片
        if (YES) {
            [strongSelf anialysisAssets:assets original:isOriginal];
        }
    }];
    
    actionSheet.cancleBlock = ^{
        NSLog(@"取消选择图片");
    };
    
    return actionSheet;
}
- (void)showWithPreview:(BOOL)preview
{
    ZLPhotoActionSheet *a = [self getPas];
    
    if (preview) {
        [a showPreviewAnimated:YES];
    } else {
        [a showPhotoLibrary];
    }
}
- (void)anialysisAssets:(NSArray<PHAsset *> *)assets original:(BOOL)original
{
    ZLProgressHUD *hud = [[ZLProgressHUD alloc] init];
    //该hud自动15s消失，请使用自己项目中的hud控件
    [hud show];
    
    zl_weakify(self);
    [ZLPhotoManager anialysisAssets:assets original:original completion:^(NSArray<UIImage *> *images) {
        zl_strongify(weakSelf);
        [hud hide];
        strongSelf.arrDataSources = images;
        [strongSelf.collectionView reloadData];
        NSLog(@"%@", images);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
