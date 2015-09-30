//
//  PDImagePickerController.h
//  PieceDiary
//
//  Created by moshuqi on 15/9/22.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PDImagePickerController;

@protocol PDImagePickerControllerDelegate <NSObject>

- (void)imagePickerController:(PDImagePickerController *)imagePickerController pickFinishedWithPhotos:(NSArray *)photos;
- (void)imagePickerControllerCancel:(PDImagePickerController *)imagePickerController;

@end

@interface PDImagePickerController : UIViewController

@property (nonatomic, assign) id<PDImagePickerControllerDelegate> delegate;
@property (nonatomic, retain) NSDate *date;     // 相片对应的日期
@property (nonatomic, assign) NSInteger questionID;     // 对应的问题ID

@end
