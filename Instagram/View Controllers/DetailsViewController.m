//
//  DetailsViewController.m
//  Instagram
//
//  Created by ellabuysse on 6/30/22.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) PFFileObject *postImageFile;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) PFFileObject *imageFileProfile;
@property (weak, nonatomic) IBOutlet UILabel *user;
@property (weak, nonatomic) IBOutlet UILabel *caption;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UILabel *likeCount;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeStamp;
@property (weak, nonatomic) IBOutlet UILabel *username;
@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    PFUser *user = self.post[@"author"];
    
    if(user != nil){
        self.user.text = user.username;
        self.username.text = user.username;
    }
    self.caption.text = self.post[@"caption"];
    self.likeCount.text = [[self.post[@"likeCount"] stringValue] stringByAppendingString:@" Likes"];
    self.timeStamp.text = self.post[@"timestamp"];
    
    PFFileObject *userProfileImageFile = user[@"profileImage"];
        self.imageFileProfile = userProfileImageFile;
        [userProfileImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                self.profileImage.image = [UIImage imageWithData:imageData];
            }
        }];

    PFFileObject *postImage = self.post[@"image"];
    self.postImageFile = postImage;
    [postImage getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error){
        if(!error){
            self.photoImageView.image = [UIImage imageWithData:imageData];
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
