//
//  GraphiViewController.m
//  Calculator
//
//  Created by Marco Morales on 2/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphiViewController.h"
#import "GraphiView.h"
#import "AxesDrawer.h"
#import "CalculatorBrain.h"
#import "CalculatorProgramsTableViewController.h"

#define originX 160
#define originY 200

@interface GraphiViewController() <GraphiViewDataSource, CalculatorProgramsTableViewControllerDelegate>
@property (nonatomic, weak) IBOutlet GraphiView *graphiView;
@property (nonatomic) float translateX;
@property (nonatomic) float translateY;
@property (nonatomic) CGPoint originPoint;
@property (nonatomic, weak) IBOutlet UIToolbar *toolBar;

@property (nonatomic, strong) UIPopoverController *popoverController; // added after lecture to prevent multiple popovers


@end

@implementation GraphiViewController 

@synthesize graphiView = _graphiView;
@synthesize ecuationTextLabel = _ecuationTextLabel;
@synthesize ecuationText = _ecuationText;
@synthesize points=_points;
@synthesize translateX = _translateX;
@synthesize translateY = _translateY;
@synthesize originPoint = _originPoint;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;
@synthesize toolBar = _toolBar;
@synthesize popoverController;


// Save the user defaults of origin point
-(void)saveOriginPointToUserDefaults:(CGPoint)originPoint                        
{
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
	if (standardUserDefaults) {
		[standardUserDefaults setInteger:originPoint.x forKey:@"originPointX"];
		[standardUserDefaults setInteger:originPoint.y forKey:@"originPointY"];

		[standardUserDefaults synchronize];
	}
}

//Retrieves user defaults

-(CGPoint)retrieveOriginPointFromUserDefaults
{
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	CGPoint originPoint;
	
	if ([standardUserDefaults integerForKey:@"originPointX"] &&
        [standardUserDefaults integerForKey:@"originPointY"]) 
    {
		originPoint = CGPointMake([standardUserDefaults integerForKey:@"originPointX"],
                                  [standardUserDefaults integerForKey:@"originPointY"]);
        return originPoint;
    }
    else
    {
        return CGPointMake(originX, originY);
    }
}


- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    if (_splitViewBarButtonItem != splitViewBarButtonItem){
        NSMutableArray *toolbarItems = [self.toolBar.items mutableCopy];
        if (_splitViewBarButtonItem) [toolbarItems removeObject:_splitViewBarButtonItem];
        if (splitViewBarButtonItem) [toolbarItems insertObject:splitViewBarButtonItem atIndex:0];
        self.toolBar.items = toolbarItems;
        _splitViewBarButtonItem = splitViewBarButtonItem;
    }
}

- (CGPoint)originPoint
{
    if (!_originPoint.x || !_originPoint.y) {
        return CGPointMake(originX, originY); // don't allow zero point
    } else {
        return _originPoint;
    }
}

- (void)setEcuationText:(NSString *)ecuationText
{
    _ecuationText = ecuationText;
    NSLog(@"LO QUE SEA %@",ecuationText);
    //self.displayPrueba.text = @"LO QUE SEA";
    [self.graphiView setNeedsDisplay];
        
}

// Crear una funcion setPoints la cual reciba los puntos en un NSSset desde CalculatorViewcontroller
- (void)setPoints:(NSMutableArray *)points
{
    _points = points;
    
    [self.graphiView setNeedsDisplay];
}

- (void)setTranslateX:(float)translateX
{
    _translateX = translateX;
    
    [self.graphiView setNeedsDisplay];
}

- (void)setTranslateY:(float)translateY
{
    _translateY = translateY;
    
    [self.graphiView setNeedsDisplay];
}

- (void)setOriginPoint:(CGPoint)originPoint
{
    _originPoint = originPoint;
    
    [self.graphiView setNeedsDisplay];
}


