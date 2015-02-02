//
//  AVSpeechUtterance+Shaks.m
//  Shik Shak
//
//  Created by Zachary Shakked on 1/30/15.
//  Copyright (c) 2015 Shakked Inc. All rights reserved.
//

#import "AVSpeechUtterance+Shaks.h"

@implementation AVSpeechUtterance (Shaks)

+ (AVSpeechUtterance *)utteranceForShakInfo:(NSDictionary *)shakInfo {
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:shakInfo[@"shakText"]];
    utterance.rate = [shakInfo[@"rate"] floatValue];
    utterance.pitchMultiplier = [shakInfo[@"pitch"] floatValue];
    utterance.voice = shakInfo[@"voice"];
    return utterance;
}

@end
