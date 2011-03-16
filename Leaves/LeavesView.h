//
//  LeavesView.h
//  Leaves
//
//  Created by Tom Brow on 4/18/10.
//  Copyright 2010 Tom Brow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


typedef enum {
    LeavesViewModeSinglePage,
    LeavesViewModeFacingPages,
} LeavesViewMode;



@class LeavesCache;

@protocol LeavesViewDataSource;
@protocol LeavesViewDelegate;

@interface LeavesView : UIView <UIGestureRecognizerDelegate> {
	CALayer *topPage;
	CALayer *topPageOverlay;
	CAGradientLayer *topPageShadow;
	
	CALayer *topPageReverse;
	CALayer *topPageReverseImage;
	CALayer *topPageReverseOverlay;
	CAGradientLayer *topPageReverseShading;
	
	CALayer *bottomPage;
	CAGradientLayer *bottomPageShadow;

    // The left page in two-page mode.
    // Animation is always done on the right page
    CALayer *leftPage;
	CALayer *leftPageOverlay;
    
    // Single page or facing pages?
    LeavesViewMode mode;
    
	CGFloat leafEdge;
    
    // In two-page mode, this is always the index of the right page.
    // Pages with odd numbers (== pages where currentPageIndex is even) are always displayed 
    // on the right side (as in a book)
	NSUInteger currentPageIndex;
	NSUInteger numberOfPages;
    NSUInteger numberOfVisiblePages;
	id<LeavesViewDelegate> delegate;
	
	CGSize pageSize;
	LeavesCache *pageCache;
	BOOL backgroundRendering;
	
	CGPoint touchBeganPoint;
	BOOL touchIsActive;
	CGRect nextPageRect, prevPageRect;
	BOOL interactionLocked;
	
	// We need to know if ZOOM is active or not
	BOOL zoomActive;
	
	// We also need to know if we can PAN/MOVE (of course only on ZOOM mode)
	BOOL panActive;
}

@property (assign) id<LeavesViewDataSource> dataSource;
@property (assign) id<LeavesViewDelegate> delegate;
@property (assign) LeavesViewMode mode;
@property (readonly) CGFloat targetWidth;
@property (assign) NSUInteger currentPageIndex;
@property (assign) BOOL backgroundRendering;

- (void) reloadData;

@end


@protocol LeavesViewDataSource <NSObject>

- (NSUInteger) numberOfPagesInLeavesView:(LeavesView*)leavesView;
- (void) renderPageAtIndex:(NSUInteger)index inContext:(CGContextRef)ctx;

@end

@protocol LeavesViewDelegate <NSObject>

@optional

- (void) leavesView:(LeavesView *)leavesView willTurnToPageAtIndex:(NSUInteger)pageIndex;
- (void) leavesView:(LeavesView *)leavesView didTurnToPageAtIndex:(NSUInteger)pageIndex;
- (void) leavesView:(LeavesView *)leavesView zoomingCurrentView:(NSUInteger)zoomLevel;
- (void) leavesView:(LeavesView *)leavesView doubleTapCurrentView:(NSUInteger)fooVariable;

@end

