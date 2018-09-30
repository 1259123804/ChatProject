//
//  XGPublicDynamicViewController.m
//  ChatProject
//
//  Created by Duke Li on 2018/9/26.
//  Copyright © 2018年 Duke Li. All rights reserved.
//

#import "XGPublicDynamicViewController.h"
#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import "TZTestCell.h"
#import "TZImageManager.h"
#import "TZAssetModel.h"
@interface XGPublicDynamicViewController ()<UITextViewDelegate,UIScrollViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate, UIAlertViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,TZImagePickerControllerDelegate>{
   
}
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UITextView *textView;
@property(nonatomic, strong) UIButton *cameraBtn;
@property(nonatomic, strong) UIView *wxView;
@property(nonatomic, assign) NSInteger count;
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSMutableArray *selectedPhotos;
@property(nonatomic, strong) NSMutableArray *selectedAssets;
@property(nonatomic, assign) CGFloat itemWH;
@property(nonatomic, assign) CGFloat margin;
@property(nonatomic, strong) UILabel *placeLabel;
@property(nonatomic, strong) UIControl *control;
@property (nonatomic, strong)TZImagePickerController *tzImageController;
@property (nonatomic, retain) NSMutableArray *imageArray;
@property (nonatomic, retain) NSMutableArray *btnArray;

@end

@implementation XGPublicDynamicViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self setHidesBottomBarWhenPushed:YES];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    label.textColor = UIColorWithRGBA(74, 74, 74, 1);
    label.font = [UIFont systemFontOfSize:17.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"分享";
    self.navigationItem.titleView  = label;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib
    self.view.backgroundColor = [UIColor whiteColor];
    _imageArray = [NSMutableArray array];
    _btnArray = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    _selectedPhotos = [NSMutableArray array];
    _count = 0;
    [self setNavBar];
    [self setTextView];
}

- (void)setNavBar
{
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editBtn.frame = CGRectMake(kScreenWidth-10-30, 30, 30, 23);
    [editBtn setTitle:@"分享" forState:UIControlStateNormal];
    [editBtn setTitleColor:UIColorWithRGBA(255, 81, 12, 1) forState:UIControlStateNormal];
    [editBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [editBtn addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
    
    
}

- (void)setTextView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight);
    _scrollView.delegate = self;
    _scrollView.tag = 100;
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, kScreenWidth-10, 155)];
    [_textView setFont:[UIFont systemFontOfSize:15]];
    [_textView setBackgroundColor:[UIColor whiteColor]];
    [_textView setReturnKeyType:UIReturnKeyDone];
    [_textView setEnablesReturnKeyAutomatically:YES];
    [_textView setTextContainerInset:UIEdgeInsetsMake(10, 5, 5, 0)];
    _textView.tag = 101;
    [_textView setDelegate:self];
    [_scrollView addSubview:_textView];
    
    _placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, 150, 21)];
    _placeLabel.text = @"说点什么吧";
    _placeLabel.enabled = NO;
    _placeLabel.backgroundColor = [UIColor clearColor];
    _placeLabel.font = [UIFont systemFontOfSize:15.0f];
    _placeLabel.textColor = UIColorWithRGBA(210, 210, 210, 1);
    [_scrollView addSubview:_placeLabel];
    
    _control = [[UIControl alloc] initWithFrame:_textView.frame];
    [_control addTarget:self action:@selector(textViewDismiss) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_control];
    [_scrollView bringSubviewToFront:_control];
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _margin = 15;
    _itemWH = (kScreenWidth - 5 * _margin)/4;
    layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    layout.minimumInteritemSpacing = _margin;
    layout.minimumLineSpacing = _margin;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 160, kScreenWidth, 300) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.contentInset = UIEdgeInsetsMake(15, 15, 15, 15);
    _collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, -2);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
    [_scrollView addSubview:_collectionView];
    
    [self.view addSubview:_scrollView];
}


