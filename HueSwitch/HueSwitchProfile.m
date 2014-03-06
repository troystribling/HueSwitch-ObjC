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
                                   
                                   // number of configured scenes
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
                                   
                                   // displayed scene ID
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
                                   
                                   // displayed scene name
                                   [serviceProfile createCharacteristicWithUUID:@"2f0a0014-69aa-f316-3e78-4194989a6c1a"
                                                                           name:@"Scene Name"
                                                                     andProfile:^(BlueCapCharacteristicProfile* characteristicProfile) {
                                                                         characteristicProfile.properties = CBCharacteristicPropertyRead | CBCharacteristicPropertyWrite;
                                                                         [characteristicProfile deserializeData:^NSDictionary*(NSData* data) {
                                                                             return @{HUE_LIGHTS_SCENE_NAME:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]};
                                                                         }];
                                                                         [characteristicProfile stringValue:^NSDictionary*(NSDictionary* data) {
                                                                             return data;
                                                                         }];
                                                                         [characteristicProfile serializeString:^NSData*(NSDictionary* data) {
                                                                             return [[data objectForKey:GNOSUS_HELLO_WORLD_GREETING] dataUsingEncoding:NSUTF8StringEncoding];
                                                                         }];
                                                                         characteristicProfile.initialValue = [@"A Scene" dataUsingEncoding:NSUTF8StringEncoding];
                                                                     }];
                                   
                                   // currently configured scene ID
                                   [serviceProfile createCharacteristicWithUUID:@"2f0a0015-69aa-f316-3e78-4194989a6c1a"
                                                                           name:@"Current Scene ID"
                                                                     andProfile:^(BlueCapCharacteristicProfile* characteristicProfile) {
                                                                         characteristicProfile.properties = CBCharacteristicPropertyRead | CBCharacteristicPropertyWrite;
                                                                         [characteristicProfile serializeObject:^NSData*(id data) {
                                                                             uint8_t value = [data intValue];
                                                                             return blueCapUnsignedCharToData(value);
                                                                         }];
                                                                         [characteristicProfile deserializeData:^NSDictionary*(NSData* data) {
                                                                             return @{HUE_LIGHTS_CURRENT_SCENE_ID:blueCapUnsignedCharFromData(data, NSMakeRange(0, 1))};
                                                                         }];
                                                                         [characteristicProfile stringValue:^NSDictionary*(NSDictionary* data) {
                                                                             return @{HUE_LIGHTS_CURRENT_SCENE_ID:[[data objectForKey:HUE_LIGHTS_CURRENT_SCENE_ID] stringValue]};
                                                                         }];
                                                                         [characteristicProfile serializeString:^NSData*(NSDictionary* data) {
                                                                             uint8_t value = [[data objectForKey:HUE_LIGHTS_CURRENT_SCENE_ID] intValue];
                                                                             return blueCapUnsignedCharToData(value);
                                                                         }];
                                                                         characteristicProfile.initialValue = [characteristicProfile valueFromString:@{HUE_LIGHTS_SCENE_ID:[NSString stringWithFormat:@"%d", 1]}];
                                                                     }];
                                   
                                   // number of lights
                                   [serviceProfile createCharacteristicWithUUID:@"2f0a0025-69aa-f316-3e78-4194989a6c1a"
                                                                           name:@"Number of Lights"
                                                                     andProfile:^(BlueCapCharacteristicProfile* characteristicProfile) {
                                                                         characteristicProfile.properties = CBCharacteristicPropertyRead;
                                                                         [characteristicProfile deserializeData:^NSDictionary*(NSData* data) {
                                                                             return @{HUE_LIGHTS_NUMBER_OF_LIGHTS:blueCapUnsignedCharFromData(data, NSMakeRange(0, 1))};
                                                                         }];
                                                                         [characteristicProfile stringValue:^NSDictionary*(NSDictionary* data) {
                                                                             return @{HUE_LIGHTS_NUMBER_OF_LIGHTS:[[data objectForKey:HUE_LIGHTS_NUMBER_OF_LIGHTS] stringValue]};
                                                                         }];
                                                                         [characteristicProfile serializeString:^NSData*(NSDictionary* data) {
                                                                             uint8_t value = [[data objectForKey:HUE_LIGHTS_CURRENT_SCENE_ID] intValue];
                                                                             return blueCapUnsignedCharToData(value);
                                                                         }];
                                                                         characteristicProfile.initialValue = [characteristicProfile valueFromString:@{HUE_LIGHTS_SCENE_ID:[NSString stringWithFormat:@"%d", 1]}];
                                                                     }];
                                   
                                   // displayed light color for displayed scene
                                   [serviceProfile createCharacteristicWithUUID:@"2f0a0022-69aa-f316-3e78-4194989a6c1a"
                                                                           name:@"Light Color"
                                                                     andProfile:^(BlueCapCharacteristicProfile* characteristicProfile) {
                                                                         characteristicProfile.properties = CBCharacteristicPropertyRead | CBCharacteristicPropertyWrite;
                                                                         [characteristicProfile serializeObject:^NSData*(id data) {
                                                                             uint8_t byteVals[3];
                                                                             byteVals[0] = [[data objectForKey:HUE_LIGHTS_LIGHT_ID] unsignedCharValue];
                                                                             byteVals[1] = [[data objectForKey:HUE_LIGHTS_LIGHT_COLOR_BRIGHTNESS] unsignedCharValue];
                                                                             byteVals[2] = [[data objectForKey:HUE_LIGHTS_LIGHT_COLOR_SATUARTION] unsignedCharValue];
                                                                             NSMutableData* allData = [blueCapUnsignedCharArrayToData(byteVals, 3) mutableCopy];
                                                                             [allData appendData:blueCapBigFromUnsignedInt16([[data objectForKey:HUE_LIGHTS_LIGHT_COLOR_HUE] unsignedShortValue])];
                                                                             return allData;
                                                                         }];
                                                                         [characteristicProfile deserializeData:^NSDictionary*(NSData* data) {
                                                                             return @{HUE_LIGHTS_LIGHT_ID:blueCapUnsignedCharFromData(data, NSMakeRange(0, 1)),
                                                                                      HUE_LIGHTS_LIGHT_COLOR_BRIGHTNESS:blueCapUnsignedCharFromData(data, NSMakeRange(1, 1)),
                                                                                      HUE_LIGHTS_LIGHT_COLOR_SATUARTION:blueCapUnsignedCharFromData(data, NSMakeRange(2, 1)),
                                                                                      HUE_LIGHTS_LIGHT_COLOR_HUE:blueCapUnsignedInt16BigFromData(data, NSMakeRange(3, 2))};
                                                                         }];
                                                                         [characteristicProfile stringValue:^NSDictionary*(NSDictionary* data) {
                                                                             return @{};
                                                                         }];
                                                                         [characteristicProfile serializeString:^NSData*(NSDictionary* data) {
                                                                             return nil;
                                                                         }];
                                                                         characteristicProfile.initialValue = [characteristicProfile valueFromString:@{}];
                                                                     }];
                                   
                                   // apply commands
                                   [serviceProfile createCharacteristicWithUUID:@"2f0a0024-69aa-f316-3e78-4194989a6c1a"
                                                                            name:@"Command"
                                                                      andProfile:^(BlueCapCharacteristicProfile* characteristicProfile) {
                                                                          characteristicProfile.properties = CBCharacteristicPropertyRead | CBCharacteristicPropertyWrite;
                                                                          [characteristicProfile setValue:blueCapUnsignedCharToData(HUE_LIGHTS_COMMAND_ADD_SCENE_VALUE)     named:HUE_LIGHTS_COMMAND_ADD_SCENE];
                                                                          [characteristicProfile setValue:blueCapUnsignedCharToData(HUE_LIGHTS_COMMAND_REMOVE_SCENE_VALUE)  named:HUE_LIGHTS_COMMAND_REMOVE_SCENE];
                                                                          [characteristicProfile setValue:blueCapUnsignedCharToData(HUE_LIGHTS_COMMAND_NEXT_SCENE_VALUE)    named:HUE_LIGHTS_COMMAND_NEXT_SCENE];
                                                                          [characteristicProfile setValue:blueCapUnsignedCharToData(HUE_LIGHTS_COMMAND_NEXT_LIGHT_VALUE)    named:HUE_LIGHTS_COMMAND_NEXT_LIGHT];
                                                                          [characteristicProfile setValue:blueCapUnsignedCharToData(HUE_LIGHTS_COMMAND_ADD_BOND_VALUE)      named:HUE_LIGHTS_COMMAND_ADD_BOND];
                                                                          [characteristicProfile setValue:blueCapUnsignedCharToData(HUE_LIGHTS_COMMAND_CLEAR_BONDS_VALUE)   named:HUE_LIGHTS_COMMAND_CLEAR_BONDS];
                                                                          characteristicProfile.initialValue = [characteristicProfile valueFromNamedObject:HUE_LIGHTS_COMMAND_ADD_SCENE];
                                                                     }];
                                   
                                   // configure switches
                                   [serviceProfile createCharacteristicWithUUID:@"2f0a0027-69aa-f316-3e78-4194989a6c1a"
                                                                           name:@"Switches"
                                                                     andProfile:^(BlueCapCharacteristicProfile* characteristicProfile) {
                                                                         characteristicProfile.properties = CBCharacteristicPropertyRead | CBCharacteristicPropertyWrite;
                                                                         [characteristicProfile serializeObject:^NSData*(id data) {
                                                                             uint8_t values = 0x0;
                                                                             uint8_t allLights  = [[data objectForKey:HUE_LIGHTS_SWITCH_ALL_LIGHTS] intValue];
                                                                             uint8_t sunrise    = [[data objectForKey:HUE_LIGHTS_SWITCH_SUNRISE] intValue];
                                                                             uint8_t sunset     = [[data objectForKey:HUE_LIGHTS_SWITCH_SUNSET] intValue];
                                                                             values = (allLights << 0) | (sunrise << 1) | (sunset << 2);
                                                                             return blueCapUnsignedCharToData(values);
                                                                         }];
                                                                         [characteristicProfile deserializeData:^NSDictionary*(NSData* data) {
                                                                             uint8_t values = [blueCapUnsignedCharFromData(data, NSMakeRange(0, 1)) unsignedCharValue];
                                                                             uint8_t allLights  = values & (1 << 0);
                                                                             uint8_t sunrise    = values & (1 << 1);
                                                                             uint8_t sunset     = values & (1 << 2);
                                                                             return @{HUE_LIGHTS_SWITCH_ALL_LIGHTS:[NSNumber numberWithUnsignedChar:allLights],
                                                                                      HUE_LIGHTS_SWITCH_SUNRISE:[NSNumber numberWithUnsignedChar:sunrise],
                                                                                      HUE_LIGHTS_SWITCH_SUNSET:[NSNumber numberWithUnsignedChar:sunset]};
                                                                         }];
                                                                         [characteristicProfile stringValue:^NSDictionary*(NSDictionary* data) {
                                                                             NSMutableDictionary* results = [NSMutableDictionary dictionary];
                                                                             for (NSString* key in [data allKeys]) {
                                                                                 int result = [[data objectForKey:key] intValue];
                                                                                 if (result == 0) {
                                                                                     [results setObject:@"OFF" forKey:key];
                                                                                 } else {
                                                                                     [results setObject:@"ON" forKey:key];
                                                                                 }
                                                                             }
                                                                             return results;
                                                                         }];
                                                                         [characteristicProfile serializeString:^NSData*(NSDictionary* data) {
                                                                             return nil;
                                                                         }];
                                                                         characteristicProfile.initialValue = [characteristicProfile valueFromString:@{HUE_LIGHTS_SWITCH_ALL_LIGHTS:@"ON",
                                                                                                                                                       HUE_LIGHTS_SWITCH_SUNRISE:@"OFF",
                                                                                                                                                       HUE_LIGHTS_SWITCH_SUNSET:@"ON"}];
                                                                     }];
                               }];

}

@end
