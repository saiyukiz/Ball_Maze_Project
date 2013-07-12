//
//  SettingsManager.m
//  Box2D
//
//  Created by Rob Segal on 2009/10/07.
//
//

#import "SettingsManager.h"

@implementation SettingsManager

static SettingsManager* _sharedSettingsManager = nil;

-(NSString *)getString:(NSString*)value {
    return [settings objectForKey:value];
}

-(int)getInt:(NSString*)value {
    return [[settings objectForKey:value] intValue];
}

-(void)setValue:(NSString*)value newString:(NSString *)aValue {
    [settings setObject:aValue forKey:value];
}

-(void)setValue:(NSString*)value newInt:(int)aValue {
    [settings setObject:[NSString stringWithFormat:@"%i",aValue] forKey:value];
}

-(void)save {
    // NOTE: You should be replace "MyAppName" with your own custom application string.
    //
    [[NSUserDefaults standardUserDefaults] setObject:settings forKey:@"MyAppName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


-(void)load {
    // NOTE: You should be replace "MyAppName" with your own custom application string.
    //
    [settings addEntriesFromDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"MyAppName"]];
}


// Logging function great for checkin out what keys/values you have at any given time
//
-(void)logSettings {
    for(NSString* item in [settings allKeys]) {
        NSLog(@"[SettingsManager KEY:%@ - VALUE:%@]", item, [settings valueForKey:item]);
    }
}


+(SettingsManager*)sharedSettingsManager {
    @synchronized([SettingsManager class]) {
        if (!_sharedSettingsManager)
            [[self alloc] init];
        return _sharedSettingsManager;
    }
    return nil;
}

+(id)alloc {
    @synchronized([SettingsManager class]) {
        NSAssert(_sharedSettingsManager == nil, @"Attempted to allocate a second instance of a singleton.");
        _sharedSettingsManager = [[super alloc] init];
        return _sharedSettingsManager;
    }
    return nil;
}

-(id)autorelease {
    return self;
}

-(id)init {
    settings = [[NSMutableDictionary alloc] init];
    [self setValue:@"High Score1" newString:@"100"];
    [self setValue:@"High Score2" newString:@"200"];
    [self setValue:@"High Score3" newString:@"300"];
    [self setValue:@"High Score4" newString:@"400"];
    [self setValue:@"High Score5" newString:@"500"];
    [self setValue:@"High Score6" newString:@"600"];
    
    
    return [super init];
}


@end
