//
//  PDFExampleViewController.h
//  Leaves
//
//  Created by Tom Brow on 4/19/10.
//  Copyright 2010 Tom Brow. All rights reserved.
//

#import "LeavesViewController.h"

@interface PDFExampleViewController : LeavesViewController <UIScrollViewDelegate>{
	//CGPDFDocumentRef pdf;
	CATiledLayer *tiledLayer;
	
	UIView *myContentView;
	//LeavesView *myContentView;
    CGPDFDocumentRef myDocumentRef;
    CGPDFPageRef myPageRef;
}

@end
