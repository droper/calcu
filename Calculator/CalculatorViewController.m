//
//  CalculatorViewController.m
//  Calculator
//
//  Created by soulse on 1/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController()

- (void)appendStackDisplay:(NSString *)text;

@property (nonatomic) BOOL thereIsAFloatPoint;
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic, strong) NSDictionary *dictionaryOfVariables;

@end

@implementation CalculatorViewController

@synthesize display;
@synthesize stackDisplay;
@synthesize thereIsAFloatPoint;
@synthesize userIsInTheMiddleOfEnteringANumber;
@synthesize dictionaryOfVariables = _dictionaryOfVariables;
@synthesize brain = _brain;

- (NSDictionary *) dictionaryOfVariables
{
    if (!_dictionaryOfVariables) {
        NSLog(@"inicializo");
        _dictionaryOfVariables = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 [NSNumber numberWithDouble:(double)3], @"x", 
                                 [NSNumber numberWithDouble:(double)2], @"y", 
                                 [NSNumber numberWithDouble:(double)1], @"z", nil];
    }
    return _dictionaryOfVariables;
}

- (CalculatorBrain *)brain
{
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}


- (void)appendStackDisplay:(NSString *)text
{
    //self.stackDisplay.text = [self.stackDisplay.text 
    //                        stringByAppendingString:[@" " stringByAppendingString:text]];
    self.stackDisplay.text = text;

}
    
- (IBAction)clearPresed:(id)sender {
    self.thereIsAFloatPoint = NO;
    self.userIsInTheMiddleOfEnteringANumber = NO;
    
    self.display.text = @"0";    
    self.stackDisplay.text = @"";
    [self.brain emptyStack];
}

- (IBAction)digitPressed:(UIButton *)sender 
{
    NSString *digit = [sender currentTitle];
    
    //empece aqui
    NSRange range = [digit rangeOfString:@"."];
    
    if (range.location != NSNotFound) {
        if (self.thereIsAFloatPoint) {
            return;	
        }
        else {
            self.thereIsAFloatPoint = YES	;
        
        }
    }
    //termine aqui
    
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)enterPressed 
{    
    [self.brain pushOperand:[self.display.text doubleValue]];
    
    //[self appendStackDisplay:self.display.text];
    [self appendStackDisplay:[self.brain stackDescription]];
    
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.thereIsAFloatPoint = NO;
}

- (IBAction)operarionPressed:(id)sender 
{
    
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    else {
        //[self appendStackDisplay:self.display.text];
    }
    
    NSString *operation = [sender currentTitle];
    
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    
    //[self appendStackDisplay:operation];
    [self appendStackDisplay:[self.brain stackDescription]];

}

- (IBAction)variablePressed:(UIButton *)sender {
   
    NSString *variable = [sender currentTitle];

    self.display.text = variable;
    [self enterPressed];
    
    
    [self.brain performVariable:variable usingVariableValues:self.dictionaryOfVariables];
}



- (void)viewDidUnload {
    [self setStackDisplay:nil];
    [super viewDidUnload];
}
@end