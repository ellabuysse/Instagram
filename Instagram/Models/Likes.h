//
//  Likes.h
//  Instagram
//
//  Created by ellabuysse on 6/28/22.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"

@interface Likes : PFObject<PFSubclassing>

@property (nonatomic, strong) PFObject *post;
@property (nonatomic, strong) PFUser *user;

+ (nonnull NSString *)parseClassName;

@end
