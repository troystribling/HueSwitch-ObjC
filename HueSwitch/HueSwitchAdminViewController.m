//
//  HueSwitchAdminViewController.m
//  HueSwitch
//
//  Created by Troy Stribling on 3/2/14.
//  Copyright (c) 2014 gnos.us. All rights reserved.
//

#import <BlueCap/BlueCap.h>
#import "HueSwitchAdminViewController.h"

@interface HueSwitchAdminViewController ()

@property(nonatomic, retain) BlueCapPeripheral* connectedPeripheral;

@end

@implementation HueSwitchAdminViewController

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.connectedPeripheral = nil;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(connectedPeripheral))]) {
        if ([[change objectForKey:NSKeyValueChangeKindKey] integerValue] == NSKeyValueChangeSetting)
            DLog(@"HueSwitchAdminViewController: %@ updated: %@", keyPath, change);
        self.connectedPeripheral = [change objectForKey:NSKeyValueChangeNewKey];
    }
}

@end
