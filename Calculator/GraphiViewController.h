//
//  GraphiViewController.h
//  Calculator
//
//  Created by Marco Morales on 2/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphiView.h"
#import "SplitViewBarButtonItemPresenter.h"

@interface GraphiViewController : UIViewController <SplitViewBarButtonItemPresenter>

@property (weak, nonatomic) IBOutlet UILabel *ecuationTextLabel;

@property (strong, nonatomic) NSString *ecuationText;
@property (nonatomic, strong) NSMutableArray *points;

@end
