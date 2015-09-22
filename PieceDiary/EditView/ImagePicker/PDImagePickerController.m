//
//  PDImagePickerController.m
//  PieceDiary
//
//  Created by moshuqi on 15/9/22.
//  Copyright © 2015年 msq. All rights reserved.
//

#import<AssetsLibrary/AssetsLibrary.h>
#import "PDImagePickerController.h"
#import "PDImagePickerCell.h"

#define PhotoThumbnailKey   @"PhotoThumbnailKey"
#define PhotoUrlKey         @"PhotoUrlKey"
#define ReuseIdentifier     @"ReuseIdentifier"

@interface PDImagePickerController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@end

@implementation PDImagePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self.collectionView registerNib:[UINib nibWithNibName:@"PDImagePickerCell" bundle:nil] forCellWithReuseIdentifier:ReuseIdentifier];
    self.collectionView.allowsMultipleSelection = YES;
    
    self.dataArray = [NSMutableArray array];
    [self setupData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupData
{
    // 获取本地相册的照片
    ALAssetsGroupEnumerationResultsBlock groupEnumerAtion = ^(ALAsset *result, NSUInteger index, BOOL *stop)
    {
        if (result!=NULL) {
            
            if ([[result valueForProperty:ALAssetPropertyType]isEqualToString:ALAssetTypePhoto]) {
                
                NSString *imgUrl=[NSString stringWithFormat:@"%@", result.defaultRepresentation.url];   //图片的url
                UIImage *img = [UIImage imageWithCGImage:result.thumbnail]; // 缩略图
                
                NSDictionary *dict = @{PhotoUrlKey : imgUrl,
                                       PhotoThumbnailKey : img};
                [self.dataArray addObject:dict];
                [self.collectionView reloadData];
            }
        }
    };
    
    ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror){
        NSLog(@"相册访问失败 = %@", [myerror localizedDescription]);
        if ([myerror.localizedDescription rangeOfString:@"Global denied access"].location!=NSNotFound) {
            NSLog(@"无法访问相册.请在'设置->定位服务'设置为打开状态.");
        }else{
            NSLog(@"相册访问失败.");
        }
    };
    
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group)
        {
            // 例 group:ALAssetsGroup - Name:Camera Roll, Type:Saved Photos, Assets count:6
            NSString *groupStr = [NSString stringWithFormat:@"%@",group];//获取相簿的组
            NSString *groupSubstr = [groupStr substringFromIndex:16];
            
            NSArray *arr = [NSArray arrayWithArray:[groupSubstr componentsSeparatedByString:@","]];
            NSString *name= [[arr objectAtIndex:0] substringFromIndex:5];
            
            if ([name isEqualToString:@"Camera Roll"])
            {
                // 相机胶卷
                [group enumerateAssetsUsingBlock:groupEnumerAtion];
            }
        }
    } failureBlock:failureblock];
}

- (IBAction)touchedCancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)touchedDone:(id)sender
{
    NSArray *array = [self.collectionView indexPathsForSelectedItems];
    NSMutableArray *photos = [NSMutableArray array];
    NSInteger count = [array count];
    
    for (NSInteger i = 0; i < count; i++)
    {
        NSIndexPath *indexPath = array[i];
        NSDictionary *dict = self.dataArray[indexPath.row];
        NSString *photoUrl = [dict valueForKey:PhotoUrlKey];
        
        ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
        NSURL *url = [NSURL URLWithString:photoUrl];
        
        [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset)
        {
            UIImage *image = [UIImage imageWithCGImage:[asset.defaultRepresentation fullResolutionImage]];
            [photos addObject:image];
            
            if (i + 1 == count)
            {
                // 选中的图片已获取完毕
                [self.delegate pickFinishedWithPhotos:photos];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }failureBlock:^(NSError *error) {
            NSLog(@"error=%@",error);
        }
        ];
    }
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return [self.dataArray count];
}

- (PDImagePickerCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PDImagePickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ReuseIdentifier forIndexPath:indexPath];
    
    UIImage *image = [self.dataArray[indexPath.row] valueForKey:PhotoThumbnailKey];
    [cell setThumbnailWithImage:image];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger number = 5; // 每行5张图
    CGFloat space = 2;
    CGFloat width = (CGRectGetWidth(collectionView.bounds) - (number + 1) * space) / number;
    
    return CGSizeMake(width, width);
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
