//
//  SCParser.m
//  SCParser
//
//  Created by Даниил on 01.05.18.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "SCParser.h"

static NSString * _Nullable const kSCParserCommonErrorDomain = @"ru.danpashin.scparser.common.error";


@interface SCParser ()
@property (strong, nonatomic) dispatch_queue_t parseQueue;
@end


@implementation SCParser

- (_Nonnull instancetype)init 
{
    self = [super init];
    if (self) {
        self.parseQueue = dispatch_queue_create("ru.danpashin.scparser", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (void)parseAppProvisionWithCompletion:(void (^_Nonnull)(NSDictionary * _Nullable provisionDict, NSError * _Nullable error))completion
{
    dispatch_async(self.parseQueue, ^{
        NSString *provisionPath = [[NSBundle mainBundle] pathForResource:@"embedded" ofType:@"mobileprovision"];
        if (!provisionPath) {
            NSError *error = [NSError errorWithDomain:kSCParserCommonErrorDomain code:4 
                                             userInfo:@{NSLocalizedDescriptionKey: @"Cannot start parsing. Provision file does not exist."}];
            completion(nil, error);
            return;
        }
        
        [self parseSignedData:[NSData dataWithContentsOfFile:provisionPath] completion:completion];
    });
}

- (void)parseSignedData:(nullable NSData *)signedData completion:(void (^ _Nonnull)(NSDictionary * _Nullable plist, NSError * _Nullable error))completion
{
    dispatch_async(self.parseQueue, ^{
        CFStringRef signedString = CFStringCreateWithBytes(kCFAllocatorDefault, signedData.bytes, signedData.length, kCFStringEncodingISOLatin1, YES);
        if (!signedString || (CFStringGetLength(signedString) == 0)) {
            if (signedString)
                CFRelease(signedString);
            
            NSError *error = [NSError errorWithDomain:kSCParserCommonErrorDomain code:1 
                                             userInfo:@{NSLocalizedDescriptionKey: @"Cannot start parsing. Data is nil or has inappropriate encoding."}];
            completion(nil, error);
            return;
        }
        
        CFMutableStringRef mutableDataString = CFStringCreateMutableCopy(kCFAllocatorDefault, signedData.length, signedString);
        CFRelease(signedString);
        
        CFRange beginRange = CFStringFind(mutableDataString, CFSTR("<plist"), kCFCompareCaseInsensitive);
        CFStringDelete(mutableDataString, CFRangeMake(0, beginRange.location-1));
        
        CFRange endRange = CFStringFind(mutableDataString, CFSTR("</plist>"), kCFCompareCaseInsensitive);
        endRange.location = endRange.location + endRange.length;
        endRange.length = CFStringGetLength(mutableDataString) - endRange.location;
        CFStringDelete(mutableDataString, endRange);
        
        CFDataRef unsignedData = CFStringCreateExternalRepresentation(kCFAllocatorDefault, mutableDataString, kCFStringEncodingUTF8, 0);
        CFRelease(mutableDataString);
        
        if (!unsignedData) {
            NSError *error = [NSError errorWithDomain:kSCParserCommonErrorDomain code:2 
                                             userInfo:@{NSLocalizedDescriptionKey: @"Cannot complete parsing. Parsed data has inappropriate format."}];
            completion(nil, error);
            return;
        }
        
        CFErrorRef plistError = NULL;
        NSDictionary *plist =  CFBridgingRelease(CFPropertyListCreateWithData(kCFAllocatorDefault, unsignedData, kCFPropertyListImmutable, NULL, &plistError));
        CFRelease(unsignedData);
        
        if (!plistError && [plist isKindOfClass:[NSDictionary class]]) {
            completion(plist, nil);
        } else {
            NSError *error = [NSError errorWithDomain:kSCParserCommonErrorDomain code:3 
                                             userInfo:@{NSLocalizedDescriptionKey: @"Cannot complete parsing. Parsed data is not dictionary."}];
            completion(nil, error);
        }
    });
}

@end
