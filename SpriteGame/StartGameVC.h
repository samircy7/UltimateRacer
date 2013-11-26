//
//  StartGameVC.h
//  UltimateRacer
//
//  Created by Samir Choudhary on 11/9/13.
//  Copyright (c) 2013 Samir Choudhary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface StartGameVC : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *codeLabel;
- (IBAction)goBack:(id)sender;
- (void) stopMusic;
@property (strong, nonatomic) IBOutlet UIImageView *correctImg;

@end
