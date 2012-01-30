//
//  CalculatorBrain.m
//  Calculator
//
//  Created by soulse on 1/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"
#define PI 3.1416

static NSDictionary *dictionaryOfVariables = nil;

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *operandStack;

//@property (nonatomic, strong) 	
@end


@implementation CalculatorBrain

//@synthesize dictionaryOfVariables= _dictionaryOfVariables;
@synthesize operandStack = _operandStack;


- (NSMutableArray *)operandStack
{
    if (!_operandStack) {
        _operandStack = [[NSMutableArray alloc] init];
    }
    return _operandStack;
}

+ (void) initialize
{
    if (!dictionaryOfVariables) {
        dictionaryOfVariables = [[NSDictionary alloc] initWithObjectsAndKeys:
            [NSNumber numberWithDouble:(double)0], @"x", 
            [NSNumber numberWithDouble:(double)0], @"y", 
            [NSNumber numberWithDouble:(double)0], @"z", nil];
    }
}


- (id)program
{
    return [self.operandStack copy];
}


+ (BOOL)isOperation:(NSString *) operation
{
    NSSet *operations;
    operations = [NSSet setWithObjects:@"+",@"-",@"*",@"/",@"pi", nil];
    
    if ([operations containsObject:operation])
    {
        return TRUE;
    } else return FALSE;
}

+ (BOOL)isFunction:(NSString *) function
{
    NSSet *functions;
    functions = [NSSet setWithObjects:@"sqrt",@"cos",@"sin", nil];
    
    if ([functions containsObject:function])
    {
        return TRUE;
    } else return FALSE;
}

+ (BOOL)isNumber:(NSString *) operation
{
    NSSet *operations;
    operations = [NSSet setWithObjects:@"+",@"-",@"*",@"/",@"sqrt",@"cos",@"sin",@"pi", nil];
    
    if (![operations containsObject:operation])
    {
        return TRUE;
    } else return FALSE;
}

+ (NSString *)descriptionOfProgram:(id)program	
{
    BOOL oper = NO;    // Variable booleana que indica si es el primer o segundo operando
    NSMutableArray *stack;
    NSString *res=@"";
    NSMutableArray *temp;
    temp = [[NSMutableArray alloc] init];
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    
    while ([stack count] > 0){
        if ([self isOperation:stack.lastObject]){
            // Agregamos a temp el operador y lo elimionamos del stack
            [temp addObject:[stack lastObject]];
            [stack removeLastObject];
            oper = YES; // operando 2

        } else if ([self isNumber:stack.lastObject]){
            if (oper == YES) {
                res = [NSString stringWithFormat:@"%@)%@", [[stack lastObject] stringValue], res];
            } else {
                res = [NSString stringWithFormat:@"(%@%@", [[stack lastObject] stringValue], res];
            }
            [stack removeLastObject];
            // Si el elemento en temporal es operador lo agregamos al resultado

            while ([temp lastObject] == @"(") {
                [temp removeLastObject];
                res = [NSString stringWithFormat:@"(%@", res];
            }
            
            if ([self isOperation:[temp lastObject]]){
                res = [NSString stringWithFormat:@"%@	%@", [temp lastObject], res];
                [temp removeLastObject];
            
            // falta arreglar function
            } else if ([self isFunction:[temp lastObject]]){
                res = [NSString stringWithFormat:@"%@(%@", [temp lastObject], res];
                [temp removeLastObject];
                while ([temp lastObject] == @"(") {
                    [temp removeLastObject];
                    res = [NSString stringWithFormat:@"(%@", res];
                }
            } 
            
            if ([self isOperation:stack.lastObject] && oper == YES) {
                //res = [NSString stringWithFormat:@")%@",res];
                //[temp addObject:@"("];
            } 

            oper = NO;
            
        // Si son funciones las agregamos
        } else if ([self isFunction:stack.lastObject]){
            //res = [res stringByAppendingString:@")"];
            res = [NSString stringWithFormat:@")%@", res];
            [temp addObject:[stack lastObject]];
            [stack removeLastObject];            
            
        }
    }
    return res;
}

- (NSString *)stackDescription
{
    return [[self class] descriptionOfProgram:self.operandStack];
}

- (void)pushOperand:(double)operand
{
    [self.operandStack addObject:[NSNumber numberWithDouble:operand]];
}


- (void)emptyStack
{
    [self.operandStack removeAllObjects];
}

- (double)performOperation:(NSString *)operation
{

    [self.operandStack addObject:operation];
    return [[self class] runProgram:self.program];
    
}

+ (double)popOperandOffProgramStack:(NSMutableArray *)stack
{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffProgramStack:stack] +
            [self popOperandOffProgramStack:stack];
        } else if ([@"*" isEqualToString:operation]) {
            result = [self popOperandOffProgramStack:stack] *
            [self popOperandOffProgramStack:stack];
        } else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffProgramStack:stack];
            result = [self popOperandOffProgramStack:stack] - subtrahend;
        } else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffProgramStack:stack];
            if (divisor) result = [self popOperandOffProgramStack:stack] / divisor;
        } else if ([operation isEqualToString:@"sin"]) {
            result = sin([self popOperandOffProgramStack:stack]);
        } else if ([operation isEqualToString:@"cos"]) {
            result = cos([self popOperandOffProgramStack:stack]);
        } else if ([operation isEqualToString:@"sqrt"]) {
            result = sqrt([self popOperandOffProgramStack:stack]);
        } else if ([operation isEqualToString:@"pi"]) {
            result = [self popOperandOffProgramStack:stack];
            [stack addObject:[NSNumber numberWithDouble:result]];
            [stack addObject:[NSNumber numberWithDouble:PI]];
        }    
    }
    
    return result;
}

+ (double)runProgram:(id)program
{
    NSMutableArray *stack;
    
    
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffProgramStack:stack];
}

+ (double)runProgram:(id)program
    usingVariableValues:(NSDictionary *)variableValues
{
    NSMutableArray *stack;
    
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    
    //Iteramos la pila por su indice
    for (int i=0;i<[stack count];i++){
        //Si el elemento de la pila es una llave del diccionario de variables
        //reemplazamos ese elemento por su valor en el diccionario de variables
        if ([variableValues objectForKey:[stack objectAtIndex:i]]){
            [stack replaceObjectAtIndex:i withObject:[variableValues objectForKey:[stack objectAtIndex:i]]];
        }
    }
    
    return [self popOperandOffProgramStack:stack];
}


+ (NSSet *)variablesUsedInProgram:(id)program
{
    //iterar la pila 
    //comprobar si hay una variable en la pila
    //y agregarla a un set
    
    NSMutableSet *variablesInProgram;
    
    //iteramos la pila
    for (int i=0;i<[program count];i++){
        // Si el elemento de la pila es una llave del diccionario de variables
        // entonces es una variable y la agregamos al NSMutableSet
        if ([dictionaryOfVariables objectForKey:[program objectAtIndex:i]]){
            [variablesInProgram addObject:[program objectAtIndex:i]];
       }
    }
    
    if ([variablesInProgram count] > 0){
        return variablesInProgram;
    }
    else {
        return nil;
    }
    
}

@end
