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


@interface GraphiViewController()
@property (nonatomic, weak) IBOutlet GraphiView *graphiView;
@end



@implementation GraphiViewController
@synthesize displayPrueba = _displayPrueba;
@synthesize graphiView = _graphiView;
@synthesize label=_label;

- (void)setLabel:(int)label
{
    _label = label;
    NSLog(@"setlabel aqui %i",label);
    //self.displayPrueba.text = @"LO QUE SEA";
    //[self.graphiView setNeedsDisplay];
    
    self.displayPrueba.text =  [NSString stringWithFormat:@"LO QUE SEA %i",label];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (void)viewDidUnload {
    [self setDisplayPrueba:nil];
    [super viewDidUnload];
}
@end
