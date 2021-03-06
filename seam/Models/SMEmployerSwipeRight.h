//
//  SMJobListing.h
//  seam
//
//  Created by laurenjle on 7/15/19.
//  Copyright © 2019 codepath. All rights reserved.
//

#import "Parse/Parse.h"

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMEmployerSwipeRight : PFObject <PFSubclassing>

//properties used in SMJobCard
@property (nonatomic, strong) PFUser *author;
@property (nonatomic, strong) NSString *jobID;


@end

NS_ASSUME_NONNULL_END
