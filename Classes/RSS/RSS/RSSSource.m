//
//  RSSSource.m
//  RSS
//
//  Created by Mr. Depth on 9/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RSSSource.h"


@implementation RSSSource
@synthesize title;
@synthesize url;

- (void) dealloc {
	[title release];
	[url release];
	[super dealloc];
}

@end
