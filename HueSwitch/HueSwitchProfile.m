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
                                     name:@"Hue Lights"
                               andProfile:^(BlueCapServiceProfile* serviceProfile) {
                                   
                                   // number of configured scenes
                                   [serviceProfile createCharacteristicWithUUID:HUE_LIGHTS_SCENES_COUNT_CHARACTERISTIC_UUID
                                                                           name:@"Scenes Count"
                                                                     andProfile:^(BlueCapCharacteristicProfile* characteristicProfile) {
                                                                         characteristicProfile.properties = CBCharacteristicPropertyRead;
                                                                         [characteristicProfile deserializeData:^NSDictionary*(NSData* data) {
                                                                             return @{HUE_LIGHTS_SCENES_COUNT:blueCapUnsignedCharFromData(data, NSMakeRange(0, 1))};
                                                                         }];
                                                                         [characteristicProfile stringValue:^NSDictionary*(NSDictionary* data) {
                                                                             return @{HUE_LIGHTS_SCENES_COUNT:[[data objectForKey:HUE_LIGHTS_SCENES_COUNT] stringValue]};
                                                                         }];
                                                                         [characteristicProfile serializeString:^NSData*(NSDictionary* data) {
                                                                             uint8_t value = [[data objectForKey:HUE_LIGHTS_SCENES_COUNT] intValue];
                                                                             return blueCapUnsignedCharToData(value);
                                                                         }];
                                                                         characteristicProfile.initialValue = [characteristicProfile valueFromString:@{HUE_LIGHTS_SCENES_COUNT:[NSString stringWithFormat:@"%d", 10]}];
                                                                     }];
                                   
                                   // displayed scene ID
                                   [serviceProfile createCharacteristicWithUUID:HUE_LIGHTS_SCENES_ID_CHARACTERISTIC_UUID
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
                                   [serviceProfile createCharacteristicWithUUID:HUE_LIGHTS_SCENE_NAME_CHARACTERISTIC_UUID
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
                                   [serviceProfile createCharacteristicWithUUID:HUE_LIGHTS_CURRENT_SCENE_ID_CHARACTERISTIC_UUID
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
                                   [serviceProfile createCharacteristicWithUUID:HUE_LIGHTS_LIGHTS_COUNT_CHARACTERISTIC_UUID
                                                                           name:@"Lights Count"
                                                                     andProfile:^(BlueCapCharacteristicProfile* characteristicProfile) {
                                                                         characteristicProfile.properties = CBCharacteristicPropertyRead;
                                                                         [characteristicProfile deserializeData:^NSDictionary*(NSData* data) {
                                                                             return @{HUE_LIGHTS_LIGHTS_COUNT:blueCapUnsignedCharFromData(data, NSMakeRange(0, 1))};
                                                                         }];
                                                                         [characteristicProfile stringValue:^NSDictionary*(NSDictionary* data) {
                                                                             return @{HUE_LIGHTS_LIGHTS_COUNT:[[data objectForKey:HUE_LIGHTS_LIGHTS_COUNT] stringValue]};
                                                                         }];
                                                                         [characteristicProfile serializeString:^NSData*(NSDictionary* data) {
                                                                             uint8_t value = [[data objectForKey:HUE_LIGHTS_CURRENT_SCENE_ID] intValue];
                                                                             return blueCapUnsignedCharToData(value);
                                                                         }];
                                                                         characteristicProfile.initialValue = [characteristicProfile valueFromString:@{HUE_LIGHTS_SCENE_ID:[NSString stringWithFormat:@"%d", 1]}];
                                                                     }];
                                   
                                   // displayed light color for displayed scene
                                   [serviceProfile createCharacteristicWithUUID:HUE_LIGHTS_LIGHT_COLOR_CHARACTERISTIC_UUID
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
                                                                             return @{HUE_LIGHTS_LIGHT_ID:[[data objectForKey:HUE_LIGHTS_LIGHT_ID] stringValue],
                                                                                      HUE_LIGHTS_LIGHT_COLOR_BRIGHTNESS:[[data objectForKey:HUE_LIGHTS_LIGHT_COLOR_BRIGHTNESS] stringValue],
                                                                                      HUE_LIGHTS_LIGHT_COLOR_SATUARTION:[[data objectForKey:HUE_LIGHTS_LIGHT_COLOR_SATUARTION] stringValue],
                                                                                      HUE_LIGHTS_LIGHT_COLOR_HUE:[[data objectForKey:HUE_LIGHTS_LIGHT_COLOR_HUE] stringValue]};
                                                                         }];
                                                                         characteristicProfile.initialValue = [characteristicProfile valueFromObject:@{HUE_LIGHTS_LIGHT_ID:[NSNumber numberWithUnsignedChar:1],
                                                                                                                                                       HUE_LIGHTS_LIGHT_COLOR_BRIGHTNESS:[NSNumber numberWithUnsignedChar:100],
                                                                                                                                                       HUE_LIGHTS_LIGHT_COLOR_SATUARTION:[NSNumber numberWithUnsignedChar:125],
                                                                                                                                                       HUE_LIGHTS_LIGHT_COLOR_HUE:[NSNumber numberWithUnsignedShort:20000]}];
                                                                     }];
                                   
                                   // apply commands
                                   [serviceProfile createCharacteristicWithUUID:HUE_LIGHTS_COMMAND_CHARACTERISTIC_UUID
                                                                            name:HUE_LIGHTS_COMMAND
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
                                   
                                   // turn lights on and off
                                   [serviceProfile createCharacteristicWithUUID:HUE_LIGHTS_SWITCH_ALL_LIGHTS_CHARACTERISTIC_UUID
                                                                           name:HUE_LIGHTS_SWITCH_ALL_LIGHTS
                                                                     andProfile:^(BlueCapCharacteristicProfile* characteristicProfile) {
                                                                         characteristicProfile.properties = CBCharacteristicPropertyRead | CBCharacteristicPropertyWrite;
                                                                         [characteristicProfile setValue:blueCapUnsignedCharToData(HUE_LIGHTS_SWITCH_ALL_LIGHTS_OFF_VALUE)    named:HUE_LIGHTS_SWITCH_ALL_LIGHTS_OFF];
                                                                         [characteristicProfile setValue:blueCapUnsignedCharToData(HUE_LIGHTS_SWITCH_ALL_LIGHTS_ON_VALUE)     named:HUE_LIGHTS_SWITCH_ALL_LIGHTS_ON];
                                                                         characteristicProfile.initialValue = [characteristicProfile valueFromNamedObject:HUE_LIGHTS_SWITCH_ALL_LIGHTS_OFF];
                                                                     }];
                                   
                                   // light connection status
                                   [serviceProfile createCharacteristicWithUUID:HUE_LIGHTS_STATUS_CHARACTERISTIC_UUID
                                                                           name:HUE_LIGHTS_STATUS
                                                                     andProfile:^(BlueCapCharacteristicProfile* characteristicProfile) {
                                                                         characteristicProfile.properties = CBCharacteristicPropertyRead | CBCharacteristicPropertyWrite;
                                                                         [characteristicProfile setValue:blueCapUnsignedCharToData(HUE_LIGHTS_STATUS_OFF_LINE_VALUE)    named:HUE_LIGHTS_STATUS_OFF_LINE];
                                                                         [characteristicProfile setValue:blueCapUnsignedCharToData(HUE_LIGHTS_STATUS_ON_LINE_VALUE)     named:HUE_LIGHTS_STATUS_ON_LINE];
                                                                         characteristicProfile.initialValue = [characteristicProfile valueFromNamedObject:HUE_LIGHTS_STATUS_ON_LINE];
                                                                     }];
                                   
                               }];

}

@end