- (void)textViewDismiss
{
    static BOOL isFirstResponder = NO;
    
    if (isFirstResponder == NO) {
        
        [_textView becomeFirstResponder];
        
        if(_textView.text == nil || _textView.text.length == 0){
            
            _placeLabel.hidden = NO;
            
        }else{
            
            _placeLabel.hidden = YES;
        }
        
        
    }else{
        
        [_textView resignFirstResponder];
        if (_textView.text == nil || _textView.text.length == 0) {
            
            _placeLabel.hidden = NO;
            
        }else{
            
            _placeLabel.hidden = YES;
        }
    }
    
    isFirstResponder = !isFirstResponder;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    if (indexPath.row == _selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"AlbumAddBtn.png"];
        cell.deleteBtn.hidden = YES;
        cell.deleteBtn.userInteractionEnabled = NO;
    } else {
        [cell.deleteBtn setTag:indexPath.item+10];
        cell.deleteBtn.hidden = NO;
        cell.deleteBtn.userInteractionEnabled = YES;
        [cell.deleteBtn addTarget:self action:@selector(deleteImageClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.imageView.image = _selectedPhotos[indexPath.row];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _selectedPhotos.count) {
        
        if(_selectedPhotos.count == 9){
            
            MyAlertView(@"最多只能添加9张图片哦", nil);
            return;
        }
        
        [self cameraClick];
    }
}



- (void)shareWxClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
}

- (void)cameraClick
{
    [_textView resignFirstResponder];
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"图片库",@"拍照", nil];
    
    sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    sheet.delegate = self;
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //呼出的菜单按钮点击后的响应
    if (buttonIndex == actionSheet.cancelButtonIndex)
    {
        NSLog(@"取消");
    }
    
    switch (buttonIndex)
    {
        case 1:  //打开照相机拍照
            [self takePhoto];
            break;
            
        case 0:  //打开本地相册
            [self LocalPhoto];
            break;
    }
}

//开始拍照
-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    _tzImageController = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    
    
    
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    if (!error) {
        
        [[TZImageManager manager] getCameraRollAlbum:_tzImageController.allowPickingVideo allowPickingImage:_tzImageController.allowPickingImage completion:^(TZAlbumModel *model) {
            
            [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:self.tzImageController.allowPickingVideo allowPickingImage:self.tzImageController.allowPickingImage completion:^(NSArray<TZAssetModel *> *models) {
                
                TZAssetModel *model = [models lastObject];
                if (self.tzImageController.selectedModels.count < self.tzImageController.maxImagesCount) {
                    [self.selectedPhotos addObject:image];
                    [self.collectionView reloadData];
                    [self.selectedAssets addObject:model.asset];
                    [self.tzImageController.selectedModels addObject:model];
                }
                
            }];
        }];
    }
    
    
    
}


//打开本地相册
-(void)LocalPhoto
{
    
    // optional, 可选的
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    _tzImageController = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    _tzImageController.selectedAssets = _selectedAssets;
    [_tzImageController setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    
    // Set the appearance
    // 在这里设置imagePickerVc的外观
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    
    // Set allow picking video & photo & originalPhoto or not
    // 设置是否可以选择视频/图片/原图
    // imagePickerVc.allowPickingVideo = NO;
    // imagePickerVc.allowPickingImage = NO;
    // imagePickerVc.allowPickingOriginalPhoto = NO;
    
    [self presentViewController:_tzImageController animated:YES completion:nil];
    
}
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    //
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)", _selectedPhotos];
    //    NSArray *photoArr = [photos filteredArrayUsingPredicate:predicate];
    //
    //    NSPredicate *predicates = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)", _selectedAssets];
    //    NSArray *assetArr = [assets filteredArrayUsingPredicate:predicates];
    _selectedPhotos = [NSMutableArray arrayWithArray: photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    
    [_collectionView reloadData];
    _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
}


#pragma mark 删除图片

- (void)deleteImageClick:(UIButton *)sender
{
    [_textView resignFirstResponder];
    [_selectedAssets removeObjectAtIndex:sender.tag-10];
    _tzImageController.selectedAssets = _selectedAssets;
    [_selectedPhotos removeObjectAtIndex:sender.tag-10];
    [_collectionView reloadData];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)shareClick
{
    [_textView resignFirstResponder];
    if ((_textView.text == nil || _textView.text.length == 0) && _selectedPhotos == nil) {
        
        MyAlertView(@"请添加分享的内容", nil);
        return;
    }
    [self sendShare];
    
    
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    _scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight-64+216);
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0 || textView.text == nil) {
        
        _placeLabel.hidden = NO;
        
    }else{
        
        _placeLabel.hidden = YES;
    }
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if(![textView hasText] && [text isEqualToString:@""]){
        return NO;
    }
    if ([text isEqualToString:@"\n"]) {
        if (![_textView hasText]&&(_textView.text.length==0)) {
            return NO;
        }
        
        if (_textView.text.length > 0) {
            //TODO:发送到服务器
            // [self shareClick];
            [_textView resignFirstResponder];
            
        }
        return NO;
    }
    return YES;
}

