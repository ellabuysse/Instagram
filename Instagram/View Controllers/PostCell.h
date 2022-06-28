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
@property (strong, nonatomic) PFFileObject *postImageFile;
@property (strong, nonatomic) Post *post;
@property (weak, nonatomic) IBOutlet UILabel *user;
@property (weak, nonatomic) IBOutlet UILabel *caption;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UILabel *likeCount;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeStamp;



@end

NS_ASSUME_NONNULL_END
