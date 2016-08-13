//
//  PDDisplayPhotoViewController.h
//  PieceDiary
//
//  Created by moshuqi on 15/9/22.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PDDisplayPhotoViewControllerDelegate <NSObject>



@end

@interface PDDisplayPhotoViewController : UIViewController

@property (nonatomic, assign) id<PDDisplayPhotoViewControllerDelegate> delegate;

- (id)initWithPhotoDatas:(NSArray *)photoDatas;

@end
