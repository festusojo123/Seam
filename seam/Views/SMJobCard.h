//
//  SMJobCard.h
//  seam
//
//  Created by laurenjle on 7/17/19.
//  Copyright © 2019 codepath. All rights reserved.
//

#import <MDCSwipeToChoose/MDCSwipeToChoose.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SMJobListing;

@interface SMJobCard : MDCSwipeToChooseView//UIView

//use for xib
@property (strong, nonatomic) IBOutlet UIView *cardDetailsView;

//used this for storyboard
@property (weak, nonatomic) IBOutlet UILabel *jobDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobScheduleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dutiesLabel;
@property (strong, nonatomic) SMJobListing *listing;

@end

NS_ASSUME_NONNULL_END
