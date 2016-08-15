//
//  PDDiaryInfoTableViewController.m
//  PieceDiary
//
//  Created by moshuqi on 15/9/29.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "PDDiaryInfoTableViewController.h"
#import "PDTopBarView.h"
#import "PDDiaryInfoSectionData.h"
#import "PDDiaryInfoCell.h"
#import "PDDataManager.h"

#define DiaryInfoTableIdentifier    @"DiaryInfoTableIdentifier"

@interface PDDiaryInfoTableViewController () <PDTopBarViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet PDTopBarView *topBar;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSArray *sectionDataArray;

@end

const CGFloat DiaryTableHeaderHeight = 30;
const CGFloat DiaryTableHeightForRow = 88;

@implementation PDDiaryInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.topBar.delegate = self;
    [self.topBar setTitleWithText:@"日记"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        PDDataManager *dataManager = [PDDataManager defaultManager];
        self.sectionDataArray = [dataManager getDiaryInfoData];
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            [self.tableView reloadData];
        });
    });

    [self.tableView registerNib:[UINib nibWithNibName:@"PDDiaryInfoCell" bundle:nil] forCellReuseIdentifier:DiaryInfoTableIdentifier];
    
    self.tableView.backgroundColor = BackgroudGrayColor;
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
    PDDiaryInfoSectionData *sectionData = self.sectionDataArray[indexPath.section];
    PDDiaryInfoCellData *cellData = sectionData.cellDatas[indexPath.row];
    NSDate *date = cellData.date;
    
    [self.baseVCDelegate baseInfoViewController:self dismissAndEnterPieceViewWithDate:date];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return DiaryTableHeightForRow;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return DiaryTableHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // 显示年月的标签
    CGFloat labelWidth = 120;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelWidth, DiaryTableHeaderHeight)];
    label.backgroundColor = MainBlueColor;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    PDDiaryInfoSectionData *sectionData = self.sectionDataArray[section];
    NSInteger year = sectionData.year;
    NSInteger month = sectionData.month;
    label.text = [NSString stringWithFormat:@"%@年%@月", @(year), @(month)];
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = BackgroudGrayColor;
    [headerView addSubview:label];
    
    return headerView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    PDDiaryInfoSectionData *sectionData = self.sectionDataArray[section];
    return [sectionData.cellDatas count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sectionDataArray count];
}

- (PDDiaryInfoCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PDDiaryInfoCell *cell = [self.tableView dequeueReusableCellWithIdentifier:DiaryInfoTableIdentifier];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PDDiaryInfoCell" owner:self options:nil] lastObject];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        PDDiaryInfoSectionData *sectionData = self.sectionDataArray[indexPath.section];
        PDDiaryInfoCellData *cellData = sectionData.cellDatas[indexPath.row];
        
        NSDate *date = cellData.date;
        NSInteger day = [date dayValue];
        NSInteger weekday = [date weekdayValue];
        
        PDDataManager *dataManager = [PDDataManager defaultManager];
        UIImage *weatherImage = [dataManager getWeatherImageWithDate:date];
        UIImage *moodImage = [dataManager getMoodImageWithDate:date];
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            [cell setupWithDay:day weekday:weekday weatherImage:weatherImage moodImage:moodImage];
        });
    });
    
    return cell;
}





@end