- (void)setGraphiView:(GraphiView *)graphiView
{
    _graphiView = graphiView;
    [self.graphiView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphiView action:@selector(pinch:)]];
    
    // recognize a pan gesture and modify our Model
    [self.graphiView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePoint:)]];
    
    // recognize triple tap gesture
    UITapGestureRecognizer *tripleTap = 
    [[UITapGestureRecognizer alloc]
     initWithTarget:self action:@selector(handleTripleTap:)];
    [tripleTap setNumberOfTapsRequired:3];
    [self.graphiView addGestureRecognizer:tripleTap];
    
    self.graphiView.dataSource = self;
}

- (void)handlePoint:(UIPanGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        CGPoint translation = [gesture translationInView:self.graphiView];
        self.translateX -= translation.x;
        self.translateY -= translation.y;

        [gesture setTranslation:CGPointZero inView:self.graphiView];
    }
}

- (void)handleTripleTap:(UITapGestureRecognizer *)gesture
{
    CGPoint point = [gesture locationInView:self.graphiView];
        
    self.originPoint = CGPointMake(point.x, point.y);
    self.translateX = 0;
    self.translateY = 0;
    
    [self saveOriginPointToUserDefaults:self.originPoint];
}


- (float)returnTranslateX:(GraphiView *)sender
{
    return self.translateX;
}

- (float)returnTranslateY:(GraphiView *)sender
{
    return self.translateY;
}

- (CGPoint)returnOriginPoint:(GraphiView *)sender
{
    return [self retrieveOriginPointFromUserDefaults];//self.originPoint;
}

// Funcion que dibuja los ejes cartesianos
- (void)drawAxis:(GraphiView *)sender
           scale:(CGFloat)scale
            translateX:(CGFloat)translateX
            translateY:(CGFloat)translateY
            originPoint:(CGPoint)point

{
    CGRect rect = CGRectMake(0,0, 640, 960);
    //Multiplicamos el translate por la escala pero mantenemos el punto origen
    CGPoint punto = CGPointMake((translateX)*scale + point.x, (translateY)*scale + point.y);
    //CGFloat escala = 1;
    
    [AxesDrawer drawAxesInRect:rect originAtPoint:punto scale:scale];
}

