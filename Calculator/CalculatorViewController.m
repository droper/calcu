//
//  CalculatorViewController.m
//  Calculator
//
//  Created by soulse on 1/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "GraphiViewController.h"
#import "CalculatorBrain.h"
#import "SplitViewBarButtonItemPresenter.h"


@interface CalculatorViewController()

- (void)appendStackDisplay:(NSString *)text;

@property (nonatomic) BOOL thereIsAFloatPoint;
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic, strong) NSDictionary *dictionaryOfVariables;
@property (nonatomic) int prueba;

@end

@implementation CalculatorViewController

@synthesize display;
@synthesize stackDisplay;
@synthesize variablesDisplay;
@synthesize thereIsAFloatPoint;
@synthesize userIsInTheMiddleOfEnteringANumber;
@synthesize dictionaryOfVariables = _dictionaryOfVariables;
@synthesize brain = _brain;
@synthesize prueba = _prueba;


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


// Funcion que devuelve los pun tos necessarios para dibujar la ecuación en GraphiView
- (NSMutableArray *)ecuationPoints
{
    NSMutableArray *points = [[NSMutableArray alloc] init];
    
    for (float x=-160; x<400;x=x+1)
    {
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:                                     
                              [NSNumber numberWithDouble:(double)x], @"x", nil];
                
        double y = [self.brain executeProgram:dict];
        
        [points addObject:[NSValue valueWithCGPoint: CGPointMake(x, y)]];
    }
    
    return points;
}

- (void)updateUI
{
    // Actuializamos el display recalculando el stack
    double result = [self.brain executeProgram:self.dictionaryOfVariables];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    
    //Actualizamos la pantalla donde se muestra el stack
    [self appendStackDisplay:[self.brain stackDescription]];
    
    // Se muestran las variables en variablesDisplay
    self.variablesDisplay.text = [self.brain variablesDescription:self.dictionaryOfVariables];
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
    
    double result = [self.brain performOperation:operation usingVariableValues:self.dictionaryOfVariables];
    
    self.display.text = [NSString stringWithFormat:@"%g", result];
    
    //[self appendStackDisplay:operation];
    [self appendStackDisplay:[self.brain stackDescription]];

}

- (IBAction)variablePressed:(UIButton *)sender {
   
    NSString *variable = [sender currentTitle];
    
    self.display.text = variable;
    
    //[self.brain pushOperand:[[self.dictionaryOfVariables objectForKey:variable] doubleValue]];
    [self.brain pushVariable:variable];
    
    
    //[self.brain performVariable:variable usingVariableValues:self.dictionaryOfVariables];
    

    NSLog(@"este es una variable %@",variable);
    
    [self appendStackDisplay:[self.brain stackDescription]];
    

    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.thereIsAFloatPoint = NO;
    
    // Se muestran las variables en variablesDisplay
    self.variablesDisplay.text = [self.brain variablesDescription:self.dictionaryOfVariables];
}

- (IBAction)testPressed:(UIButton *)sender {
    
    NSString *caption = [sender currentTitle];
    
    if ([caption isEqualToString:@"Test 1"]){
        self.dictionaryOfVariables = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  [NSNumber numberWithDouble:(double)5], @"x", 
                                  [NSNumber numberWithDouble:(double)4], @"y", 
                                  [NSNumber numberWithDouble:(double)3], @"z", nil];

    } else if ([caption isEqualToString:@"Test 2"]){
        self.dictionaryOfVariables = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      [NSNumber numberWithDouble:(double)-5], @"x", 
                                      [NSNumber numberWithDouble:(double)-8], @"y", 
                                      [NSNumber numberWithDouble:(double)0], @"z", nil];
        
    } else {
        self.dictionaryOfVariables = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      nil, @"x", 
                                      nil, @"y", 
                                      nil, @"z", nil];
        
    }
    
    // Se muestran las variables en variablesDisplay
    [self updateUI];

}


- (IBAction)undoPressed:(id)sender {
    // Si el usuario esta ingresando un numero borra los numeros hasta que 
    // termina y ejecuta el programa de nuevo
    if (self.userIsInTheMiddleOfEnteringANumber){
        if ([self.display.text length] > 0){
            self.display.text = [self.display.text substringToIndex:[self.display.text length]-1];
        }else {
            double result = [self.brain executeProgram:self.dictionaryOfVariables];
            self.display.text = [NSString stringWithFormat:@"%g", result];
        }
    } else {
        //Si el usuario no esta ingresando numeros, elimina el ultimo item del stack
        [self.brain popStack];
        [self updateUI];
    }
}

- (GraphiViewController *)splitViewGraphiviewcontroller
{
    id gvc = [self.splitViewController.viewControllers lastObject];
    if (![gvc isKindOfClass:[GraphiViewController class]])
    {
        gvc = nil;
    }
    return gvc;
}

- (IBAction)graphPressed:(id)sender {
    if([self splitViewGraphiviewcontroller])
    {
        [self splitViewGraphiviewcontroller].points =  [self ecuationPoints];
        [self splitViewGraphiviewcontroller].ecuationText = [self.brain programDescription];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Graphi"]) {
        [segue.destinationViewController setPoints:[self ecuationPoints]];
        [segue.destinationViewController setEcuationText:[self.brain programDescription]];
        }
}

// Permite que Calculator se vea siempre encima
- (void)awakeFromNib
{
    self.title = @"Calculator";
    [super awakeFromNib];
    self.splitViewController.delegate = self;
}

- (id <SplitViewBarButtonItemPresenter>)splitViewBarButtonItemPresenter
{
    id detailVC = [self.splitViewController.viewControllers lastObject];
    if (![detailVC conformsToProtocol:@protocol(SplitViewBarButtonItemPresenter)])
    {
        detailVC = nil;
    }
    return detailVC;
}

- (BOOL)splitViewController:(UISplitViewController *)svc 
   shouldHideViewController:(UIViewController *)vc 
              inOrientation:(UIInterfaceOrientation)orientation
{
    return [self splitViewBarButtonItemPresenter] ? UIInterfaceOrientationIsPortrait(orientation) : NO;
}

- (void)splitViewController:(UISplitViewController *)svc 
     willHideViewController:(UIViewController *)aViewController 
          withBarButtonItem:(UIBarButtonItem *)barButtonItem 
       forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = self.title;
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = barButtonItem;
}

- (void)splitViewController:(UISplitViewController *)svc 
     willShowViewController:(UIViewController *)aViewController 
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = nil;

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}



- (void)viewDidUnload {
    [self setStackDisplay:nil];
    [self setVariablesDisplay:nil];
    [self setVariablesDisplay:nil];
    [super viewDidUnload];
}
@end