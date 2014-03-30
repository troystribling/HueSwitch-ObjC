//
//  HueSwitchViewController.m
//  HueSwitch
//
//  Created by Troy Stribling on 3/1/14.
//  Copyright (c) 2014 gnos.us. All rights reserved.
//

#import <BlueCap/BlueCap.h>
#import "HueSwitchProfile.h"
#import "HueSwitchViewController.h"
#import "HueSwitchStatusViewController.h"
#import "HueSwitchScenesViewController.h"
#import "HueSwitchConfigureLocationViewController.h"

#define RECONNECT_DELAY                 5.0f
#define SCAN_TIMEOUT                    10.0f

@interface HueSwitchViewController ()

@property(nonatomic, strong) UIPageViewController*  pageViewController;
@property(nonatomic, assign) BOOL                   scanning;

- (void)powerOn;
- (void)startScanning;
- (void)stopScanning;
- (void)connectPeripheral:(BlueCapPeripheral*)peripheral;
- (void)getServices:(BlueCapPeripheral*)peripheral;
- (void)getCharacteristics:(BlueCapService*)service;
- (void)setBonded:(BOOL)bonded;
- (BOOL)bonded;
- (void)bond:(BlueCapPeripheral*)peripheral;
- (void)timeoutBondedScan;

@end

@implementation HueSwitchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    [self.pageViewController setViewControllers:@[[self.storyboard instantiateViewControllerWithIdentifier:@"HueSwitchStatusViewController"]]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:YES
                                     completion:nil];
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    [self powerOn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private -

- (void)powerOn {
    BlueCapCentralManager* central = [BlueCapCentralManager sharedInstance];
    if (!central.isScanning) {
        [central powerOn:^{
            [self startScanning];
        } afterPowerOff:^{
        }];
    }
}

- (void)startScanning {
    self.scanning = YES;
    BlueCapCentralManager* central = [BlueCapCentralManager sharedInstance];
    if ([self bonded]) {
        [self timeoutBondedScan];
        [central startScanningForPeripheralsWithServiceUUIDs:@[[CBUUID UUIDWithString:HUE_LIGHTS_SERVICE_UUID]]
                                              afterDiscovery:^(BlueCapPeripheral* peripheral, NSNumber* RSSI) {
                                                  [self connectPeripheral:peripheral];
                                                  [self stopScanning];
                                              }
         ];
    } else {
        [central startScanning:^(BlueCapPeripheral* peripheral, NSNumber* RSSI) {
            [self bond:peripheral];
        }];
    }
}

- (void)stopScanning {
    self.scanning = NO;
    BlueCapCentralManager* central = [BlueCapCentralManager sharedInstance];
    [central stopScanning];
}

- (void)connectPeripheral:(BlueCapPeripheral*)peripheral {
    [peripheral connect:^(BlueCapPeripheral* cperipheral, NSError* error) {
            if (error) {
                DLog(@"Connection error: %@", error);
                [self startScanning];
            } else {
                [self getServices:cperipheral];
            }
        } afterPeripheralDisconnect:^(BlueCapPeripheral* dperipheral) {
            DLog(@"Disconnected attempting reconnect");
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(RECONNECT_DELAY * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^{
                [self connectPeripheral:dperipheral];
            });

        }
     ];
}

- (void)getServices:(BlueCapPeripheral*)peripheral {
    NSArray* servicesToDiscover = @[[CBUUID UUIDWithString:HUE_LIGHTS_SERVICE_UUID],
                                    [CBUUID UUIDWithString:GNOSUS_EPOC_TIME_SERVICE_UUID],
                                    [CBUUID UUIDWithString:GNOSUS_LOCATION_SERVICE_UUID]];
    [peripheral discoverServices:servicesToDiscover afterDiscovery:^(NSArray* services) {
        for (BlueCapService* service in services) {
            [self getCharacteristics:service];
        }
    }];
}

- (void)getCharacteristics:(BlueCapService*)service {
    [service discoverAllCharacteritics:^(NSArray* characteristics) {
        for (BlueCapCharacteristic* characteristic in characteristics) {
            [characteristic readData:^(BlueCapCharacteristic* __characteristic, NSError* error) {
                DLog(@"Characteristic:%@, Value: %@", __characteristic.profile.name, [__characteristic stringValue]);
            }];
        }
    }];
}

- (void)setBonded:(BOOL)bonded {
    NSUserDefaults* standardDefaults = [NSUserDefaults standardUserDefaults];
    [standardDefaults setBool:bonded forKey:@"bonded"];
}

- (BOOL)bonded {
    NSUserDefaults* standardDefaults = [NSUserDefaults standardUserDefaults];
    return [standardDefaults boolForKey:@"bonded"];
}

- (void)bond:(BlueCapPeripheral*)peripheral {
    [peripheral connect:^(BlueCapPeripheral* cperipheral, NSError* error) {
            if (error) {
                DLog(@"Connection error: %@", error);
                [self startScanning];
            } else {
                [cperipheral discoverAllServicesAndCharacteristics:^(BlueCapPeripheral* dperipheral, NSError* error) {
                    if (!error) {
                        if ([dperipheral serviceWithUUID:HUE_LIGHTS_SERVICE_UUID]) {
                            [self setBonded:YES];
                            [self stopScanning];
                        }
                    }
                }];
            }
        } afterPeripheralDisconnect:^(BlueCapPeripheral* dperipheral) {
            DLog(@"Disconnected attempting reconnect");
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(RECONNECT_DELAY * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^{
                [self bond:dperipheral];
            });
        
        }
     ];
}

- (void)timeoutBondedScan {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(SCAN_TIMEOUT * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        if (self.scanning) {
            DLog(@"Timeout scan");
            [self stopScanning];
            [self setBonded:NO];
            [self startScanning];
        }
    });
}

#pragma mark - UIPageViewControllerDataSource -

- (UIViewController*)pageViewController:(UIPageViewController*)pageViewController viewControllerAfterViewController:(UIViewController*)viewController {
    UIViewController* nextViewController = nil;
    if ([viewController isKindOfClass:[HueSwitchStatusViewController class]]) {
        nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HueSwitchScenesViewController"];
    } else if ([viewController isKindOfClass:[HueSwitchScenesViewController class]]) {
        nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HueSwitchConfigureLocationViewController"];
    } else if ([viewController isKindOfClass:[HueSwitchConfigureLocationViewController class]]) {
        nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HueSwitchStatusViewController"];
    }
    return nextViewController;
}

- (UIViewController*)pageViewController:(UIPageViewController*)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    UIViewController* nextViewController = nil;
    if ([viewController isKindOfClass:[HueSwitchStatusViewController class]]) {
        nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HueSwitchConfigureLocationViewController"];
    } else if ([viewController isKindOfClass:[HueSwitchScenesViewController class]]) {
        nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HueSwitchStatusViewController"];
    } else if ([viewController isKindOfClass:[HueSwitchConfigureLocationViewController class]]) {
        nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HueSwitchScenesViewController"];
    }
    return nextViewController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController*)pageViewController {
    return 3;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController*)pageViewController {
    return 0;
}

#pragma - UIPageViewControllerDelegate -


@end
