//
//  GraphiView.h
//  Calculator
//
//  Created by Marco Morales on 2/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GraphiView;

@protocol GraphiViewDataSource

- (void)drawAxis:(GraphiView *)sender
           scale:(CGFloat)scale
            translateX:(CGFloat)translateX
            translateY:(CGFloat)translateY
     originPoint:(CGPoint)point;
- (NSMutableArray *)ecuationPoints;
- (float)returnTranslateX:(GraphiView *)sender;
- (float)returnTranslateY:(GraphiView *)sender;
- (CGPoint)returnOriginPoint:(GraphiView *)sender;



@end

@interface GraphiView : UIView

@property (nonatomic) CGFloat scale;

- (void)pinch:(UIPinchGestureRecognizer *)gesture;

@property (nonatomic, weak) IBOutlet id  <GraphiViewDataSource> dataSource;


@end
