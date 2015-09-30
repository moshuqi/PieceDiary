//
//  PDGridInfoViewController.m
//  PieceDiary
//
//  Created by moshuqi on 15/9/30.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "PDGridInfoViewController.h"
#import "PDTopBarView.h"
#import "PDGridInfoCell.h"
#import "PDGridInfoSectionDataModel.h"
#import "PDInfoManager.h"

@interface PDGridInfoViewController () <PDTopBarViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet PDTopBarView *topBar;
@property (nonatomic, retain) NSArray *sectionDataArray;

@end

const CGFloat GridTableHeaderHeight = 30;
const CGFloat GridTableHeightForRow = 88;

@implementation PDGridInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.topBar.delegate = self;
    [self.topBar setTitleWithText:@"格子"];
    
    PDInfoManager *infoManager = [PDInfoManager defaultManager];
    self.sectionDataArray = [infoManager getGridInfoData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - PDTopBarViewDelegate

- (void)infoTableViewReturn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return GridTableHeightForRow;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return GridTableHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // 显示年月的标签
    CGFloat labelWidth = 120;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelWidth, GridTableHeaderHeight)];
    label.backgroundColor = [UIColor yellowColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    PDGridInfoSectionDataModel *sectionData = self.sectionDataArray[section];
    NSInteger year = sectionData.year;
    NSInteger month = sectionData.month;
    label.text = [NSString stringWithFormat:@"%ld年%ld月", (long)year, month];
    
    UIView *headerView = [[UIView alloc] init];
    [headerView addSubview:label];
    
    return headerView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    PDGridInfoSectionDataModel *sectionData = self.sectionDataArray[section];
    return [sectionData.cellDatas count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sectionDataArray count];
}

- (PDGridInfoCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PDGridInfoCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"PDGridInfoCell" owner:self options:nil] lastObject];
    
    PDGridInfoSectionDataModel *sectionData = self.sectionDataArray[indexPath.section];
    PDGridInfoCellDataModel *cellData = sectionData.cellDatas[indexPath.row];
    
    NSDate *date = cellData.date;
    NSInteger day = [PDInfoManager getDayValueWithDate:date];
    NSInteger weekday = [PDInfoManager getWeekdayValueWithDate:date];
    
    UIImage *image = [cellData.images firstObject]; // 只显示第一张照片
    [cell setupWithDay:day weekday:weekday question:cellData.question answer:cellData.answer photo:image];
    
    return cell;
}

@end
