//
//  HueSwitchProfile.m
//  HueSwitch
//
//  Created by Troy Stribling on 3/4/14.
//  Copyright (c) 2014 gnos.us. All rights reserved.
//

#import <BlueCap/BlueCap.h>
#import "HueSwitchProfile.h"

@implementation HueSwitchProfile

+ (void)create {
    
    BlueCapProfileManager* profileManager = [BlueCapProfileManager sharedInstance];
    
#pragma mark - Switch Service -
    
    [profileManager createServiceWithUUID:HUE_LIGHTS_SWITCH_SERVICE_UUID
                                     name:@"Hue Lights Switches"
                               andProfile:^(BlueCapServiceProfile* serviceProfile) {
                                   [serviceProfile createCharacteristicWithUUID:@"2f0a0011-69aa-f316-3e78-4194989a6c1a"
                                                                           name:@"Switch"
                                                                     andProfile:^(BlueCapCharacteristicProfile* characteristicProfile) {
                                                                     }];
                                   [serviceProfile createCharacteristicWithUUID:@"2f0a0019-69aa-f316-3e78-4194989a6c1a"
                                                                           name:@"Sunset Switch"
                                                                     andProfile:^(BlueCapCharacteristicProfile* characteristicProfile) {
                                                                     }];
                                   [serviceProfile createCharacteristicWithUUID:@"2f0a0020-69aa-f316-3e78-4194989a6c1a"
                                                                           name:@"Sunrise Switch"
                                                                     andProfile:^(BlueCapCharacteristicProfile* characteristicProfile) {
                                                                     }];
                               }];
    
#pragma mark - Scenes Service -

    [profileManager createServiceWithUUID:HUE_LIGHTS_SCENES_SERVICE_UUID
                                     name:@"Hue Lights Scenes"
                               andProfile:^(BlueCapServiceProfile* serviceProfile) {
                                   [serviceProfile createCharacteristicWithUUID:@"2f0a0012-69aa-f316-3e78-4194989a6c1a"
                                                                           name:@"Number of Scenes"
                                                                     andProfile:^(BlueCapCharacteristicProfile* characteristicProfile) {
                                                                     }];
                                   [serviceProfile createCharacteristicWithUUID:@"2f0a0013-69aa-f316-3e78-4194989a6c1a"
                                                                           name:@"Scene ID"
                                                                     andProfile:^(BlueCapCharacteristicProfile* characteristicProfile) {
                                                                     }];
                                   [serviceProfile createCharacteristicWithUUID:@"2f0a0014-69aa-f316-3e78-4194989a6c1a"
                                                                           name:@"Scene Name"
                                                                     andProfile:^(BlueCapCharacteristicProfile* characteristicProfile) {
                                                                     }];
                                   [serviceProfile createCharacteristicWithUUID:@"2f0a0015-69aa-f316-3e78-4194989a6c1a"
                                                                           name:@"Current Scene ID"
                                                                     andProfile:^(BlueCapCharacteristicProfile* characteristicProfile) {
                                                                     }];
                                   [serviceProfile createCharacteristicWithUUID:@"2f0a0025-69aa-f316-3e78-4194989a6c1a"
                                                                           name:@"Number of Lights"
                                                                     andProfile:^(BlueCapCharacteristicProfile* characteristicProfile) {
                                                                     }];
                                   [serviceProfile createCharacteristicWithUUID:@"2f0a0022-69aa-f316-3e78-4194989a6c1a"
                                                                           name:@"Light Color"
                                                                     andProfile:^(BlueCapCharacteristicProfile* characteristicProfile) {
                                                                     }];
                                   [serviceProfile createCharacteristicWithUUID:@"2f0a0025-69aa-f316-3e78-4194989a6c1a"
                                                                           name:@"Next Scene"
                                                                     andProfile:^(BlueCapCharacteristicProfile* characteristicProfile) {
                                                                     }];
                                   [serviceProfile createCharacteristicWithUUID:@"2f0a0024-69aa-f316-3e78-4194989a6c1a"
                                                                           name:@"Operation"
                                                                     andProfile:^(BlueCapCharacteristicProfile* characteristicProfile) {
                                                                     }];
                                   [serviceProfile createCharacteristicWithUUID:@"2f0a0026-69aa-f316-3e78-4194989a6c1a"
                                                                           name:@"Next Light"
                                                                     andProfile:^(BlueCapCharacteristicProfile* characteristicProfile) {
                                                                     }];
                               }];

}

@end
