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

- (void)startNotifications:(BlueCapCharacteristic*)characteristic;
- (void)updateStatus:(BlueCapCharacteristic*)characteristic;
- (void)updateDisplay;
- (void)updateSwitchDisplay;
- (void)lightsNotConnected;
- (void)outOfRange;

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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateDisplay];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Notifications -

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
        [self updateStatus:self.switchCharacteristic];
        [self updateStatus:self.statusCharacteristic];
    }
}

- (void)peripheralDisconnected:(NSNotification*)notification {
    if ([[notification name] isEqualToString:@"PeripheralDisconnected"]) {
        DLog(@"PeripheralDisconnected: peripheral disconnected");
        dispatch_async(dispatch_get_main_queue(), ^{
            [self outOfRange];
        });
    }
}

#pragma mark - Private -

- (void)startNotifications:(BlueCapCharacteristic*)characteristic {
    [characteristic startNotifications:^ {
        [self.statusCharacteristic receiveUpdates:^(BlueCapCharacteristic* ucharacteristic, NSError* error) {
            if (error) {
                [self errorAlert:error];
            } else {
                [self updateDisplay];
            }
        }];
    }];
}

- (void)updateStatus:(BlueCapCharacteristic*)characteristic {
    [characteristic readData:^(BlueCapCharacteristic* characteristic, NSError* error) {
        if (error) {
            [self errorAlert:error];
        } else {
            [self startNotifications:characteristic];
            [self updateDisplay];
        }
    }];
}

- (void)updateDisplay {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.statusCharacteristic) {
            DLog(@"Status value: %@", [self.statusCharacteristic stringValue]);
            NSString* value = [[self.statusCharacteristic value] objectForKey:HUE_LIGHTS_STATUS];
            if ([value isEqualToString:HUE_LIGHTS_STATUS_ON_LINE]) {
                [self.connectionStatusButton setTitle:@"On Line" forState:UIControlStateNormal];
                self.connectionStatusImageView.image = [UIImage imageNamed:@"Connect"];
                [self updateSwitchDisplay];
            } else {
                [self lightsNotConnected];
            }
        } else {
            [self outOfRange];
        }
    });
}

- (void)errorAlert:(NSError*)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIAlertView alertOnError:error];
    });
}

- (void)lightsNotConnected {
    [self.connectionStatusButton setTitle:@"Off Line" forState:UIControlStateNormal];
    self.connectionStatusImageView.image = [UIImage imageNamed:@"LightsNotConnected"];
    [self.switchButton setTitle:@"Off Line" forState:UIControlStateNormal];
    self.switchImageView.image = [UIImage imageNamed:@"LightsNotConnected"];
}

- (void)outOfRange {
    [self.connectionStatusButton setTitle:@"Off Line" forState:UIControlStateNormal];
    self.connectionStatusImageView.image = [UIImage imageNamed:@"OutOfRange"];
    [self.switchButton setTitle:@"Off Line" forState:UIControlStateNormal];
    self.switchImageView.image = [UIImage imageNamed:@"OutOfRange"];    
}

- (void)updateSwitchDisplay {
    if (self.switchCharacteristic) {
        DLog(@"Switch value: %@", [self.switchCharacteristic stringValue]);
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
            [self.switchCharacteristic stopNotifications:nil];
            [self updateStatus:self.switchCharacteristic];
        }
    }];
}

@end
