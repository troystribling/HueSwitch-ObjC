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
#import "HueSwitchLocationViewController.h"
#import "HueSwitchAdminViewController.h"
#import "HueSwitchConfig.h"

#define RECONNECT_DELAY                 5.0f
#define SCAN_TIMEOUT                    30.0f

@interface HueSwitchViewController ()

@property(nonatomic, strong) UIPageViewController*          pageViewController;
@property(nonatomic, retain) BlueCapPeripheral*             connectedPeripheral;
@property(nonatomic, assign) BOOL                           scanning;
@property(nonatomic, retain) NSArray*                       pages;
@property(nonatomic, retain) HueSwitchAdminViewController*  adminViewController;
@property(nonatomic, assign) NSInteger                      connectionStatus;

- (void)addViews;
- (void)addPageView;
- (void)powerOn;
- (void)startScanning;
- (void)stopScanning;

- (void)connectPeripheral:(BlueCapPeripheral*)peripheral;
- (void)getServices:(BlueCapPeripheral*)peripheral;
- (void)getCharacteristics:(BlueCapService*)service;

- (void)bond:(BlueCapPeripheral*)peripheral;

- (void)timeoutBondedScan;
- (void)postPeripheralDisconnectedNotifications;
- (void)postDiscoveryCompleteNotifications:(BlueCapService*)service;
@end

@implementation HueSwitchViewController

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.connectedPeripheral = nil;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addViews];
    [self addPageView];
    [self powerOn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Initialization -

- (void)addViews {
    NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
    
    HueSwitchStatusViewController* statusController = [self.storyboard instantiateViewControllerWithIdentifier:@"HueSwitchStatusViewController"];
    [self addObserver:statusController forKeyPath:NSStringFromSelector(@selector(connectedPeripheral)) options:NSKeyValueObservingOptionNew context:nil];
    [notificationCenter addObserver:statusController selector:@selector(peripheralDiscoveryComplete:) name:@"HueLightsServicelDiscoveryComplete" object:self];
    [notificationCenter addObserver:statusController selector:@selector(peripheralDisconnected:) name:@"PeripheralDisconnected" object:self];
    
    HueSwitchScenesViewController* scenesController = [self.storyboard instantiateViewControllerWithIdentifier:@"HueSwitchScenesViewController"];
    [self addObserver:scenesController forKeyPath:NSStringFromSelector(@selector(connectedPeripheral)) options:NSKeyValueObservingOptionNew context:nil];
    [notificationCenter addObserver:scenesController selector:@selector(peripheralDiscoveryComplete:) name:@"HueLightsServicelDiscoveryComplete" object:self];
    
    HueSwitchLocationViewController* locationsController = [self.storyboard instantiateViewControllerWithIdentifier:@"HueSwitchLocationViewController"];
    [self addObserver:locationsController forKeyPath:NSStringFromSelector(@selector(connectedPeripheral)) options:NSKeyValueObservingOptionNew context:nil];
    [notificationCenter addObserver:locationsController selector:@selector(peripheralDiscoveryComplete:) name:@"GnosusLocationDiscoveryComplete" object:self];
    
    self.pages = @[statusController, scenesController, locationsController];
    
    self.adminViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HueSwitchAdminViewController"];
    [self addObserver:self.adminViewController forKeyPath:NSStringFromSelector(@selector(connectedPeripheral)) options:NSKeyValueObservingOptionNew context:nil];
    [notificationCenter addObserver:self.adminViewController selector:@selector(peripheralDiscoveryComplete:) name:@"HueLightsServicelDiscoveryComplete" object:self];
}

- (void)addPageView {
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    [self.pageViewController setViewControllers:@[[self.pages objectAtIndex:0]]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:YES
                                     completion:nil];
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

#pragma mark - Communications - 

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
    if ([HueSwitchConfig getBonded]) {
        [self timeoutBondedScan];
        [central startScanningForPeripheralsWithServiceUUIDs:@[[CBUUID UUIDWithString:HUE_LIGHTS_SERVICE_UUID]]
                                              afterDiscovery:^(BlueCapPeripheral* cperipheral, NSNumber* RSSI) {
                                                  self.connectedPeripheral = cperipheral;
                                                  [self connectPeripheral:cperipheral];
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

// bonded connection
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
            [self postPeripheralDisconnectedNotifications];
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
        [self postDiscoveryCompleteNotifications:service];
    }];
}

// bond connection
- (void)bond:(BlueCapPeripheral*)peripheral {
    [peripheral connect:^(BlueCapPeripheral* cperipheral, NSError* error) {
            if (error) {
                DLog(@"Connection error: %@", error);
                [self startScanning];
            } else {
                [cperipheral discoverAllServicesAndCharacteristics:^(BlueCapPeripheral* dperipheral, NSError* error) {
                    if (!error) {
                        if ([dperipheral serviceWithUUID:HUE_LIGHTS_SERVICE_UUID]) {
                            self.connectedPeripheral = dperipheral;
                            [HueSwitchConfig setBonded:YES];
                            [self stopScanning];
                            for (BlueCapService* service in [dperipheral services]) {
                                [self postDiscoveryCompleteNotifications:service];
                            }
                        }
                    }
                }];
            }
        } afterPeripheralDisconnect:^(BlueCapPeripheral* dperipheral) {
            DLog(@"Disconnected attempting reconnect");
            [self postPeripheralDisconnectedNotifications];
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(RECONNECT_DELAY * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^{
                [self bond:dperipheral];
            });
        
        }
     ];
}

// connection utils
- (void)timeoutBondedScan {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(SCAN_TIMEOUT * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        if (self.scanning) {
            DLog(@"Timeout scan");
            [self stopScanning];
            [HueSwitchConfig setBonded:NO];
            [self startScanning];
        }
    });
}

- (void)postPeripheralDisconnectedNotifications {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PeripheralDisconnected" object:self];
}

- (void)postDiscoveryCompleteNotifications:(BlueCapService*)service {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[service.UUID stringValue] isEqualToString:HUE_LIGHTS_SERVICE_UUID]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HueLightsServicelDiscoveryComplete" object:self];
        } else if ([[service.UUID stringValue] isEqualToString:GNOSUS_LOCATION_SERVICE_UUID]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GnosusLocationDiscoveryComplete" object:self];
        } else if ([[service.UUID stringValue] isEqualToString:GNOSUS_EPOC_TIME_SERVICE_UUID]) {
            DLog(@"GNOSUS_EPOC_TIME_SERVICE_UUID DiscoveryComplete");
        }
    });
}

