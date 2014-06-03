//
//  ViewController.m
//  BlocksDemo
//
//  Created by Singer on 14-6-3.
//  Copyright (c) 2014年 Singer. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface ViewController ()
{
    BOOL _isPlaying;
    CGPoint _ballVelociy;
    CADisplayLink *_gameTimer;
    CGFloat _deltaX;
}
-(void) step:(CADisplayLink *) sender;

-(BOOL) checkWithScreen;
-(BOOL) checkWithBlocks;

-(void) ckeckWithPaddle;

-(void) resetGameStatusWithMessage:(NSString*) message;

@end



@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)step:(CADisplayLink *)sender{
    if ([self checkWithScreen]) {
        [self resetGameStatusWithMessage:@"再来一次吧"];
    }
    
    if ([self checkWithBlocks]) {
        [self resetGameStatusWithMessage:@"恭喜您获得胜利"];
    }
    
    [self ckeckWithPaddle];
    
    [_ballImage setCenter:CGPointMake(_ballImage.center.x+_ballVelociy.x , _ballImage.center.y + _ballVelociy.y)];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if(!_isPlaying){
       // UITouch *touch=[touches anyObject];
        
        _ballVelociy = CGPointMake(0, -5);
        
        _gameTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(step:)];
        
        [_gameTimer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        
        _isPlaying=YES;
    }else{
        _deltaX = 0;
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if(_isPlaying){
        UITouch *touch=[touches anyObject];
        _deltaX=[touch locationInView:self.view].x - [touch previousLocationInView:self.view].x;
        [_paddleImage setCenter:CGPointMake([_paddleImage center].x + _deltaX, [_paddleImage center].y)];
    }
}

-(void) resetGameStatusWithMessage:(NSString*) message{
    NSLog(@"%@",message);
    [_gameTimer invalidate];

    
    
    for (UIImageView *block in _blockImages) {
        [block setHidden:NO];
        [block setAlpha:0];
        [block setFrame:CGRectMake(block.center.x, block.center.y, 0, 0)];
    }
    
    [UIView animateWithDuration:2.0 animations:^{
        for (UIImageView *block in _blockImages) {
      
            [block setAlpha:1];
            [block setFrame:CGRectMake(block.center.x-32, block.center.y-10, 64, 20)];
        }
    } completion:^(BOOL finished){
        _isPlaying = NO;
        [_ballImage setCenter:CGPointMake(160, 430)];
        [_paddleImage setCenter:CGPointMake(160, 450)];
        
    }];
    
   }

-(BOOL) checkWithScreen{
    BOOL gameOver = NO;
    if([_ballImage frame].origin.x <= 0){
        _ballVelociy.x=abs(_ballVelociy.x);
    }
    
    if ([_ballImage frame].origin.x + [_ballImage frame].size.width >= self.view.frame.size.width) {
        _ballVelociy.x = -1 * abs(_ballVelociy.x);
    }
    
    if ([_ballImage frame].origin.y<=0) {
        _ballVelociy.y = abs(_ballVelociy.y);
    }
    
    if ([_ballImage frame].origin.y+[_ballImage frame].size.height >= self.view.frame.size.height) {
        gameOver = YES;
    }
    
    return gameOver;
}
-(BOOL) checkWithBlocks{
    
    
    for (UIImageView *block in _blockImages) {
        if (CGRectIntersectsRect([block frame], [_ballImage frame]) && block.hidden == NO ) {
            [block setHidden:YES];
            _ballVelociy.y=abs(_ballVelociy.y);
            break;
        }
    }
    BOOL gameWin = YES;
   
    for (UIImageView *block in _blockImages) {
        if (![block isHidden]) {
            gameWin=NO;
            break;
        }
    }
    
    return gameWin;
}

//-(void) ckeckWithPaddle{
//    
//    if (CGRectIntersectsRect([_ballImage frame], [_paddleImage frame])) {
//        _ballVelociy.y = -1 * abs(_ballVelociy.y);
//    }
//}

-(void) ckeckWithPaddle{
    if (CGRectIntersectsRect([_ballImage frame], [_paddleImage frame])) {
        _ballVelociy.y = -1 * abs(_ballVelociy.y);
        _ballVelociy.x+=_deltaX;
    }

}


@end
