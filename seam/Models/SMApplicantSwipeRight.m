//
//  SMJobListing.m
//  seam
//
//  Created by laurenjle on 7/15/19.
//  Copyright © 2019 codepath. All rights reserved.
//

#import "SMApplicantSwipeRight.h"

#import <Parse/PFObject+Subclass.h>

@implementation SMApplicantSwipeRight

@dynamic author;
@dynamic jobID;
@dynamic jobURL;
@dynamic companyName;

//can just use new/init alloc now instead of init

//registers to Parse
+ (void)load {
    [self registerSubclass];
}

+ (nonnull NSString *)parseClassName {
    return @"SMApplicantSwipeRight";
}

@end
