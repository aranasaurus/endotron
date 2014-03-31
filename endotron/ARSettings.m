//
//  ARSettings
//  endotron
//
//  Created by ryana on 3/30/14
//  Copyright (c) 2014 ESRI. All rights reserved.
//

#import "ARSettings.h"


@implementation ARSettings {

}

+ (NSMutableDictionary *)serverInfo {
    NSMutableDictionary *dictionary = [NSMutableDictionary new];

    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"serverInfo"];
    if (data != nil) {
        dictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }

    return dictionary;
}

+ (void)saveServerInfo:(NSMutableDictionary *)serverInfo {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:serverInfo];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"serverInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSURL *)URL {
    return [self serverInfo][@"url"];
}

+ (void)setURL:(NSURL *)url {
    NSMutableDictionary *serverInfo = [self serverInfo];
    serverInfo[@"url"] = url;
    [self saveServerInfo:serverInfo];
}

+ (NSString *)databaseName {
    return [self serverInfo][@"databaseName"];
}

+ (void)setDatabaseName:(NSString *)databaseName {
    NSMutableDictionary *serverInfo = [self serverInfo];
    serverInfo[@"databaseName"] = databaseName;
    [self saveServerInfo:serverInfo];
}

+ (NSString *)username {
    return [self serverInfo][@"username"];
}

+ (void)setUsername:(NSString *)username {
    NSMutableDictionary *serverInfo = [self serverInfo];
    serverInfo[@"username"] = username;
    [self saveServerInfo:serverInfo];
}

+ (NSString *)password {
    return [self serverInfo][@"password"];
}

+ (void)setPassword:(NSString *)password {
    NSMutableDictionary *serverInfo = [self serverInfo];
    serverInfo[@"password"] = password;
    [self saveServerInfo:serverInfo];
}

@end