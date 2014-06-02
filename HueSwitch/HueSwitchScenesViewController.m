//
//  HueSwitchScenesViewController.m
//  HueSwitch
//
//  Created by Troy Stribling on 3/1/14.
//  Copyright (c) 2014 gnos.us. All rights reserved.
//

#import <BlueCap/BlueCap.h>
#import "HueSwitchScenesViewController.h"
#import "HueSwitchProfile.h"
#import "HueSwitchConfig.h"
#import "UIAlertView+Extensions.h"

@interface HueSwitchScenesViewController ()

@property(nonatomic, retain) BlueCapService*            hueLightsService;
@property(nonatomic, retain) BlueCapCharacteristic*     lightCountCharacteristic;
@property(nonatomic, retain) BlueCapCharacteristic*     sceneCountCharacteristic;

- (void)updateLightCount;
- (void)updateSceneCount;
- (void)updateScenes;

@end

@implementation HueSwitchScenesViewController

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

#pragma mark - Notifications -

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(connectedPeripheral))]) {
        if ([[change objectForKey:NSKeyValueChangeKindKey] integerValue] == NSKeyValueChangeSetting)
            DLog(@"HueSwitchScenesViewController: %@ updated: %@", keyPath, change);
        self.connectedPeripheral = [change objectForKey:NSKeyValueChangeNewKey];
    }
}

- (void)peripheralDiscoveryComplete:(NSNotification*)notification {
    if ([[notification name] isEqualToString:@"HueLightsServicelDiscoveryComplete"]) {
        DLog(@"HueSwitchScenesViewController: Hue Lights Service Discovery Complete");
        self.hueLightsService = [self.connectedPeripheral serviceWithUUID:HUE_LIGHTS_SERVICE_UUID];
        self.lightCountCharacteristic = [self.hueLightsService characteristicWithUUID:HUE_LIGHTS_LIGHTS_COUNT_CHARACTERISTIC_UUID];
        self.sceneCountCharacteristic = [self.hueLightsService characteristicWithUUID:HUE_LIGHTS_SCENES_COUNT_CHARACTERISTIC_UUID];
        [self updateLightCount];
    }
}

#pragma mark - Private - 

- (void)updateLightCount {
    [self.lightCountCharacteristic readData:^(BlueCapCharacteristic* characteristic, NSError* error) {
        if (error) {
            [UIAlertView alertOnError:error];
        } else {
            NSInteger lightCount = [[[self.lightCountCharacteristic value] objectForKey:HUE_LIGHTS_LIGHTS_COUNT] integerValue];
            [HueSwitchConfig setLightCount:lightCount];
            [self updateSceneCount];
        }
    }];
}

- (void)updateSceneCount {
    [self.sceneCountCharacteristic readData:^(BlueCapCharacteristic* characteristic, NSError* error) {
        if (error) {
            [UIAlertView alertOnError:error];
        } else {
            NSInteger sceneCount = [[[self.sceneCountCharacteristic value] objectForKey:HUE_LIGHTS_SCENES_COUNT] integerValue];
            [HueSwitchConfig setSceneCount:sceneCount];
        }
    }];
}

- (void)updateScenes {    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [HueSwitchConfig getSceneCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"HueSwitchSceneCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    return cell;
}

@end
