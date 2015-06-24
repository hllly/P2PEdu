//
//  Helper.m
//  Antidote
//
//  Created by Dmytro Vorobiov on 08.06.15.
//  Copyright (c) 2015 dvor. All rights reserved.
//

#import "Helper.h"
#import "OCTToxConstants.h"
#import "ProfileManager.h"

@implementation Helper

#pragma mark -  Public

+ (BOOL)isAddressString:(NSString *)string
{
    if (string.length != kOCTToxAddressLength) {
        return NO;
    }

    NSCharacterSet *validChars = [NSCharacterSet characterSetWithCharactersInString:@"1234567890abcdefABCDEF"];

    NSArray *components = [string componentsSeparatedByCharactersInSet:validChars];

    NSString *leftChars = [components componentsJoinedByString:@""];

    return (leftChars.length == 0);
}

+ (StatusCircleStatus)circleStatusFromFriend:(OCTFriend *)friend
{
    if (friend.connectionStatus == OCTToxConnectionStatusNone) {
        return StatusCircleStatusOffline;
    }

    switch (friend.status) {
        case OCTToxUserStatusNone:
            return StatusCircleStatusOnline;
        case OCTToxUserStatusAway:
            return StatusCircleStatusAway;
        case OCTToxUserStatusBusy:
            return StatusCircleStatusBusy;
    }
}

+ (RBQFetchedResultsController *)createFetchedResultsControllerForType:(OCTFetchRequestType)type
                                                              delegate:(id<RBQFetchedResultsControllerDelegate>)delegate
{
    return [self createFetchedResultsControllerForType:type predicate:nil delegate:delegate];
}

+ (RBQFetchedResultsController *)createFetchedResultsControllerForType:(OCTFetchRequestType)type
                                                             predicate:(NSPredicate *)predicate
                                                              delegate:(id<RBQFetchedResultsControllerDelegate>)delegate
{
    OCTSubmanagerObjects *submanager = [AppContext sharedContext].profileManager.toxManager.objects;

    RBQFetchRequest *fetchRequest = [submanager fetchRequestForType:type withPredicate:predicate];
    RBQFetchedResultsController *controller = [[RBQFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                     sectionNameKeyPath:nil
                                                                                              cacheName:nil];
    controller.delegate = delegate;
    [controller performFetch];

    return controller;
}

@end
