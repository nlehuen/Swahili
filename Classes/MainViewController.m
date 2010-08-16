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
	_stack = [[NSMutableArray alloc] initWithCapacity:10];
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
	NSInteger tag = sender.tag;
	NSString* text = [stackView1.text retain];
	
	if(tag==-1) {
		NSRange dot = [text rangeOfString:@"."];
		if(dot.location == NSNotFound)
			stackView1.text = [text stringByAppendingFormat:@"."];
	}
	else {
		stackView1.text = [text stringByAppendingFormat:@"%d", sender.tag];
	}
	
	[text release];
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
	
	NSDecimalNumber* op1 = [[self pop] retain];
	NSDecimalNumber* op2 = [[self pop] retain];
	
	NSDecimalNumber* result;
	
	switch (sender.tag) {
		case 0:
			result = [op2 decimalNumberByAdding:op1];
			break;
		case 1:
			result = [op2 decimalNumberBySubtracting:op1];
			break;
		case 2:
			result = [op2 decimalNumberByMultiplyingBy:op1];
			break;
		case 3:
			result = [op2 decimalNumberByDividingBy:op1];
		default:
			break;
	}
	
	[op1 release];
	[op2 release];
	
	[_stack addObject:result];
	
	[self updateStackView];

}

-(void)updateStackView {
	NSUInteger count = [_stack count];
	
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	
	stackView2.text = count>0 ? [formatter stringFromNumber: [_stack objectAtIndex:(count-1)]] : @"";
	stackView3.text = count>1 ? [formatter stringFromNumber: [_stack objectAtIndex:(count-2)]] : @"";
	stackView4.text = count>2 ? [formatter stringFromNumber: [_stack objectAtIndex:(count-3)]] : @"";
	
	[formatter release];
}

-(void)push {
	NSString* text = [stackView1.text retain];
	if(text.length>0) {
		NSDecimalNumber* op = [[NSDecimalNumber alloc] initWithString:text];
		[_stack addObject:op];
		[op release];
		stackView1.text = @"";
	}
	[text release];
}

- (NSDecimalNumber*)pop {
	if(_stack.count == 0) return [NSDecimalNumber zero];
	NSDecimalNumber* result = [[_stack lastObject] retain];
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
