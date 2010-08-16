//
//  MainViewController.m
//  Swahili
//
//  Created by Nicolas LEHUEN on 15/08/10.
//  Copyright CRM Company Group 2010. All rights reserved.
//

#import "MainViewController.h"


@implementation MainViewController

@synthesize stackView1,stackView2,stackView3,stackView4;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	_stack = [[NSMutableArray arrayWithCapacity:100] retain];
	[self updateStackView];
}


- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
    
	[self dismissModalViewControllerAnimated:YES];
}


- (IBAction)showInfo:(id)sender {    
	
	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (IBAction)numberHit:(UIButton*)sender {
	stackView1.text = [stackView1.text stringByAppendingFormat:@"%d", sender.tag];
}

- (IBAction)controlHit:(UIButton*)sender {
	NSString* text;
	
	switch(sender.tag) {
		case 0:
			[self push];
			[self updateStackView];
			break;
		
		case 1:
			text = [stackView1.text retain];
			NSUInteger length = text.length;
			if(length > 0) {
				stackView1.text = [text substringToIndex:(length-1)];
			}
			[text release];
			break;
			
		case 2:
			[self pop];
			[self updateStackView];
			break;
	}
}

- (IBAction)operationHit:(UIButton*)sender {
	[self push];
	
	double op1 = [self pop];
	double op2 = [self pop];
	
	double result;
	
	switch (sender.tag) {
		case 0:
		    result = op2 + op1;
			break;
		case 1:
			result = op2 - op1;
			break;
		case 2:
			result = op2 * op1;
			break;
		case 3:
			result = op2 / op1;
		default:
			break;
	}
	
	NSString *resultString = [[NSString alloc] initWithFormat:@"%f",result];
	[_stack addObject:resultString];
	[resultString release];
	
	[self updateStackView];
}

-(void)updateStackView {
	NSUInteger count = [_stack count];
	
	stackView2.text = count>0 ? [_stack objectAtIndex:(count-1)] : @"0";
	stackView3.text = count>1 ? [_stack objectAtIndex:(count-2)] : @"0";
	stackView4.text = count>2 ? [_stack objectAtIndex:(count-3)] : @"0";
}

-(void)push {
	if(stackView1.text.length == 0) return;
	[_stack addObject:stackView1.text];
	stackView1.text = @"";
}

- (double)pop {
	if([_stack count]==0) return 0.0;
	double result = [[_stack lastObject] doubleValue];
	[_stack removeLastObject];
	return result;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void)dealloc {
	[_stack release];
    [super dealloc];
}


@end
