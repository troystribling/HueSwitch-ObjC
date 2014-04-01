//
//  HueSwitchStatusViewController.h
//  HueSwitch
//
//  Created by Troy Stribling on 3/1/14.
//  Copyright (c) 2014 gnos.us. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HueSwitchStatusViewController : UIViewController

@property(nonatomic, retain) IBOutlet UIImageView*  connectionStatusImageView;
@property(nonatomic, retain) IBOutlet UIImageView*  switchImageView;
@property(nonatomic, retain) IBOutlet UIButton*     connectionStatusButton;
@property(nonatomic, retain) IBOutlet UIButton*     switchButton;

- (void)peripheralDiscoveryComplete:(NSNotification*)notification;

@end
