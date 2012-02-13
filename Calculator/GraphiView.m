//
//  GraphiView.m
//  Calculator
//
//  Created by Marco Morales on 2/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphiView.h"

@interface GraphiView()

@property (nonatomic, strong) NSMutableArray *points;
    
@end

@implementation GraphiView

@synthesize dataSource = _dataSource;
@synthesize scale = _scale;
@synthesize points = _points;

- (NSMutableArray *)points
{
    if (!_points) {
        _points = [[NSMutableArray alloc] initWithObjects:[NSValue valueWithCGPoint: CGPointMake(0, 0)], [NSValue valueWithCGPoint:CGPointMake(10, 10)], [NSValue valueWithCGPoint:CGPointMake(50, 50)], [NSValue valueWithCGPoint:CGPointMake(80, 120)], nil];
    }
    return _points;
}

#define DEFAULT_SCALE 0.5


// Crear funcion que grafique en una curva los puntos de un NSSet

- (void)drawEcuation:(CGContextRef)context
              ecuationPoints:(NSMutableArray *)points
{
    //CGContextRef context = UIGraphicsGetCurrentContext();
    
	//UIGraphicsPushContext(context);
    
    //CGContextBeginPath(context);
    
    for (int i = 0; i < [points count]-1; i++) 
    {   
        CGContextMoveToPoint(context, 
                             [(NSValue *)[points objectAtIndex:i] CGPointValue].x, 
                             [(NSValue *)[points objectAtIndex:i] CGPointValue].y);
        CGContextAddLineToPoint(context, 
                             [(NSValue *)[points objectAtIndex:i+1] CGPointValue].x, 
                             [(NSValue *)[points objectAtIndex:i+1] CGPointValue].y);
    }
    
	CGContextStrokePath(context);
    
    UIGraphicsPopContext();
}

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

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    /*CGPoint midPoint; // center of our bounds in our coordinate system
    midPoint.x = self.bounds.origin.x + self.bounds.size.width/2;
    midPoint.y = self.bounds.origin.y + self.bounds.size.height/2;
    
    CGFloat size = self.bounds.size.width / 2;
    if (self.bounds.size.height < self.bounds.size.width) size = self.bounds.size.height / 2;
    size *= self.scale; // scale is percentage of full view size
    
    CGContextSetLineWidth(context, 5.0);
    [[UIColor greenColor] setStroke];
    

    
#define EYE_H 0.35
#define EYE_V 0.35
#define EYE_RADIUS 0.10
    
    CGPoint eyePoint;
    eyePoint.x = midPoint.x - size * EYE_H;
    eyePoint.y = midPoint.y - size * EYE_V;
    

    
#define MOUTH_H 0.45
#define MOUTH_V 0.40
#define MOUTH_SMILE 0.25
    
    CGPoint mouthStart;
    mouthStart.x = midPoint.x - MOUTH_H * size;
    mouthStart.y = midPoint.y + MOUTH_V * size;
    CGPoint mouthEnd = mouthStart;
    mouthEnd.x += MOUTH_H * size * 2;
    CGPoint mouthCP1 = mouthStart;
    mouthCP1.x += MOUTH_H * size * 2/3;
    CGPoint mouthCP2 = mouthEnd;
    mouthCP2.x -= MOUTH_H * size * 2/3;*/
    
   /* float smile = [self.dataSource smileForFaceView:self]; // delegate our View's data
    if (smile < -1) smile = -1;
    if (smile > 1) smile = 1;
    
    CGFloat smileOffset = MOUTH_SMILE * size * smile;
    mouthCP1.y += smileOffset;
    mouthCP2.y += smileOffset;
    */
    
    //CGContextBeginPath(context);
    //CGContextMoveToPoint(context, mouthStart.x, mouthStart.y);
    //CGContextAddCurveToPoint(context, mouthCP1.x, mouthCP1.y, mouthCP2.x, mouthCP2.y, mouthEnd.x, mouthEnd.y); // bezier curve
    //CGContextMoveToPoint(context, 10, 50);
    //CGContextAddCurveToPoint(context, 10, 100, 10, 100, 10, 200); // 
   // CGContextStrokePath(context);
    //NSLog(@"EL valor de self.datasource %@",[self.dataSource ]  );
    [self.dataSource drawAxis:self];
    
    // Llamar funcion drawEcuation que dibuje los puntos mde un aray.
    [self drawEcuation:context ecuationPoints:self.points];
}


@end
