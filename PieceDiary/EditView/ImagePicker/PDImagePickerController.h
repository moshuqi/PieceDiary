//
//  PDImagePickerController.h
//  PieceDiary
//
//  Created by moshuqi on 15/9/22.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PDImagePickerControllerDelegate <NSObject>

- (void)pickFinishedWithPhotos:(NSArray *)photos;

@end

@interface PDImagePickerController : UIViewController

@property (nonatomic, assign) id<PDImagePickerControllerDelegate> delegate;

@end
