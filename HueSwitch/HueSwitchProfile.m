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
    
#pragma mark - Scenes Service -

    [profileManager createServiceWithUUID:HUE_LIGHTS_SERVICE_UUID
                                     name:@"Hue Lights Scenes"
                               andProfile:^(BlueCapServiceProfile* serviceProfile) {
                                   [serviceProfile createCharacteristicWithUUID:@"2f0a0012-69aa-f316-3e78-4194989a6c1a"
                                                                           name:@"Number of Scenes"
                                                                     andProfile:^(BlueCapCharacteristicProfile* characteristicProfile) {
                                                                         characteristicProfile.properties = CBCharacteristicPropertyRead;
                                                                         [characteristicProfile deserializeData:^NSDictionary*(NSData* data) {
                                                                             return @{HUE_LIGHTS_NUMBER_OF_SCENES:blueCapUnsignedCharFromData(data, NSMakeRange(0, 1))};
                                                                         }];
                                                                         [characteristicProfile stringValue:^NSDictionary*(NSDictionary* data) {
                                                                             return @{HUE_LIGHTS_NUMBER_OF_SCENES:[[data objectForKey:HUE_LIGHTS_NUMBER_OF_SCENES] stringValue]};
                                                                         }];
                                                                         [characteristicProfile serializeString:^NSData*(NSDictionary* data) {
                                                                             uint8_t value = [[data objectForKey:HUE_LIGHTS_NUMBER_OF_SCENES] intValue];
                                                                             return blueCapUnsignedCharToData(value);
                                                                         }];
                                                                         characteristicProfile.initialValue = [characteristicProfile valueFromString:@{HUE_LIGHTS_NUMBER_OF_SCENES:[NSString stringWithFormat:@"%d", 10]}];
                                                                     }];
                                   [serviceProfile createCharacteristicWithUUID:@"2f0a0013-69aa-f316-3e78-4194989a6c1a"
                                                                           name:@"Scene ID"
                                                                     andProfile:^(BlueCapCharacteristicProfile* characteristicProfile) {
                                                                         characteristicProfile.properties = CBCharacteristicPropertyRead | CBCharacteristicPropertyWrite;
                                                                         [characteristicProfile serializeObject:^NSData*(id data) {
                                                                             uint8_t value = [data intValue];
                                                                             return blueCapUnsignedCharToData(value);
                                                                         }];
                                                                         [characteristicProfile deserializeData:^NSDictionary*(NSData* data) {
                                                                             return @{HUE_LIGHTS_SCENE_ID:blueCapUnsignedCharFromData(data, NSMakeRange(0, 1))};
                                                                         }];
                                                                         [characteristicProfile stringValue:^NSDictionary*(NSDictionary* data) {
                                                                             return @{HUE_LIGHTS_SCENE_ID:[[data objectForKey:HUE_LIGHTS_SCENE_ID] stringValue]};
                                                                         }];
                                                                         [characteristicProfile serializeString:^NSData*(NSDictionary* data) {
                                                                             uint8_t value = [[data objectForKey:HUE_LIGHTS_SCENE_ID] intValue];
                                                                             return blueCapUnsignedCharToData(value);
                                                                         }];
                                                                         characteristicProfile.initialValue = [characteristicProfile valueFromString:@{HUE_LIGHTS_SCENE_ID:[NSString stringWithFormat:@"%d", 1]}];
                                                                     }];
                                   [serviceProfile createCharacteristicWithUUID:@"2f0a0014-69aa-f316-3e78-4194989a6c1a"
                                                                           name:@"Scene Name"
                                                                     andProfile:^(BlueCapCharacteristicProfile* characteristicProfile) {
                                                                         characteristicProfile.properties = CBCharacteristicPropertyRead | CBCharacteristicPropertyWrite;
                                                                         [characteristicProfile serializeObject:^NSData*(id data) {
                                                                             return nil;
                                                                         }];
                                                                         [characteristicProfile afterDiscovered:^(BlueCapCharacteristic* chararacteristic) {
                                                                         }];
                                                                         [characteristicProfile deserializeData:^NSDictionary*(NSData* data) {
                                                                             return @{};
                                                                         }];
                                                                         [characteristicProfile stringValue:^NSDictionary*(NSDictionary* data) {
                                                                             return @{};
                                                                         }];
                                                                         [characteristicProfile serializeString:^NSData*(NSDictionary* data) {
                                                                             return nil;
                                                                         }];
                                                                         characteristicProfile.initialValue = [characteristicProfile valueFromString:@{}];
                                                                     }];
                                   [serviceProfile createCharacteristicWithUUID:@"2f0a0015-69aa-f316-3e78-4194989a6c1a"
                                                                           name:@"Current Scene ID"
                                                                     andProfile:^(BlueCapCharacteristicProfile* characteristicProfile) {
                                                                         characteristicProfile.properties = CBCharacteristicPropertyRead | CBCharacteristicPropertyWrite;
                                                                         [characteristicProfile serializeObject:^NSData*(id data) {
                                                                             return nil;
                                                                         }];
                                                                         [characteristicProfile deserializeData:^NSDictionary*(NSData* data) {
                                                                             return @{};
                                                                         }];
                                                                         [characteristicProfile stringValue:^NSDictionary*(NSDictionary* data) {
                                                                             return @{};
                                                                         }];
                                                                         [characteristicProfile serializeString:^NSData*(NSDictionary* data) {
                                                                             return nil;
                                                                         }];
                                                                         characteristicProfile.initialValue = [characteristicProfile valueFromString:@{}];
                                                                     }];
                                   [serviceProfile createCharacteristicWithUUID:@"2f0a0025-69aa-f316-3e78-4194989a6c1a"
                                                                           name:@"Number of Lights"
                                                                     andProfile:^(BlueCapCharacteristicProfile* characteristicProfile) {
                                                                         characteristicProfile.properties = CBCharacteristicPropertyRead;
                                                                         [characteristicProfile deserializeData:^NSDictionary*(NSData* data) {
                                                                             return @{};
                                                                         }];
                                                                         [characteristicProfile stringValue:^NSDictionary*(NSDictionary* data) {
                                                                             return @{};
                                                                         }];
                                                                         [characteristicProfile serializeString:^NSData*(NSDictionary* data) {
                                                                             return nil;
                                                                         }];
                                                                         characteristicProfile.initialValue = [characteristicProfile valueFromString:@{}];
                                                                     }];
                                   [serviceProfile createCharacteristicWithUUID:@"2f0a0022-69aa-f316-3e78-4194989a6c1a"
                                                                           name:@"Light Color"
                                                                     andProfile:^(BlueCapCharacteristicProfile* characteristicProfile) {
                                                                         characteristicProfile.properties = CBCharacteristicPropertyRead | CBCharacteristicPropertyWrite;
                                                                         [characteristicProfile serializeObject:^NSData*(id data) {
                                                                             return nil;
                                                                         }];
                                                                         [characteristicProfile deserializeData:^NSDictionary*(NSData* data) {
                                                                             return @{};
                                                                         }];
                                                                         [characteristicProfile stringValue:^NSDictionary*(NSDictionary* data) {
                                                                             return @{};
                                                                         }];
                                                                         [characteristicProfile serializeString:^NSData*(NSDictionary* data) {
                                                                             return nil;
                                                                         }];
                                                                         characteristicProfile.initialValue = [characteristicProfile valueFromString:@{}];
                                                                     }];
                                   [serviceProfile createCharacteristicWithUUID:@"2f0a0024-69aa-f316-3e78-4194989a6c1a"
                                                                           name:@"Operation"
                                                                     andProfile:^(BlueCapCharacteristicProfile* characteristicProfile) {
                                                                         characteristicProfile.properties = CBCharacteristicPropertyRead | CBCharacteristicPropertyWrite;
                                                                         [characteristicProfile serializeObject:^NSData*(id data) {
                                                                             return nil;
                                                                         }];
                                                                         [characteristicProfile deserializeData:^NSDictionary*(NSData* data) {
                                                                             return @{};
                                                                         }];
                                                                         [characteristicProfile stringValue:^NSDictionary*(NSDictionary* data) {
                                                                             return @{};
                                                                         }];
                                                                         [characteristicProfile serializeString:^NSData*(NSDictionary* data) {
                                                                             return nil;
                                                                         }];
                                                                         characteristicProfile.initialValue = [characteristicProfile valueFromString:@{}];
                                                                     }];
                                   [serviceProfile createCharacteristicWithUUID:@"2f0a0027-69aa-f316-3e78-4194989a6c1a"
                                                                           name:@"Switches"
                                                                     andProfile:^(BlueCapCharacteristicProfile* characteristicProfile) {
                                                                         characteristicProfile.properties = CBCharacteristicPropertyRead | CBCharacteristicPropertyWrite;
                                                                         [characteristicProfile serializeObject:^NSData*(id data) {
                                                                             return nil;
                                                                         }];
                                                                         [characteristicProfile deserializeData:^NSDictionary*(NSData* data) {
                                                                             return @{};
                                                                         }];
                                                                         [characteristicProfile stringValue:^NSDictionary*(NSDictionary* data) {
                                                                             return @{};
                                                                         }];
                                                                         [characteristicProfile serializeString:^NSData*(NSDictionary* data) {
                                                                             return nil;
                                                                         }];
                                                                         characteristicProfile.initialValue = [characteristicProfile valueFromString:@{}];
                                                                     }];
                               }];

}

@end
