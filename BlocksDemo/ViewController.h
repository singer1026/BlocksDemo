//
//  ViewController.h
//  BlocksDemo
//
//  Created by Singer on 14-6-3.
//  Copyright (c) 2014年 Singer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *ballImage;
@property (weak, nonatomic) IBOutlet UIImageView *paddleImage;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *blockImages;
@end
