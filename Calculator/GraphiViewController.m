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
@synthesize ecuationTextLabel = _ecuationTextLabel;
@synthesize ecuationText = _ecuationText;
@synthesize points=_points;

- (void)setEcuationText:(NSString *)ecuationText
{
    _ecuationText = ecuationText;
    NSLog(@"LO QUE SEA %@",ecuationText);
    //self.displayPrueba.text = @"LO QUE SEA";
    [self.graphiView setNeedsDisplay];
        
}

// Crear una funcion setPoints la cual reciba los puntos en un NSSset desde CalculatorViewcontroller
- (void)setPoints:(NSMutableArray *)points
{
    _points = points;
    
    [self.graphiView setNeedsDisplay];
}

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

// funcion que dibuja un texto en la pantalla
- (void)drawString:(GraphiView *)sender texto:(NSString *)text atPoint:(CGPoint)location withAnchor:(int)anchor
{
    [AxesDrawer drawString:text atPoint:location withAnchor:anchor];
}

- (NSMutableArray *)ecuationPoints
{
    return self.points;
}

//- (NSString *)ecuationText
/*- (void)ecuationText
{
    //return self.ecuationText;
    NSLog(@"ETIQUETA %@",self.ecuationTextLabel.text);
}*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

-(void)viewDidLoad
{
    self.ecuationTextLabel.text = self.ecuationText;
    [super viewDidLoad];
}

//- (void)viewDidUnload {
   // [self setDisplayPrueba:nil];
  //  [super viewDidUnload];
//}


- (void)viewDidUnload {
    [self setEcuationTextLabel:nil];
    [super viewDidUnload];
}
@end
