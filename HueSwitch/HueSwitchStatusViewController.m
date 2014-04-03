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

@property(nonatomic, retain) BlueCapService*            hueLightsService;
@property(nonatomic, retain) BlueCapCharacteristic*     switchCharacteristic;
@property(nonatomic, retain) BlueCapCharacteristic*     statusCharacteristic;

- (void)startNotifications;
- (void)updateStatus;
- (void)updateDisplay;

- (void)errorAlert:(NSError*)error;

- (IBAction)toggleLight:(id)sender;

@end

@implementation HueSwitchStatusViewController

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.switchCharacteristic = nil;
        self.statusCharacteristic = nil;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateStatus];
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
        self.switchCharacteristic = [self.hueLightsService characteristicWithUUID:HUE_LIGHTS_SWITCH_ALL_LIGHTS_CHARACTERISTIC_UUID];
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
                [self errorAlert:error];
            }
        }];
    }];
    [self.statusCharacteristic startNotifications:^ {
        [self.statusCharacteristic receiveUpdates:^(BlueCapCharacteristic* ucharacteristic, NSError* error) {
            if (error) {
                [self errorAlert:error];
            }
        }];
    }];
}

- (void)updateStatus {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.switchCharacteristic) {
            [self.switchCharacteristic readData:^(BlueCapCharacteristic* characteristic, NSError* error) {
                DLog(@"Switch value: %@", [self.switchCharacteristic stringValue]);
            }];
        }
        if (self.statusCharacteristic) {
            [self.statusCharacteristic readData:^(BlueCapCharacteristic* characteristic, NSError* error) {
                DLog(@"Status value: %@", [self.statusCharacteristic stringValue]);
            }];
        }
        [self updateDisplay];
    });
}

- (void)updateDisplay {
    if (self.switchCharacteristic) {
        NSString* value = [[self.switchCharacteristic value] objectForKey:HUE_LIGHTS_SWITCH_ALL_LIGHTS];
        if ([value isEqualToString:HUE_LIGHTS_SWITCH_ALL_LIGHTS_ON]) {
            [self.switchButton setTitle:@"On" forState:UIControlStateNormal];
            self.switchImageView.image = [UIImage imageNamed:@"Connect"];
        } else {
            [self.switchButton setTitle:@"Off" forState:UIControlStateNormal];
            self.switchImageView.image = [UIImage imageNamed:@"Disconnect"];
        }
    } else {
        [self.switchButton setTitle:@"Off Line" forState:UIControlStateNormal];
        self.switchImageView.image = [UIImage imageNamed:@"OutOfRange"];
    }
    
    if (self.statusCharacteristic) {
        NSString* value = [[self.statusCharacteristic value] objectForKey:HUE_LIGHTS_STATUS];
        if ([value isEqualToString:HUE_LIGHTS_STATUS_ON_LINE]) {
            [self.connectionStatusButton setTitle:@"On Line" forState:UIControlStateNormal];
            self.connectionStatusImageView.image = [UIImage imageNamed:@"Connect"];
        } else {
            [self.connectionStatusButton setTitle:@"Off Line" forState:UIControlStateNormal];
            self.connectionStatusImageView.image = [UIImage imageNamed:@"LightsNotConnected"];
        }
    } else {
        [self.connectionStatusButton setTitle:@"Off Line" forState:UIControlStateNormal];
        self.connectionStatusImageView.image = [UIImage imageNamed:@"OutOfRange"];
    }
}

- (void)errorAlert:(NSError*)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIAlertView alertOnError:error];
    });
}

#pragma mark - Actions -

- (IBAction)toggleLight:(id)sender {
    NSString* value = [[self.switchCharacteristic value] objectForKey:HUE_LIGHTS_SWITCH_ALL_LIGHTS];
    NSString* newValue = HUE_LIGHTS_SWITCH_ALL_LIGHTS_ON;
    if ([value isEqualToString:HUE_LIGHTS_SWITCH_ALL_LIGHTS_ON]) {
        DLog(@"Turn Lights Off");
        newValue = HUE_LIGHTS_SWITCH_ALL_LIGHTS_OFF;
    } else {
        DLog(@"Turn Lights On");
    }
    [self.switchCharacteristic writeValueObject:newValue afterWriteCall:^(BlueCapCharacteristic* characteristic, NSError* error) {
        if (error) {
            [self errorAlert:error];
        } else {
            [self updateStatus];
        }
    }];
}

@end
