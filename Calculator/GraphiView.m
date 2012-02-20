//
//  GraphiView.m
//  Calculator
//
//  Created by Marco Morales on 2/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphiView.h"

@interface GraphiView()


    
@end

@implementation GraphiView

@synthesize dataSource = _dataSource;
@synthesize scale = _scale;


#define DEFAULT_SCALE 1

#define originX 160
#define originY 200


- (CGFloat)scale
{
    if (!_scale) {
        return DEFAULT_SCALE; // don't allow zero scale
    } else {
        return _scale;
    }
}


- (void)setScale:(CGFloat)scale
{
    if (scale != _scale) {
        _scale = scale;
        [self setNeedsDisplay]; // any time our scale changes, call for redraw
    }
}


- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        self.scale *= gesture.scale; // adjust our scale
        gesture.scale = 1;           // reset gestures scale to 1 (so future changes are incremental, not cumulative)
    }
}

- (void)setup
{
    self.contentMode = UIViewContentModeRedraw; // if our bounds changes, redraw ourselves
}

- (void)awakeFromNib
{
    [self setup]; // get initialized when we come out of a storyboard
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup]; // get initialized if someone uses alloc/initWithFrame: to create us
    }
    return self;
}


- (void)drawEcuation:(CGContextRef)context
      ecuationPoints:(NSMutableArray *)points
                size:(CGFloat)size
                translateX:(CGFloat)translateX
          translateY:(CGFloat)translateY
         originPoint:(CGPoint)originPoint
{
    
    UIGraphicsPushContext(context);
    CGContextBeginPath(context);
    
    for (int i = 0; i < [points count]-1; i=i+1) 
    {   
        CGContextMoveToPoint(context, 
                             ([(NSValue *)[points objectAtIndex:i] CGPointValue].x+originPoint.x+translateX)*size, 
                             ([(NSValue *)[points objectAtIndex:i] CGPointValue].y+originPoint.y+translateY)*size);
        
        CGContextAddLineToPoint(context,
                                ([(NSValue *)[points objectAtIndex:i+1] CGPointValue].x+originPoint.x+translateX)*size, 
                                ([(NSValue *)[points objectAtIndex:i+1] CGPointValue].y+originPoint.y+translateY)*size);
    }
    
	CGContextStrokePath(context);
    
    UIGraphicsPopContext();
}



- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSLog(@"ESTE ES EL SCALE %f",self.scale);

    float translateX = [self.dataSource returnTranslateX:self];
    float translateY = [self.dataSource returnTranslateY:self];
    
    NSLog(@"ESTE ES EL TRANSLATE %f",translateX);
    
    CGPoint originPoint = [self.dataSource returnOriginPoint:self];
    
    [self.dataSource drawAxis:self scale:self.scale translateX:translateX translateY:translateY originPoint:originPoint];
    [self drawEcuation:context ecuationPoints:[self.dataSource ecuationPoints] size:self.scale translateX:translateX translateY:translateY originPoint:originPoint];
}


@end
