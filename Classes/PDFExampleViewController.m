    //
//  PDFExampleViewController.m
//  Leaves
//
//  Created by Tom Brow on 4/19/10.
//  Copyright 2010 Tom Brow. All rights reserved.
//

#import "PDFExampleViewController.h"
#import "Utilities.h"
#import <QuartzCore/QuartzCore.h>
@implementation PDFExampleViewController

- (id)init {
    if (self = [super init]) {
		CFURLRef pdfURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), CFSTR("sample.pdf"), NULL, NULL);
		myDocumentRef = CGPDFDocumentCreateWithURL((CFURLRef)pdfURL);
		//myPageRef =CGPDFDocumentGetPage(myDocumentRef, 1); 
		//CGRect pageRect = CGRectIntegral(CGPDFPageGetBoxRect(myPageRef, kCGPDFCropBox));
		CFRelease(pdfURL);
    }
    return self;
}

- (void)dealloc {
	CGPDFDocumentRelease(myDocumentRef);
    [super dealloc];
}


- (void) displayPageNumber:(NSUInteger)pageNumber {
    NSUInteger numberOfPages = CGPDFDocumentGetNumberOfPages(myDocumentRef);
    NSString *pageNumberString = [NSString stringWithFormat:@"Page %u of %u", pageNumber, numberOfPages];
    if (leavesView.mode == LeavesViewModeFacingPages) {
        if (pageNumber > numberOfPages) {
            pageNumberString = [NSString stringWithFormat:@"Page %u of %u", pageNumber-1, numberOfPages];
        } else if (pageNumber > 1) {
            pageNumberString = [NSString stringWithFormat:@"Pages %u-%u of %u", pageNumber - 1, pageNumber, numberOfPages];
        }
    }
	self.navigationItem.title = pageNumberString;
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self displayPageNumber:leavesView.currentPageIndex + 1];
}


#pragma mark  LeavesViewDelegate methods

- (void) leavesView:(LeavesView *)leavesView willTurnToPageAtIndex:(NSUInteger)pageIndex {
	[self displayPageNumber:pageIndex + 1];
}

/****************************************************************/
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return myContentView;
}


- (void) leavesView:(LeavesView *)theView doubleTapCurrentView:(NSUInteger)zoomLevel {	
	[tiledLayer removeFromSuperlayer];
	tiledLayer = nil;
	[tiledLayer release];
}


#pragma mark LeavesViewDataSource methods

- (NSUInteger) numberOfPagesInLeavesView:(LeavesView*)leavesView {
	return CGPDFDocumentGetNumberOfPages(myDocumentRef);
}

- (void) renderPageAtIndex:(NSUInteger)index inContext:(CGContextRef)ctx {
	CGPDFPageRef page = CGPDFDocumentGetPage(myDocumentRef, index + 1);
	CGAffineTransform transform = aspectFit(CGPDFPageGetBoxRect(page, kCGPDFMediaBox),
											CGContextGetClipBoundingBox(ctx));
	CGContextConcatCTM(ctx, transform);
	CGContextDrawPDFPage(ctx, page);
}


- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    CGContextSetRGBFillColor(ctx, 1.0, 1.0, 1.0, 1.0);
    CGContextFillRect(ctx, CGContextGetClipBoundingBox(ctx));
    CGContextTranslateCTM(ctx, 0.0, layer.bounds.size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    CGContextConcatCTM(ctx, CGPDFPageGetDrawingTransform(myPageRef, kCGPDFCropBox, layer.bounds, 0, true));
    CGContextDrawPDFPage(ctx, myPageRef);
}




#pragma mark Page Moving Commands

-(SEL)zoomOut {
	myPageRef = CGPDFDocumentGetPage(myDocumentRef, leavesView.currentPageIndex+1);
	CGRect pageRect = CGRectIntegral(CGPDFPageGetBoxRect(myPageRef, kCGPDFCropBox));
	
	CATiledLayer *tiledLayer = [CATiledLayer layer];
	tiledLayer.delegate = self;
	tiledLayer.tileSize = CGSizeMake(1024.0, 1024.0);
	tiledLayer.levelsOfDetail = 1000;
	tiledLayer.levelsOfDetailBias = 1000;
	tiledLayer.frame = pageRect;
	
	myContentView = [[UIView alloc] initWithFrame:pageRect];
	[myContentView.layer addSublayer:tiledLayer];
	CGRect viewFrame = self.view.frame;
	viewFrame.origin = CGPointZero;
	UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:viewFrame];
	scrollView.delegate = self;
	scrollView.contentSize = pageRect.size;
	scrollView.maximumZoomScale = 1000;
	[scrollView addSubview:myContentView];
	
	[self.view addSubview:scrollView];
	
	UIBarButtonItem *zoomInButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(zoomIn)];
	self.navigationItem.leftBarButtonItem = zoomInButton;
	[zoomInButton release];


}

-(SEL)zoomIn {
	[tiledLayer removeFromSuperlayer];
	tiledLayer = nil;
	[myContentView removeFromSuperview];
	myContentView = nil;
	[self.view addSubview:leavesView];
	//to do
    UIBarButtonItem *zoomOutButton = [[UIBarButtonItem alloc] initWithTitle:@"放大" style:UIBarButtonItemStylePlain target:self action:@selector(zoomOut)];
    self.navigationItem.leftBarButtonItem = zoomOutButton;
    [zoomOutButton release];
		
}

#pragma mark UIViewController

- (void) viewDidLoad {
	[super viewDidLoad];
	leavesView.backgroundRendering = YES;
	[self displayPageNumber:1];	
	
	UIBarButtonItem *zoomOutButton = [[UIBarButtonItem alloc] initWithTitle:@"放大" style:UIBarButtonItemStylePlain target:self action:@selector(zoomOut)];
	self.navigationItem.leftBarButtonItem = zoomOutButton;
	
	[zoomOutButton release];

}


@end
