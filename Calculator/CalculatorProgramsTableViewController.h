//
//  CalculatorProgramsTableViewController.h
//  Calculator
//
//  Created by Marco Morales on 3/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CalculatorProgramsTableViewController;

@protocol CalculatorProgramsTableViewControllerDelegate

@optional
- (void)calculatorProgramsTableViewController:(CalculatorProgramsTableViewController *)sender choseProgram:(NSArray *)program;
@end

@interface CalculatorProgramsTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *programsx; // of CalculatorBrain programs
@property (nonatomic, strong) NSArray *programsy; // of CalculatorBrain programs
@property (nonatomic, strong) NSArray *ecuationText; //ecuation description

@property (nonatomic, weak) id <CalculatorProgramsTableViewControllerDelegate> delegate;

@end
