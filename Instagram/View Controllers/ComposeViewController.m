//
//  ComposeViewController.m
//  Instagram
//
//  Created by ellabuysse on 6/25/22.
//

#import "ComposeViewController.h"
#import "Post.h"

@interface ComposeViewController () <UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;

    self.caption.delegate = self;
    self.caption.text = @"Write a caption...";
    self.caption.textColor = [UIColor lightGrayColor];

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

- (void)textViewDidBeginEditing:(UITextView *)caption
{
    if ([caption.text isEqualToString:@"Write a caption..."]) {
         caption.text = @"";
         caption.textColor = [UIColor blackColor];
    }
    [caption becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)caption
{
    if ([caption.text isEqualToString:@""]) {
        caption.text = @"placeholder text here...";
        caption.textColor = [UIColor lightGrayColor]; //optional
    }
    [caption resignFirstResponder];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    // Do something with the images (based on your use case)
    self.imageToPost.image = editedImage;
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapShare:(id)sender {
    if(self.imageToPost == nil){
        UIAlertController *alert= [UIAlertController alertControllerWithTitle:@"Error!" message:@"An image must be selected to post." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){}];
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:^{
        }];
    }
    else{
        [Post postUserImage:self.imageToPost.image withCaption:self.caption.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            NSLog(@"success!");
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }
}

- (IBAction)didTapCancel:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
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
