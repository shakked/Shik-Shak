//
//  AVSpeechUtterance+Shaks.h
//  Shik Shak
//
//  Created by Zachary Shakked on 1/30/15.
//  Copyright (c) 2015 Shakked Inc. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface AVSpeechUtterance (Shaks)

+ (AVSpeechUtterance *)utteranceForShakInfo:(NSDictionary *)shakInfo;

@end
