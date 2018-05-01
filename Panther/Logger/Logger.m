//
//  Logger.m
//  Panther
//
//  Created by VS-Saddam Husain-MacBookPro on 30/04/18.
//  Copyright © 2018 VS-Saddam Husain-MacBookPro. All rights reserved.
//

#import "Logger.h"

@implementation Logger

static Logger *_sharedLogManager = nil;

+ (Logger *)sharedLogManager {
    @synchronized([Logger class]) {
        if (!_sharedLogManager)
            _sharedLogManager = [[self alloc] init];
        return _sharedLogManager;
    }
    return nil;
}

- (id)init {

    if ( self = [super init] ) {

        // Creating file into document directory

        filePath = [[self applicationDocumentsDirectory].path
                    stringByAppendingPathComponent:@"LogFile.txt"];
        NSString *clearText = @"";
        [clearText writeToFile:filePath atomically:YES encoding: NSUnicodeStringEncoding error:nil];

        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    }
    return self;
}


- (void)log:(NSString *)textString {

    //Storing the each read tag info
    NSDate *date = [NSDate date];
    NSString *dateString = [dateFormatter stringFromDate:date];
    NSString *textToWrite = [NSString stringWithFormat:@"Time = %@, %@\n",dateString,textString];
    NSString *contents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    contents = [contents stringByAppendingString:textToWrite];
    [contents writeToFile:filePath atomically:YES encoding: NSUnicodeStringEncoding error:nil];
}



- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}


@end

