//
//  CoreDataManager+Message.h
//  Antidote
//
//  Created by Dmitry Vorobyov on 26.07.14.
//  Copyright (c) 2014 dvor. All rights reserved.
//

#import "CoreDataManager.h"
#import "CDMessage.h"

/**
 * userInfo will contain dictionary with following keys:
 * kCoreDataManagerNewMessageKey - containing appropriate CDMessage
 */
extern NSString *const kCoreDataManagerNewMessageNotification;
extern NSString *const kCoreDataManagerNewMessageKey;

typedef NS_ENUM(NSUInteger, CDMessageType) {
    CDMessageTypeText,
    CDMessageTypeFile,
    CDMessageTypePendingFile,
    CDMessageTypeCall,
};

@interface CoreDataManager (Message)

+ (void)messagesForChat:(CDChat *)chat
        completionQueue:(dispatch_queue_t)queue
        completionBlock:(void (^)(NSArray *messages))completionBlock;

+ (void)insertMessageWithType:(CDMessageType)type
                  configBlock:(void (^)(CDMessage *message))configBlock
              completionQueue:(dispatch_queue_t)queue
              completionBlock:(void (^)(CDMessage *message))completionBlock;

@end