- (NSMutableArray *)ecuationPoints
{
    return self.points;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

-(void)viewDidLoad
{
    self.ecuationTextLabel.text = self.ecuationText;
    [super viewDidLoad];
}

//- (void)viewDidUnload {
   // [self setDisplayPrueba:nil];
  //  [super viewDidUnload];
//}

#define FAVORITES_KEY_X @"CalculatorGraphViewController.FavoritesX"
#define FAVORITES_KEY_Y @"CalculatorGraphViewController.FavoritesY"
#define FAVORITES_KEY_E @"CalculatorGraphViewController.Ecuation"


- (IBAction)addToFavorites:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *favoritesX = [[defaults objectForKey:FAVORITES_KEY_X] mutableCopy];
    NSMutableArray *favoritesY = [[defaults objectForKey:FAVORITES_KEY_Y] mutableCopy];
    NSMutableArray *ecuationArray = [[defaults objectForKey:FAVORITES_KEY_E] mutableCopy];
    
    if (!favoritesX) favoritesX = [NSMutableArray array];
    if (!favoritesY) favoritesY = [NSMutableArray array];
    if (!ecuationArray) ecuationArray = [NSMutableArray array];
   

    NSMutableArray *favoritesXM = [[NSMutableArray alloc] init];
    NSMutableArray *favoritesYM = [[NSMutableArray alloc] init];
    
    //Dividimos los puntos en X e Y en dos arreglos
    for (int i=0;i<[self.points count];++i)
    {
        [favoritesXM addObject:[NSNumber numberWithFloat:[[self.points objectAtIndex:i] CGPointValue].x]];
        [favoritesYM addObject:[NSNumber numberWithFloat:[[self.points objectAtIndex:i] CGPointValue].y]];
    }
    

    [ecuationArray addObject:self.ecuationText];
    [favoritesX addObject:favoritesXM];
    [favoritesY addObject:favoritesYM];
    
    
    //NSLog(@"favorites %@", favoritesX);
    [defaults setObject:ecuationArray forKey:FAVORITES_KEY_E];
    [defaults setObject:favoritesX forKey:FAVORITES_KEY_X];
    [defaults setObject:favoritesY forKey:FAVORITES_KEY_Y];
    
    NSLog(@"GUARDAMOS DEFAULTS ");


    [defaults synchronize];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Favorite Graphs"]) {
        // this if statement added after lecture to prevent multiple popovers
        // appearing if the user keeps touching the Favorites button over and over
        // simply remove the last one we put up each time we segue to a new one
        if ([segue isKindOfClass:[UIStoryboardPopoverSegue class]]) {
            UIStoryboardPopoverSegue *popoverSegue = (UIStoryboardPopoverSegue *)segue;
            [self.popoverController dismissPopoverAnimated:YES];
            self.popoverController = popoverSegue.popoverController; // might want to be popover's delegate and self.popoverController = nil on dismiss?
        }
        NSArray *programsx = [[NSUserDefaults standardUserDefaults] objectForKey:FAVORITES_KEY_X];
        NSArray *programsy = [[NSUserDefaults standardUserDefaults] objectForKey:FAVORITES_KEY_Y];
        NSArray *ecuationArray = [[NSUserDefaults standardUserDefaults] objectForKey:FAVORITES_KEY_E];

        
        NSLog(@"ARRAY PROGRAMSX %@", programsx);
        [segue.destinationViewController setProgramsx:programsx];
        [segue.destinationViewController setProgramsy:programsy];
        [segue.destinationViewController setEcuationText:ecuationArray];

        [segue.destinationViewController setDelegate:self];
        
        NSLog(@"Termina la prearacion de la secuencia");
    }
}


- (void)calculatorProgramsTableViewController:(CalculatorProgramsTableViewController *)sender choseProgram:(NSArray *)program
{
    self.points = [program mutableCopy];
    
    // if you wanted to close the popover when a graph was selected
    // you could uncomment the following line
    // you'd probably want to set self.popoverController = nil after doing so
    [self.popoverController dismissPopoverAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES]; // added after lecture to support iPhone
}


// added after lecture to support deletion from the table
// deletes the given program from NSUserDefaults (including duplicates)
// then resets the Model of the sender

- (void)calculatorProgramsTableViewController:(CalculatorProgramsTableViewController *)sender
                               deletedRow:(int)row
{
    NSMutableArray *programsx = [[[NSUserDefaults standardUserDefaults] objectForKey:FAVORITES_KEY_X] mutableCopy];
    NSMutableArray *programsy = [[[NSUserDefaults standardUserDefaults] objectForKey:FAVORITES_KEY_Y]mutableCopy ];
    NSMutableArray *ecuationArray = [[[NSUserDefaults standardUserDefaults] objectForKey:FAVORITES_KEY_E] mutableCopy];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    /*for (id x in [defaults objectForKey:FAVORITES_KEY_X]) {
        if (![ isEqualToString:self.ecuationText]) {
            [favorites addObject:program];
        }
    }*/
    
    [programsx removeObjectAtIndex:row];
    [programsy removeObjectAtIndex:row];
    [ecuationArray removeObjectAtIndex:row];

    
    [defaults setObject:programsx forKey:FAVORITES_KEY_X];
    [defaults setObject:programsy forKey:FAVORITES_KEY_Y];
    [defaults setObject:ecuationArray forKey:FAVORITES_KEY_E];

    [defaults synchronize];
    sender.programsx = programsx;
    sender.programsy = programsy;
    sender.ecuationText = ecuationArray;
}


- (void)viewDidUnload {
    [self setEcuationTextLabel:nil];
    [super viewDidUnload];
}
@end
