//
//  main.m
//  readSatistFill
//
//  Created by chenfenglong on 2017/3/22.
//  Copyright © 2017年 chenfenglong. All rights reserved.
//

#import <Foundation/Foundation.h>


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        NSString *filePath = @"/Users/chenfenglong/Desktop/st.m";
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        if ([fileMgr fileExistsAtPath:filePath]) {
            NSData *data = [fileMgr contentsAtPath:filePath];
            NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSArray *arrayText = [string componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
            
            NSMutableArray *newArrayResult1 = [NSMutableArray array];
            NSMutableArray *newArrayResult2 = [NSMutableArray array];
            for (NSString *newString in arrayText) {
                NSError *error = nil;
                NSString *regexString = @"<string name=\"(.*)\">(.*)</string>";
                regexString = @"<string name=";
                NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexString options:NSRegularExpressionCaseInsensitive error:&error];
                NSArray *resultArray = [regex matchesInString:newString options:NSMatchingReportProgress range:NSMakeRange(0, [newString length])];
                for (NSTextCheckingResult *result in resultArray) {
                    if (result) {
                        NSString *matchString1 = @"";
                        NSString *matchString2 = @"";
                        NSInteger numberOfRanges = result.numberOfRanges;
                        if (numberOfRanges > 1) {
                            for (int i = 1; i< result.numberOfRanges; i++) {
                                if (i == 1)
                                {
                                    matchString1 = [newString substringWithRange:[result rangeAtIndex:i]];
                                }
                                else
                                {
                                    matchString2 = [newString substringWithRange:[result rangeAtIndex:i]];
                                }
                                
                                NSLog(@"匹配到的字符串:%@",[newString substringWithRange:[result rangeAtIndex:i]]);
                            }
                            NSString *newString1 = [NSString stringWithFormat:@"extern NSString *const %@;",matchString1];
                            NSString *newString2 = [NSString stringWithFormat:@"NSString *const %@ = @\"%@\";",matchString1,matchString2];
                            [newArrayResult1 addObject:newString1];
                            [newArrayResult2 addObject:newString2];
                        }
                    }
                }
            }
            NSString *newFilePath1 = @"/Users/chenfenglong/Desktop/result1.h";
           NSString *newFilePath2 = @"/Users/chenfenglong/Desktop/result2.m";
            [newArrayResult1 writeToFile:newFilePath1 atomically:YES];
            [newArrayResult2 writeToFile:newFilePath2 atomically:YES];
           NSString *result1 = [newArrayResult1 componentsJoinedByString:@"\n"];
            NSString *result2 = [newArrayResult2 componentsJoinedByString:@"\n"];
            [result1 writeToFile:newFilePath1 atomically:YES encoding:NSUTF8StringEncoding error:nil];
            [result2 writeToFile:newFilePath2 atomically:YES encoding:NSUTF8StringEncoding error:nil];
            NSLog(@"%@ -> %@",newArrayResult1,newArrayResult2);
        }
    }
    return 0;
}
