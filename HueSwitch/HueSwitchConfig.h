//
//  HueSwitchConfig.h
//  HueSwitch
//
//  Created by Troy Stribling on 5/31/14.
//  Copyright (c) 2014 gnos.us. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HueSwitchConfig : NSObject

+ (void)setBonded:(BOOL)bonded;
+ (BOOL)getBonded;

+ (void)setLightCount:(NSInteger)lightCount;
+ (NSInteger)getLightCount;

+ (void)setSceneCount:(NSInteger)sceneCount;
+ (NSInteger)getSceneCount;

+ (void)setScene:(NSMutableDictionary*)scene withId:(NSInteger)sceneId;
+ (NSArray*)getScenes;
+ (void)removeSceneWithId:(NSInteger)sceneId;

+ (void)setLight:(NSMutableDictionary*)light withId:(NSInteger)lightId andSceneId:(NSInteger)sceneId;
+ (NSArray*)getLightsForSceneId:(NSInteger)sceneId;
+ (void)removeLightWithId:(NSInteger)lightId andSceneId:(NSInteger)sceneId;

@end
