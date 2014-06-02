//
//  HueSwitchConfig.m
//  HueSwitch
//
//  Created by Troy Stribling on 5/31/14.
//  Copyright (c) 2014 gnos.us. All rights reserved.
//

#import "HueSwitchConfig.h"

@interface HueSwitchConfig ()

@end

@implementation HueSwitchConfig

+ (void)setBonded:(BOOL)bonded {
    NSUserDefaults* standardDefaults = [NSUserDefaults standardUserDefaults];
    [standardDefaults setBool:bonded forKey:@"bonded"];
}

+ (BOOL)getBonded {
    NSUserDefaults* standardDefaults = [NSUserDefaults standardUserDefaults];
    return [standardDefaults boolForKey:@"bonded"];
}

+ (void)setLightCount:(NSInteger)lightCount {
    NSUserDefaults* standardDefaults = [NSUserDefaults standardUserDefaults];
    [standardDefaults setInteger:lightCount forKey:@"lightCount"];
}

+ (NSInteger)getLightCount {
    NSUserDefaults* standardDefaults = [NSUserDefaults standardUserDefaults];
    return [standardDefaults integerForKey:@"lightCount"];
}

+ (void)setSceneCount:(NSInteger)sceneCount {
    NSUserDefaults* standardDefaults = [NSUserDefaults standardUserDefaults];
    [standardDefaults setInteger:sceneCount forKey:@"sceneCount"];
}

+ (NSInteger)getSceneCount {
    NSUserDefaults* standardDefaults = [NSUserDefaults standardUserDefaults];
    return [standardDefaults integerForKey:@"sceneCount"];
}

+ (void)setScene:(NSMutableDictionary*)scene withId:(NSInteger)sceneId {
    NSUserDefaults* standardDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary* scenes = [standardDefaults objectForKey:@"scenes"];
    [scenes setObject:scene forKey:[NSNumber numberWithInteger:sceneId]];
    [standardDefaults setObject:scenes forKey:@"scenes"];
}

+ (void)removeSceneWithId:(NSInteger)sceneId {
    NSUserDefaults* standardDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary* scenes = [standardDefaults objectForKey:@"scenes"];
    [scenes removeObjectForKey:[NSNumber numberWithInteger:sceneId]];
    [standardDefaults setObject:scenes forKey:@"scenes"];
}

+ (NSArray*)getScenes {
    NSUserDefaults* standardDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary* scenes = [standardDefaults objectForKey:@"scenes"];
    return [scenes allValues];
}

+ (void)setLight:(NSDictionary*)light withId:(NSInteger)lightId andSceneId:(NSInteger)sceneId {
    NSUserDefaults* standardDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary* scenes = [standardDefaults objectForKey:@"scenes"];
    NSMutableDictionary* scene = [scenes objectForKey:[NSNumber numberWithInteger:sceneId]];
    NSMutableDictionary* lights = [scene objectForKey:@"lights"];
    [lights setObject:light forKey:[NSNumber numberWithInteger:lightId]];
    [standardDefaults setObject:scenes forKey:@"scenes"];
}

+ (NSArray*)getLightsForSceneId:(NSInteger)sceneId {
    NSUserDefaults* standardDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary* scenes = [standardDefaults objectForKey:@"scenes"];
    NSMutableDictionary* scene = [scenes objectForKey:[NSNumber numberWithInteger:sceneId]];
    NSMutableDictionary* lights = [scene objectForKey:@"lights"];
    return [lights allValues];
}

+ (void)removeLightWithId:(NSInteger)lightId andSceneId:(NSInteger)sceneId {
    NSUserDefaults* standardDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary* scenes = [standardDefaults objectForKey:@"scenes"];
    NSMutableDictionary* scene = [scenes objectForKey:[NSNumber numberWithInteger:sceneId]];
    NSMutableDictionary* lights = [scene objectForKey:@"lights"];
    [lights removeObjectForKey:[NSNumber numberWithInteger:lightId]];
    [standardDefaults setObject:scenes forKey:@"scenes"];
}

#pragma mark - Private -

@end
