//
//  HueSwitchProfile.h
//  HueSwitch
//
//  Created by Troy Stribling on 3/4/14.
//  Copyright (c) 2014 gnos.us. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HUE_LIGHTS_SWITCH_SERVICE_UUID  @"2f0a-0010-69aa-f316-3e78-4194989a6c1a"
#define HUE_LIGHTS_SCENES_SERVICE_UUID  @"2f0a-0021-69aa-f316-3e78-4194989a6c1a"

@interface HueSwitchProfile : NSObject

+ (void)create;

@end
