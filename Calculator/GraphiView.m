//
//  GraphiView.m
//  Calculator
//
//  Created by Marco Morales on 2/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphiView.h"


@implementation GraphiView

@synthesize dataSource = _dataSource;
@synthesize scale = _scale;

#define DEFAULT_SCALE 0.5

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
    [self.dataSource dibujar:self ];
}


@end
