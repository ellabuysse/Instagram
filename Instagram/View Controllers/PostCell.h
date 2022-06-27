//
//  PostCell.h
//  Instagram
//
//  Created by ellabuysse on 6/27/22.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import <Parse/Parse.h>


NS_ASSUME_NONNULL_BEGIN

@interface PostCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) Post *post;

@end

NS_ASSUME_NONNULL_END
