//
//  CalculatorProgramsTableViewController.m
//  Calculator
//
//  Created by Marco Morales on 3/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorProgramsTableViewController.h"
#import "CalculatorBrain.h"


@implementation CalculatorProgramsTableViewController


@synthesize programsx = _programsx;
@synthesize programsy = _programsy;
@synthesize ecuationText = _ecuationText;
@synthesize delegate = _delegate;


- (void)setProgramsx:(NSArray *)programsx
{
    _programsx = programsx;
    [self.tableView reloadData];
}

- (void)setProgramsy:(NSArray *)programsy
{
    _programsy = programsy;
    //NSLog(@"NUMERO DE ELEMENTOS %@",[programsy count]);
    [self.tableView reloadData];
}


- (void)setEcuationtext:(NSArray *)ecuationText
{
    _ecuationText = ecuationText;
    [self.tableView reloadData];
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.programsx count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Calculator Program Description";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    //id program = [self.programs objectAtIndex:indexPath.row];
    //cell.textLabel.text = [@"y = " stringByAppendingString:[CalculatorBrain descriptionOfProgram:program]];
    cell.textLabel.text = [@"y = " stringByAppendingString:[self.ecuationText objectAtIndex:indexPath.row]];

    return cell;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"ROW %i",indexPath.row);
        [self.delegate calculatorProgramsTableViewController:self deletedRow:indexPath.row];
    }   
}

// added after lecture
// don't allow deletion if the delegate does not support it too!

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.delegate respondsToSelector:@selector(calculatorProgramsTableViewController: deletedRow:)];
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id programx = [self.programsx objectAtIndex:indexPath.row];
    id programy = [self.programsy objectAtIndex:indexPath.row];
    
    NSMutableArray *points = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [programx count]; i++)
    {       
        [points addObject:[NSValue valueWithCGPoint: CGPointMake([(NSNumber *)[programx objectAtIndex:i] floatValue],
                                                                 [(NSNumber *)[programy objectAtIndex:i] floatValue])]];
    }
    
    [self.delegate calculatorProgramsTableViewController:self choseProgram:points];
}

@end
