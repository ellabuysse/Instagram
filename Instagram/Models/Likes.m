//
//  Likes.m
//  Instagram
//
//  Created by ellabuysse on 6/28/22.
//

#import "Likes.h"

@implementation Likes

@dynamic post;
@dynamic user;

+ (nonnull NSString *)parseClassName {
    return @"Likes";
}

+ (void) postLike: ( PFObject * _Nullable )postObj withCompletion: (PFBooleanResultBlock  _Nullable)completion{
    
    Likes *newLike = [Likes new];
    PFUser *userID = [PFUser currentUser];

    newLike.user = userID;
    newLike.post = postObj;
    
    [newLike saveInBackgroundWithBlock: completion];
}

@end
