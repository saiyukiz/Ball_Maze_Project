//
//  SettingsManager.h
//  Box2D
//
//  Created by Sam Lee on 2013/07/01.
//
//

#import <Foundation/Foundation.h>

@interface SettingsManager : NSObject {
    NSMutableDictionary* settings;
}

-(NSString *)getString:(NSString*)value;
-(int)getInt:(NSString*)value;
-(void)setValue:(NSString*)value newString:(NSString *)aValue;
-(void)setValue:(NSString*)value newInt:(int)aValue;
-(void)save;
-(void)load;
-(void)logSettings;


+(SettingsManager*)sharedSettingsManager; 

@end
