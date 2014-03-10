//
//  HueSwitchProfile.h
//  HueSwitch
//
//  Created by Troy Stribling on 3/4/14.
//  Copyright (c) 2014 gnos.us. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HUE_LIGHTS_SERVICE_UUID     @"2f0a0021-69aa-f316-3e78-4194989a6c1a"

#define HUE_LIGHTS_NUMBER_OF_SCENES     @"Number of Scenes"
#define HUE_LIGHTS_SCENE_ID             @"Scene ID"
#define HUE_LIGHTS_SCENE_NAME           @"Scene Name"
#define HUE_LIGHTS_CURRENT_SCENE_ID     @"Current Scene ID"
#define HUE_LIGHTS_NUMBER_OF_LIGHTS     @"Number of Lights"

#define HUE_LIGHTS_LIGHT_ID                 @"Light ID"
#define HUE_LIGHTS_LIGHT_COLOR_HUE          @"Light Hue"
#define HUE_LIGHTS_LIGHT_COLOR_SATUARTION   @"Light Saturation"
#define HUE_LIGHTS_LIGHT_COLOR_BRIGHTNESS   @"Light Brightness"

#define HUE_LIGHTS_SWITCH_ALL_LIGHTS        @"All Lights"
#define HUE_LIGHTS_SWITCH_SUNRISE           @"Sunrise"
#define HUE_LIGHTS_SWITCH_SUNSET            @"Sunrise"

#define HUE_LIGHTS_COMMAND_ADD_SCENE                    @"Add Scene"
#define HUE_LIGHTS_COMMAND_ADD_SCENE_VALUE              0x00
#define HUE_LIGHTS_COMMAND_REMOVE_SCENE                 @"Remove Scene"
#define HUE_LIGHTS_COMMAND_REMOVE_SCENE_VALUE           0x01
#define HUE_LIGHTS_COMMAND_NEXT_SCENE                   @"Next Scene"
#define HUE_LIGHTS_COMMAND_NEXT_SCENE_VALUE             0x02
#define HUE_LIGHTS_COMMAND_NEXT_LIGHT                   @"Next Light"
#define HUE_LIGHTS_COMMAND_NEXT_LIGHT_VALUE             0x03
#define HUE_LIGHTS_COMMAND_ADD_BOND                     @"Add Bond"
#define HUE_LIGHTS_COMMAND_ADD_BOND_VALUE               0x04
#define HUE_LIGHTS_COMMAND_CLEAR_BONDS                  @"Clear Bonds"
#define HUE_LIGHTS_COMMAND_CLEAR_BONDS_VALUE            0x05


@interface HueSwitchProfile : NSObject

+ (void)create;

@end
