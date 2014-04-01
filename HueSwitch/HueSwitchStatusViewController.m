//
//  HueSwitchStatusViewController.m
//  HueSwitch
//
//  Created by Troy Stribling on 3/1/14.
//  Copyright (c) 2014 gnos.us. All rights reserved.
//

#import <BlueCap/BlueCap.h>
#import "HueSwitchProfile.h"
#import "HueSwitchStatusViewController.h"
#import "UIAlertView+Extensions.h"

@interface HueSwitchStatusViewController ()

@property(nonatomic, retain) BlueCapPeripheral*         connectedPeripheral;
@property(nonatomic, retain) BlueCapService*            hueLightsService;
@property(nonatomic, retain) BlueCapCharacteristic*     switchCharacteristic;
@property(nonatomic, retain) BlueCapCharacteristic*     statusCharacteristic;

- (void)startNotifications;
- (void)updateStatus;

@end

@implementation HueSwitchStatusViewController

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.connectedPeripheral = nil;
        self.switchCharacteristic = nil;
        self.statusCharacteristic = nil;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateStatus];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(connectedPeripheral))]) {
        if ([[change objectForKey:NSKeyValueChangeKindKey] integerValue] == NSKeyValueChangeSetting) {
            DLog(@"HueSwitchStatusViewController: %@ updated: %@", keyPath, change);
            self.connectedPeripheral = [change objectForKey:NSKeyValueChangeNewKey];
        }
    }
}

- (void)peripheralDiscoveryComplete:(NSNotification*)notification {
    if ([[notification name] isEqualToString:@"HueLightsServicelDiscoveryComplete"]) {
        DLog(@"HueSwitchStatusViewController: Hue Lights Service Discovery Complete");
        self.hueLightsService = [self.connectedPeripheral serviceWithUUID:HUE_LIGHTS_SERVICE_UUID];
        self.switchCharacteristic = [self.hueLightsService characteristicWithUUID:HUE_LIGHTS_SWITCH_CHARACTERISTIC_UUID];
        self.statusCharacteristic = [self.hueLightsService characteristicWithUUID:HUE_LIGHTS_STATUS_CHARACTERISTIC_UUID];
        [self startNotifications];
        [self updateStatus];
    }
}

#pragma mark - Private -

- (void)startNotifications {
    [self.switchCharacteristic startNotifications:^{
        [self.switchCharacteristic receiveUpdates:^(BlueCapCharacteristic* ucharacteristic, NSError* error) {
            if (error) {
                [UIAlertView alertOnError:error];
            } else {
                [self updateStatus];
            }
        }];
    }];
    [self.statusCharacteristic startNotifications:^ {
        [self.statusCharacteristic receiveUpdates:^(BlueCapCharacteristic* ucharacteristic, NSError* error) {
            if (error) {
                [UIAlertView alertOnError:error];
            } else {
                [self updateStatus];
            }
        }];
    }];
}

- (void)updateStatus {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.switchCharacteristic) {
            [self.switchCharacteristic readData:^(BlueCapCharacteristic* characteristoc, NSError* error) {
                DLog(@"Switch value: %@", [self.switchCharacteristic stringValue]);
            }];
        }
        if (self.statusCharacteristic) {
            [self.statusCharacteristic readData:^(BlueCapCharacteristic* characteristoc, NSError* error) {
                DLog(@"Status value: %@", [self.statusCharacteristic stringValue]);
            }];
        }
    });
}

@end
