//
//  LeavesViewController.m
//  Leaves
//
//  Created by Tom Brow on 4/18/10.
//  Copyright Tom Brow 2010. All rights reserved.
//

#import "LeavesViewController.h"

@implementation LeavesViewController

- (id)init {
    if (self = [super init]) {
		leavesView = [[LeavesView alloc] initWithFrame:CGRectZero];
        leavesView.mode = UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? LeavesViewModeSinglePage : LeavesViewModeFacingPages;
    }
    return self;
}

- (void)dealloc {
	[leavesView release];
    [super dealloc];
}

#pragma mark -
#pragma mark LeavesViewDataSource methods

- (NSUInteger) numberOfPagesInLeavesView:(LeavesView*)leavesView {
	return 0;
}

- (void) renderPageAtIndex:(NSUInteger)index inContext:(CGContextRef)ctx {
	
}

- (void) leavesView:(LeavesView *)leavesView zoomingCurrentView:(NSUInteger)zoomLevel {
	
}

- (void) leavesView:(LeavesView *)leavesView doubleTapCurrentView:(NSUInteger)zoomLevel {
	
}

#pragma mark -
#pragma mark  UIViewController methods

- (void)loadView {
	[super loadView];
	leavesView.frame = self.view.bounds;
	leavesView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	[self.view addSubview:leavesView];
}

- (void) viewDidLoad {
	[super viewDidLoad];
	leavesView.dataSource = self;
	leavesView.delegate = self;
	[leavesView reloadData];
}


#pragma mark -
#pragma mark Interface rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation 
{
    return YES;
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
        leavesView.mode = LeavesViewModeSinglePage;
    } else {
        leavesView.mode = LeavesViewModeFacingPages;
    }
}

#pragma mark -
#pragma mark View Interaction

- (void) goToPage:(NSInteger)pageNumber {
	// Remember that currentPageIndex start from 0!
	if (pageNumber >= 0 && pageNumber < [self numberOfPagesInLeavesView:leavesView])
		leavesView.currentPageIndex = pageNumber;
}


@end