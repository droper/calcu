//
//  CalculatorBrain.h
//  Calculator
//
//  Created by soulse on 1/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(double)operand;
- (double)performOperation:(NSString *)operation;
- (double)performVariable:(NSString *)variable
      usingVariableValues:(NSDictionary *)variablesDictionary;

- (void)emptyStack;
- (NSString *)stackDescription;

@property (nonatomic, readonly) id program;


+ (NSString *)descriptionOfProgram:(id)program;
+ (double)runProgram:(id)program;
+ (double)runProgram:(id)program
    usingVariableValues:(NSDictionary *)variableValues;
+ (NSSet *)variablesUsedInProgram:(id)program
        usingVariableValues:(NSDictionary *)variableValues;
;



@end
