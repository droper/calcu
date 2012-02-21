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

#define originX 160
#define originY 200

@interface GraphiViewController() <GraphiViewDataSource>
@property (nonatomic, weak) IBOutlet GraphiView *graphiView;
@property (nonatomic) float translateX;
@property (nonatomic) float translateY;
@property (nonatomic) CGPoint originPoint;



@end

@implementation GraphiViewController
@synthesize graphiView = _graphiView;
@synthesize ecuationTextLabel = _ecuationTextLabel;
@synthesize ecuationText = _ecuationText;
@synthesize points=_points;
@synthesize translateX = _translateX;
@synthesize translateY = _translateY;
@synthesize originPoint = _originPoint;

- (CGPoint)originPoint
{
    if (!_originPoint.x || !_originPoint.y) {
        return CGPointMake(originX, originY); // don't allow zero point
    } else {
        return _originPoint;
    }
}

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

- (void)setTranslateX:(float)translateX
{
    _translateX = translateX;
    
    [self.graphiView setNeedsDisplay];
}

- (void)setTranslateY:(float)translateY
{
    _translateY = translateY;
    
    [self.graphiView setNeedsDisplay];
}

- (void)setOriginPoint:(CGPoint)originPoint
{
    _originPoint = originPoint;
    
    [self.graphiView setNeedsDisplay];
}


- (void)setGraphiView:(GraphiView *)graphiView
{
    _graphiView = graphiView;
    [self.graphiView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphiView action:@selector(pinch:)]];
    
    // recognize a pan gesture and modify our Model
    [self.graphiView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePoint:)]];
    
    // recognize triple tap gesture
    UITapGestureRecognizer *tripleTap = 
    [[UITapGestureRecognizer alloc]
     initWithTarget:self action:@selector(handleTripleTap:)];
    [tripleTap setNumberOfTapsRequired:3];
    [self.graphiView addGestureRecognizer:tripleTap];
    
    self.graphiView.dataSource = self;
}

- (void)handlePoint:(UIPanGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        CGPoint translation = [gesture translationInView:self.graphiView];
        self.translateX -= translation.x;
        self.translateY -= translation.y;

        [gesture setTranslation:CGPointZero inView:self.graphiView];
    }
}

- (void)handleTripleTap:(UITapGestureRecognizer *)gesture
{
    CGPoint point = [gesture locationInView:self.graphiView];
        
    self.originPoint = CGPointMake(point.x, point.y);
    self.translateX = 0;
    self.translateY = 0;
}


- (float)returnTranslateX:(GraphiView *)sender
{
    return self.translateX;
}

- (float)returnTranslateY:(GraphiView *)sender
{
    return self.translateY;
}

- (CGPoint)returnOriginPoint:(GraphiView *)sender
{
    return self.originPoint;
}

// Funcion que dibuja los ejes cartesianos
- (void)drawAxis:(GraphiView *)sender
           scale:(CGFloat)scale
            translateX:(CGFloat)translateX
            translateY:(CGFloat)translateY
            originPoint:(CGPoint)point

{
    CGRect rect = CGRectMake(0,0, 640, 960);
    //Multiplicamos el translate por la escala pero mantenemos el punto origen
    CGPoint punto = CGPointMake((translateX)*scale + point.x, (translateY)*scale + point.y);
    //CGFloat escala = 1;
    
    [AxesDrawer drawAxesInRect:rect originAtPoint:punto scale:scale];
}

- (NSMutableArray *)ecuationPoints
{
    return self.points;
}


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