#pragma mark - UIPageViewControllerDataSource -

- (UIViewController*)pageViewController:(UIPageViewController*)pageViewController viewControllerAfterViewController:(UIViewController*)viewController {
    if ([viewController isKindOfClass:[HueSwitchStatusViewController class]]) {
        HueSwitchScenesViewController* nextViewController = [self.pages objectAtIndex:1];
        nextViewController.connectedPeripheral = self.connectedPeripheral;
        return nextViewController;
    } else if ([viewController isKindOfClass:[HueSwitchScenesViewController class]]) {
        HueSwitchLocationViewController* nextViewController = [self.pages objectAtIndex:2];
        nextViewController.connectedPeripheral = self.connectedPeripheral;
        return nextViewController;
    } else if ([viewController isKindOfClass:[HueSwitchLocationViewController class]]) {
        HueSwitchStatusViewController* nextViewController = [self.pages objectAtIndex:0];
        nextViewController.connectedPeripheral = self.connectedPeripheral;
        return nextViewController;
    } else {
        return nil;
    }
}

- (UIViewController*)pageViewController:(UIPageViewController*)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[HueSwitchStatusViewController class]]) {
        HueSwitchLocationViewController* nextViewController = [self.pages objectAtIndex:2];
        nextViewController.connectedPeripheral = self.connectedPeripheral;
        return nextViewController;
    } else if ([viewController isKindOfClass:[HueSwitchScenesViewController class]]) {
        HueSwitchStatusViewController* nextViewController = [self.pages objectAtIndex:0];
        nextViewController.connectedPeripheral = self.connectedPeripheral;
        return nextViewController;
    } else if ([viewController isKindOfClass:[HueSwitchLocationViewController class]]) {
        HueSwitchStatusViewController* nextViewController = [self.pages objectAtIndex:1];
        nextViewController.connectedPeripheral = self.connectedPeripheral;
        return nextViewController;
    } else {
        return nil;
    }
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController*)pageViewController {
    return 3;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController*)pageViewController {
    return 0;
}

#pragma - UIPageViewControllerDelegate -


@end
