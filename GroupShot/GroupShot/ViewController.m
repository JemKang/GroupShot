//
//  ViewController.m
//  GroupShot
//
//  Created by kjh on 2018/2/6.
//  Copyright © 2018年 kjh. All rights reserved.
//

#import "ViewController.h"
#import <ZLPhotoActionSheet.h>
#import "ZLPhotoManager.h"
#import "ImageViewController.h"
#import "AutoRotateNavigationController.h"
#import "ZLCustomCamera.h"

@interface ViewController()<UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) UIImage *srcImage;
@property (nonatomic, strong) UIImage *dstImage;

@property (nonatomic, strong) NSMutableArray<UIImage *> *lastSelectPhotos;
@property (nonatomic, strong) NSMutableArray<PHAsset *> *lastSelectAssets;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *arrDataSources;
@property (nonatomic, strong) ZLCustomCamera *camera;
@property (nonatomic, assign) BOOL isOriginal;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
@synthesize srcImage = _srcImage;
@synthesize dstImage = _dstImage;

//获取图片
-(IBAction)openImageBtn:(id)sender
{
//    选择一张照片
//    UIImagePickerController *videoPicker = [[UIImagePickerController alloc] init];
//    videoPicker.delegate = self;
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
//    {
//        videoPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    }
//    videoPicker.allowsEditing = NO;
//    [self presentViewController:videoPicker animated:YES completion:nil];
    [self showWithPreview:NO];
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
        //[self nextViewController];
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
        //[strongSelf.collectionView reloadData];
        [strongSelf nextViewController];
        NSLog(@"%@", images);
    }];
}

//调整界面
- (void)nextViewController
{
    ImageViewController *imageView = [[ImageViewController alloc]init];
    imageView.selectPhotos = _lastSelectPhotos;
    AutoRotateNavigationController *nvc=[[AutoRotateNavigationController alloc]initWithRootViewController:imageView];
    [self presentViewController:nvc animated:YES completion:^{
        NSLog(@"跳转页面");
    }];

}
////打开相册或者拍照后调用
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info;
//{
//    [picker dismissViewControllerAnimated:YES completion:nil];
//    //NSURL *imagePath = info[@"UIImagePickerControllerReferenceURL"];
//    //NSString *strPath = [imagePath absoluteString];
//    //NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
//    //NSLog(@"%@",mediaType);
//    UIImage* image= [info objectForKey:UIImagePickerControllerOriginalImage];
//    UIImageOrientation imageOrientation=image.imageOrientation;
//    if(imageOrientation!=UIImageOrientationUp)
//    {
//        // 原始图片可以根据照相时的角度来显示，但UIImage无法判定，于是出现获取的图片会向左转９０度的现象。
//        // 以下为调整图片角度的部分
//        UIGraphicsBeginImageContext(image.size);
//        [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
//        image = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        // 调整图片角度完毕
//    }
//
//    self.srcImage = image;
//    //[imgView setImage:_srcImage];
//}
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return (NSUInteger)UIInterfaceOrientationMaskLandscape;
}
#pragma mark 强制横屏(针对present方式)
//- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
//    return (UIInterfaceOrientationLandscapeRight);
//}

- (BOOL)shouldAutorotate
{
    return YES;
}
//必须有
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeRight;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//拍照
-(IBAction)takePhotoBnt:(id)sender
{
    [self takePhoto];
}

- (void)takePhoto{
    if (![ZLPhotoManager haveCameraAuthority]) {
        NSString *message = [NSString stringWithFormat:GetLocalLanguageTextValue(ZLPhotoBrowserNoCameraAuthorityText), kAPPName];
//        ShowAlert(message, self.sender);
//        [self hide];
        return;
    }
//    if (!self.configuration.allowSelectImage &&
//        !self.configuration.allowRecordVideo) {
//        ShowAlert(@"allowSelectImage与allowRecordVideo不能同时为NO", self.sender);
//        return;
//    }
    if (NO) {
        //系统相机拍照
//        if ([UIImagePickerController isSourceTypeAvailable:
//             UIImagePickerControllerSourceTypeCamera]){
//            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//            picker.delegate = self;
//            picker.allowsEditing = NO;
//            picker.videoQuality = UIImagePickerControllerQualityTypeHigh;
//            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//            NSArray *a1 = self.configuration.allowSelectImage?@[(NSString *)kUTTypeImage]:@[];
//            NSArray *a2 = self.configuration.allowRecordVideo?@[(NSString *)kUTTypeMovie]:@[];
//            NSMutableArray *arr = [NSMutableArray array];
//            [arr addObjectsFromArray:a1];
//            [arr addObjectsFromArray:a2];
        
//            picker.mediaTypes = arr;
//            picker.videoMaximumDuration = self.configuration.maxRecordDuration;
//            [self.sender showDetailViewController:picker sender:nil];
//        }
    } else {
        if (![ZLPhotoManager haveMicrophoneAuthority]) {
            NSString *message = [NSString stringWithFormat:GetLocalLanguageTextValue(ZLPhotoBrowserNoMicrophoneAuthorityText), kAPPName];
            ShowAlert(message, self);
            //[self hide];
            return;
        }
        _camera = [[ZLCustomCamera alloc] init];
        _camera.allowTakePhoto = YES;
        //camera.allowRecordVideo = self.configuration.allowRecordVideo;
        _camera.sessionPreset = ZLCaptureSessionPreset1280x720;
        //camera.videoType = self.configuration.exportVideoType;
        //camera.circleProgressColor = self.configuration.bottomBtnsNormalTitleColor;
        //camera.maxRecordDuration = self.configuration.maxRecordDuration;
        zl_weakify(self);
        _camera.doneBlock = ^(UIImage *image, NSURL *videoUrl) {
            zl_strongify(weakSelf);
            //[strongSelf saveImage:image videoUrl:videoUrl];
            //[strongSelf takePhoto];
        };
        [self showDetailViewController:_camera sender:nil];
    }
}

@end
