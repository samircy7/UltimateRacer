//
//  JoinGameVC.h
//  UltimateRacer
//
//  Created by Samir Choudhary on 11/9/13.
//  Copyright (c) 2013 Samir Choudhary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface JoinGameVC : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFields;
@property (nonatomic, retain) AVAudioPlayer *player;

@property (strong, nonatomic) IBOutlet UIImageView *correctImg;
@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) IBOutlet UIImageView *wrongImg;
- (id) initWithSoundFile:(AVAudioPlayer *)player;
- (IBAction)back:(id)sender;

- (void) stopMusic;
@end
