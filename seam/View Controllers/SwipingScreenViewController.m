//
//  SwipingScreenViewController.m
//  seam
//
//  Created by laurenjle on 7/17/19.
//  Copyright © 2019 codepath. All rights reserved.
//

#import "SwipingScreenViewController.h"
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>
#import "SMJobCard.h"
//#import "SMFakeJobsDataManager.h"
#import "SMRealJobsDataManager.h"
#import "SMJobsDataManaging.h"
#import "SMJobsDataManagerProvider.h"
#import "SMJobListing.h"
#import <QuartzCore/QuartzCore.h> //use for converting uiview to uiimage
#import "Parse/Parse.h"


@interface SwipingScreenViewController ()

//@property (weak, nonatomic) IBOutlet SMJobCard *cardView; //the job applicant
@property (weak, nonatomic) IBOutlet UIView *placeholderView;
@property (nonatomic, strong) NSMutableArray *jobs; //stores the model, an array of JobListings
@property (nonatomic, strong) NSMutableArray<SMJobListing *> *realJobListings;
@end

@implementation SwipingScreenViewController {
    NSUInteger _currentCardIndex; //keep track of the current view's info in viewWasChosenWithDirection method
    NSUInteger _currentCardTrackerIndex;//keep track of the current view's info in viewWasChosenWithDirection method
    NSUInteger _viewBeforeCurrentViewHierarchyIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //setting the array of jobs we defined in the interface to the jobListings accessed from the SMFakeJobsDataManager
    _realJobListings = [[NSMutableArray alloc] init];
    
    _currentCardIndex=0; //index of job listing array
    _currentCardTrackerIndex=1;
    
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
    }];
    
    
    [[SMJobsDataManagerProvider sharedDataManager] fetchJobsWithCompletion:^(NSArray *realJobListings, NSError *error)
     {
         if (realJobListings)
         {
             self.jobs = realJobListings; //an array of dictionaries
             
             //create first card
             NSLog(@"about to make first card, at index: %d", _currentCardIndex);
             [self createSingleCardWithJobListingIndex:_currentCardIndex]; //create 1st card
             
             [self createStackOfCards]; //create rest of cards if there's any left
         }
         else
         {
             NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
         }
         
     }];
}

-(void) createStackOfCards{
    NSLog(@"creating stack of cards, something may have deleted");
    if(_currentCardIndex == [_jobs count]) //BASE CASE
    {
        NSLog(@"done");
    }
    else
    {
        if (_currentCardIndex == _currentCardTrackerIndex)
        {
            NSLog(@"create new card because one just got deleted");
            _currentCardTrackerIndex++;
            [self createSingleCardWithJobListingIndex:_currentCardIndex];
        }
    }
}


-(void) createSingleCardWithJobListingIndex:(int) jobListIndex{
    //swiping yes or no
    // You can customize MDCSwipeToChooseView using MDCSwipeToChooseViewOptions.
    MDCSwipeToChooseViewOptions *options = [MDCSwipeToChooseViewOptions new];
    //set the delegate to this view controller in order to detect the swiping direction per view to work
    options.delegate = self;
    //text box you see at the top left or right corner of card in the home screen when you're swiping
    options.likedText = @"Get job";
    options.likedColor = [UIColor blueColor];
    options.nopeText = @"Delete";
    
    //define size of card. we are using the placeholderView's frame from the storyboard
    //let image serve as a card for now. Need to connect this to the views which will be connect to SMJobListing.h model
    MDCSwipeToChooseView *view = [[MDCSwipeToChooseView alloc] initWithFrame:self.placeholderView.frame
                                                                     options:options];
    SMJobCard *cardView = [[SMJobCard alloc] init];
    //define the cardView's frame using the size we made the placeHolderView in Main.storyboard
    cardView.frame = self.placeholderView.frame;
    
    //testing fake data
    //create a SMFakeJobsDataManager.h object which is where data is coming from
    //usually this is where we dequeue a reusable cell but for now we are focusing on passing data to one card
    // NSLog(self.jobs[jobListIndex]);
    SMJobListing *jobPointer = self.jobs[jobListIndex];
    //NSLog(jobPointer);
    cardView.jobDescriptionLabel.text = jobPointer.title;
    cardView.jobScheduleLabel.text = jobPointer.dates;
    cardView.locationLabel.text = jobPointer.location;
    cardView.dutiesLabel.text = @"N/A for this API";
    
    
    
    
    //convert uiview to uiimage in order for it to show up as a card
    //use the view file we created with CardViewXIB.xib and SMJobCard.m
    view.imageView.image = [self imageWithView:cardView];
    [self.view addSubview:view];
    
    NSLog(@"current card index: %d", _currentCardIndex);
    NSLog(@"tracker index, %d", _currentCardTrackerIndex);
    
}

//NOTE: these methods work after you set the options.delegate = self in viewDidLoad. this would add it to array of applicant_swipes
// Sent before a choice is made. Return `YES`.
- (BOOL)view:(UIView *)view shouldBeChosenWithDirection:(MDCSwipeDirection)direction {
    return YES;
}

// This is called then a user swipes the view fully left or right.
- (void)view:(UIView *)view wasChosenWithDirection:(MDCSwipeDirection)direction {
    if (direction == MDCSwipeDirectionLeft)
    {
        [[SMJobsDataManagerProvider sharedDataManager] onRejectJob:[NSMutableArray arrayWithObjects:self.jobs[_currentCardIndex], nil]];
        NSLog(@"Photo deleted!");
        _currentCardIndex++;
        [self createStackOfCards];
        
    }
    else
    {
        [[SMJobsDataManagerProvider sharedDataManager] onApplyForJob:[NSMutableArray arrayWithObjects:self.jobs[_currentCardIndex], nil]];
        NSLog(@"Photo saved!");
        _currentCardIndex++;
        NSLog(@"current card index after incfrement: %d, ", _currentCardIndex);
        [self createStackOfCards];
    }
}

//convert uiiview to uiimage
- (UIImage *)imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
@end

