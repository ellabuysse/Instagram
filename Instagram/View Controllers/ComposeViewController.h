//
//  ComposeViewController.h
//  Instagram
//
//  Created by ellabuysse on 6/25/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ComposeViewControllerDelegate

- (void)didPost;

@end

@interface ComposeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageToPost;
@property (weak, nonatomic) IBOutlet UITextView *caption;

@end

NS_ASSUME_NONNULL_END