- (void)sendShare
{
    //TODO:上传到阿里云
    if (_selectedAssets.count != 0) {
        
        [MyTools uploadImageWithImage:_selectedPhotos uploadType:@"1" completion:^(NSDictionary *responseObject, NSArray*imageArr) {
        
            //TODO:上传到服务器
            NSString *askUrl = [kTestApi stringByAppendingString:kdynamic_publish];
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:imageArr options:NSJSONWritingPrettyPrinted error:&error];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSDictionary *dataDic = @{@"content":self.textView.text,@"images": jsonString};
            [MyAFSessionManager requestWithURLString:askUrl parameters:dataDic requestType:MyRequestTypePost managerType:MyAFSessionManagerTypeJsonWithToken success:^(id  _Nullable responseObject) {
                if (responseObject) {
                    
                    if ([responseObject[@"status"] intValue] == 0){
                        
                        [self.selectedPhotos removeAllObjects];
                        [self.selectedAssets removeAllObjects];
                        [self.collectionView reloadData];
                        self.textView.text = nil;
                        MyAlertView(responseObject[@"result"], nil);
                    
                        
                    }else if(responseObject[@"message"]){
                        
                        MyAlertView(responseObject[@"message"], nil);
                    }
                }
                
            } failure:^(NSError * _Nonnull error) {
                MyAlertView(@"网络异常", nil);
            }];
        }];
        
    }else if(self.textView.text.length != 0 && self.textView.text != nil) {
        
        NSString *askUrl = [kTestApi stringByAppendingString:kdynamic_publish];
        NSDictionary *dataDic = @{@"content":_textView.text};
        [MyAFSessionManager requestWithURLString:askUrl parameters:dataDic requestType:MyRequestTypePost managerType:MyAFSessionManagerTypeJsonWithToken success:^(id  _Nullable responseObject) {
            if (responseObject) {
                
                NSDictionary *dic = nil;
                if ([responseObject isKindOfClass:[NSData class]]) {
                    dic  = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                    
                }else if([responseObject isKindOfClass:[NSDictionary class]]){
                    
                    dic  = responseObject;
                }
                
                if ([dic[@"code"] intValue] == 200){
                    
                    self.textView.text = nil;
                    self.placeLabel.hidden = NO;
                    MyAlertView(@"分享成功", nil);
                    
                }else if([dic[@"code"] intValue] == 500){
                    
                }else if(dic[@"message"]){
                    MyAlertView(dic[@"message"], nil);
                }
                
            }
            
        } failure:^(NSError * _Nonnull error) {
            
            MyAlertView(@"网络异常", nil);
        }];
        
        
    }else {
        
        MyAlertView(@"还没有添加内容哦", nil);
    }
}

- (NSData *)resetSizeOfImageData:(UIImage *)source_image maxSize:(NSInteger)maxSize
{
    //先调整分辨率
    CGSize newSize = CGSizeMake(source_image.size.width, source_image.size.height);
    
    CGFloat tempHeight = newSize.height / 1024;
    CGFloat tempWidth = newSize.width / 1024;
    
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSizeMake(source_image.size.width / tempWidth, source_image.size.height / tempWidth);
    }
    else if (tempHeight > 1.0 && tempWidth < tempHeight){
        newSize = CGSizeMake(source_image.size.width / tempHeight, source_image.size.height / tempHeight);
    }
    
    UIGraphicsBeginImageContext(newSize);
    [source_image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //调整大小
    NSData *imageData = UIImageJPEGRepresentation(newImage,1);
    NSUInteger sizeOrigin = [imageData length];
    NSUInteger sizeOriginKB = sizeOrigin / 1024;
    if (sizeOriginKB > maxSize) {
        NSData *finallImageData = UIImageJPEGRepresentation(newImage,0.50);
        return finallImageData;
    }
    
    return imageData;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
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

@end
