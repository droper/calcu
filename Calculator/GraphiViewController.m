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

// Crear una funcion setPoints la cual reciba los puntos en un NSSset desde CalculatorViewcontroller

// Crear una funcion ecuationPoints la cual devuelva un NSSset con los puntos de la ecuación a dibujar

- (void)setGraphiView:(GraphiView *)graphiView
{
    _graphiView = graphiView;
    self.graphiView.dataSource = self;
}

// Funcion que dibuja los ejes cartesianos
- (void)drawAxis:(GraphiView *)sender 
{
    CGRect rect = CGRectMake(0,0, 640, 960);
    CGPoint punto = CGPointMake(160, 200);
    CGFloat escala = 1;
    
    [AxesDrawer drawAxesInRect:rect originAtPoint:punto scale:escala];
}

- (void)ecuationPoins:(NSSet *)points
{
    
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
