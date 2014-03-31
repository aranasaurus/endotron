//
//  ARSettings
//  endotron
//
//  Created by ryana on 3/30/14
//  Copyright (c) 2014 ESRI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ARSettings : NSObject

+ (NSURL *)URL;
+ (void)setURL:(NSURL *)url;
+ (NSString *)databaseName;
+ (void)setDatabaseName:(NSString *)databaseName;
+ (NSString *)username;
+ (void)setUsername:(NSString *)username;
+ (NSString *)password;
+ (void)setPassword:(NSString *)password;

@end