//
//  CalculatorProgramsTableViewController.h
//  Calculator
//
//  Created by Marco Morales on 3/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CalculatorProgramsTableViewController;

@protocol CalculatorProgramsTableViewControllerDelegate <NSObject> // added <NSObject> after lecture so we can do respondsToSelector: on the delegate

@optional
- (void)calculatorProgramsTableViewController:(CalculatorProgramsTableViewController *)sender choseProgram:(NSArray *)program;
- (void)calculatorProgramsTableViewController:(CalculatorProgramsTableViewController *)sender
                               deletedRow:(int)row; // added after lecture to support deleting from table
@end

@interface CalculatorProgramsTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *programsx; // of CalculatorBrain programs
@property (nonatomic, strong) NSArray *programsy; // of CalculatorBrain programs
@property (nonatomic, strong) NSArray *ecuationText; //ecuation description

@property (nonatomic, weak) id <CalculatorProgramsTableViewControllerDelegate> delegate;

@end
