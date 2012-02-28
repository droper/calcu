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

// Save the user defaults of origin point
-(void)saveScaleToUserDefaults:(int)scale                        
{
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
	if (standardUserDefaults) {
		[standardUserDefaults setInteger:scale forKey:@"scale"];
        
		[standardUserDefaults synchronize];
	}
}

//Retrieves user defaults

-(int)retrieveScaleFromUserDefaults
{
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	int scale;
	
	if ([standardUserDefaults integerForKey:@"scale"]) 
		scale = [standardUserDefaults integerForKey:@"scale"];
    else 
        scale = DEFAULT_SCALE;
    
	return scale;
}


- (void)setScale:(CGFloat)scale
{
    if (scale != _scale) {
        _scale = scale;
        NSLog(@"SE ASIGNA ESCALA");
        [self setNeedsDisplay]; // any time our scale changes, call for redraw
    }
}


- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        self.scale *= gesture.scale; // adjust our scale
        gesture.scale = 1;           // reset gestures scale to 1 (so future changes are incremental, not cumulative)
        [self saveScaleToUserDefaults:self.scale];
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
    
    if ([points count] > 0)
    {
    
        for (int i = 0; i < [points count]-1; i=i+1) 
        {           
            CGContextMoveToPoint(context, 
                             ([(NSValue *)[points objectAtIndex:i] CGPointValue].x+translateX)*size+originPoint.x, 
                             ([(NSValue *)[points objectAtIndex:i] CGPointValue].y+translateY)*size+originPoint.y);
        
            CGContextAddLineToPoint(context,
                                ([(NSValue *)[points objectAtIndex:i+1] CGPointValue].x+translateX)*size+originPoint.x, 
                                ([(NSValue *)[points objectAtIndex:i+1] CGPointValue].y+translateY)*size+originPoint.y);
        }
    }
    
	CGContextStrokePath(context);
    
    UIGraphicsPopContext();
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSLog(@"ESTE ES EL SCALE %f",self.scale);

    int scale = [self retrieveScaleFromUserDefaults];

    float translateX = [self.dataSource returnTranslateX:self];
    float translateY = [self.dataSource returnTranslateY:self];
    
    CGPoint originPoint = [self.dataSource returnOriginPoint:self];
    
    [self.dataSource drawAxis:self scale:scale translateX:translateX translateY:translateY originPoint:originPoint];
    [self drawEcuation:context ecuationPoints:[self.dataSource ecuationPoints] size:scale translateX:translateX translateY:translateY originPoint:originPoint];
    
    NSLog(@"Ubicación del punto x%f e y %f",originPoint.x,originPoint.y);
    NSLog(@"ESTE ES EL TRANSLATE X %f",translateX);
    NSLog(@"ESTE ES EL TRANSLATE Y %f",translateY);

}


@end
