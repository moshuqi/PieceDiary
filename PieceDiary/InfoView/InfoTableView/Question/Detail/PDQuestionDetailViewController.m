//
//  PDQuestionDetailViewController.m
//  PieceDiary
//
//  Created by moshuqi on 15/10/3.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "PDQuestionDetailViewController.h"
#import "PDTopBarView.h"
#import "PDQuestionDetailCell.h"
#import "PDGridInfoSectionDataModel.h"
#import "NSDate+PDDate.h"

#define QuestionDetailReuseIdentifier @"QuestionDetailReuseIdentifier"


@interface PDQuestionDetailViewController () <PDTopBarViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet PDTopBarView *topBar;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, retain) NSArray *sectionDataArray;

@end

@implementation PDQuestionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor yellowColor];
    self.topBar.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PDQuestionDetailCell" bundle:nil] forCellReuseIdentifier:QuestionDetailReuseIdentifier];
}

- (id)initWithDataArray:(NSArray *)array titleText:(NSString *)title
{
    self = [super init];
    if (self)
    {
        self.sectionDataArray = array;
        [self.topBar setTitleWithText:title];
    }
    
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PDTopBarViewDelegate

- (void)infoTableViewReturn
{
    [self.delegate detailViewControllerReturn];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
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

- (PDQuestionDetailCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PDQuestionDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:QuestionDetailReuseIdentifier];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PDQuestionDetailCell" owner:self options:nil] firstObject];
    }
    
    PDGridInfoSectionDataModel *sectionData = self.sectionDataArray[indexPath.section];
    PDGridInfoCellDataModel *cellDataModel = sectionData.cellDatas[indexPath.row];
    
    NSDate *date = cellDataModel.date;
    UIImage *image = [cellDataModel.images firstObject];
    [cell setupWithDay:[date dayValue] weekday:[date weekdayValue] answer:cellDataModel.answer photo:image];
    
    return cell;
}

@end
