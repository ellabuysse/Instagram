//
//  PostCell.m
//  Instagram
//
//  Created by ellabuysse on 6/27/22.
//
#import "PostCell.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPost:(Post *)post {
    self.post = post;
    //self.photoImageView.file = post[@"image"];
    //[self.photoImageView loadInBackground];
}


@end
