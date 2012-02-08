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

- (void)dibujar:(GraphiView *)sender contexto:(CGContextRef)context;

@end

@interface GraphiView : UIView

@property (nonatomic) CGFloat scale;

@property (nonatomic, weak) IBOutlet id  <GraphiViewDataSource> dataSource;


@end
