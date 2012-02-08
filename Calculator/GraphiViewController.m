//
//  GraphiViewController.m
//  Calculator
//
//  Created by Marco Morales on 2/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphiViewController.h"
#import "GraphiView.h"
#import "AxesDrawer.h"

@interface GraphiViewController() <GraphiViewDataSource>
@property (nonatomic, weak) IBOutlet GraphiView *graphiView;

@end


@implementation GraphiViewController
@synthesize graphiView = _graphiView;
@synthesize label=_label;

- (void)setLabel:(int)label
{
    _label = label;
    NSLog(@"LO QUE SEA %i",label);
    //self.displayPrueba.text = @"LO QUE SEA";
    [self.graphiView setNeedsDisplay];
        
}

- (void)setGraphiView:(GraphiView *)graphiView
{
    _graphiView = graphiView;
    self.graphiView.dataSource = self;
}


- (void)dibujar:(GraphiView *)sender contexto:(CGContextRef)context
{
    CGContextBeginPath(context);
    //CGContextMoveToPoint(context, mouthStart.x, mouthStart.y);
    //CGContextAddCurveToPoint(context, mouthCP1.x, mouthCP1.y, mouthCP2.x, mouthCP2.y, mouthEnd.x, mouthEnd.y); // bezier curve
    CGContextMoveToPoint(context, 10, 50);
    CGContextAddCurveToPoint(context, 10, 100, 10, 100, 10, 200); // 
    CGContextStrokePath(context);
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

//- (void)viewDidUnload {
   // [self setDisplayPrueba:nil];
  //  [super viewDidUnload];
//}




@end
