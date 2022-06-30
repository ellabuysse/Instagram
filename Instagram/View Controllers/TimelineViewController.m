//
//  TimelineViewController.m
//  Instagram
//
//  Created by ellabuysse on 6/24/22.
//

#import "TimelineViewController.h"
#import "Parse/Parse.h"
#import "LoginViewController.h"
#import "SceneDelegate.h"
#import "Post.h"
#import "PostCell.h"
#import "Likes.h"
#import "DetailsViewController.h"

@interface TimelineViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *posts;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getPosts) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
   //[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(onTimer) userInfo:nil repeats:true];
    [self getPosts];
    
}

- (IBAction)logoutBtn:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
        NSLog(@"Successfully logged out");
    }];
    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    myDelegate.window.rootViewController = loginViewController;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.posts.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"postCell" forIndexPath:indexPath];
    Post *post = self.posts[indexPath.row];
    cell.post = post;
    PFUser *user = post[@"author"];
    
    if(user != nil){
        cell.user.text = user.username;
        cell.username.text = user.username;
    }
    cell.caption.text = post[@"caption"];
    cell.likeCount.text = [[post[@"likeCount"] stringValue] stringByAppendingString:@" Likes"];
    cell.timeStamp.text = post[@"timestamp"];
    
    PFFileObject *userProfileImageFile = user[@"profileImage"];
        cell.imageFileProfile = userProfileImageFile;
        [userProfileImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                cell.profileImage.image = [UIImage imageWithData:imageData];
            }
    }];

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
- (void)didFinishLiking:(PostCell*)PostCell{
    
    
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"detailsViewSegue"]) {
        DetailsViewController *detailsController = [segue destinationViewController];
    
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    
        Post *post = self.posts[indexPath.row];
        detailsController.post = post;
    }
}


@end
