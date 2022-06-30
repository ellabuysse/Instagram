//
//  ProfileViewController.m
//  Instagram
//
//  Created by ellabuysse on 6/29/22.
//

#import "ProfileViewController.h"
#import "Parse/Parse.h"
#import "LoginViewController.h"
#import "SceneDelegate.h"
#import "Post.h"
#import "PostCell.h"

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *posts;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) PFFileObject *imageFileProfile;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //self.refreshControl = [[UIRefreshControl alloc] init];
    //[self.refreshControl addTarget:self action:@selector(getPosts) forControlEvents:UIControlEventValueChanged];
    //[self.tableView insertSubview:self.refreshControl atIndex:0];
    
    PFUser *user = [PFUser currentUser];
    PFFileObject *userProfileImageFile = user[@"profileImage"];
        self.imageFileProfile = userProfileImageFile;
        [userProfileImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                self.profileImage.image = [UIImage imageWithData:imageData];
            }
    }];
    self.profileImage.layer.cornerRadius = 50;
    
    [self getPosts];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.posts.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"postCell" forIndexPath:indexPath];
    Post *post = self.posts[indexPath.row];
    PFUser *user = post[@"author"];
    
    if(user != nil){
        cell.user.text = user.username;
    }
    cell.caption.text = post[@"caption"];
    cell.likeCount.text = [[post[@"likeCount"] stringValue] stringByAppendingString:@" Likes"];
    cell.timeStamp.text = post[@"timestamp"];
    
    PFFileObject *postImage = post[@"image"];
    cell.postImageFile = postImage;
    [postImage getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error){
        if(!error){
            cell.photoImageView.image = [UIImage imageWithData:imageData];
        }
    }];
    
    if(post.favorited) {
        [cell.likeBtn setImage:[UIImage imageNamed:@"heart-fill"] forState:UIControlStateNormal];
    } else {
        [cell.likeBtn setImage:[UIImage imageNamed:@"heart"] forState:UIControlStateNormal];
    }
    
    return cell;
}

- (void)getPosts {
    // Add code to be run periodically
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    postQuery.limit = 20;
    [postQuery whereKey:@"author" equalTo:[PFUser currentUser]];
    
    // fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable postsFound, NSError * _Nullable error) {
        if (postsFound) {
            // do something with the data fetched
            self.posts = (NSMutableArray *)postsFound;
            NSLog(@"%@", self.posts);
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        }
        else {
            // handle error
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}
- (IBAction)addProfileImage:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;

    // The Xcode simulator does not support taking pictures, so let's first check that the camera is indeed supported on the device before trying to present it.
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
            NSLog(@"Camera 🚫 available so we will use photo library instead");
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }

    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    // Do something with the images (based on your use case)
    self.profileImage.image = editedImage;
    
    PFUser *user = [PFUser currentUser];
    user[@"profileImage"] = [self getPFFileFromImage:self.profileImage.image];
    [user saveInBackground];
    
    [self viewDidLoad];
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
 
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
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
