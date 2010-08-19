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
    self.stackView1 = nil;
    self.stackView2 = nil;
    self.stackView3 = nil;
    self.stackView4 = nil;
}

- (IBAction)numberHit:(UIButton*)sender {
    NSInteger tag = sender.tag;
    NSString* text = [stackView1.text retain];
    
    if(tag==-1) {
        NSRange dot = [text rangeOfString:@"."];
        if(dot.location == NSNotFound) {
            stackView1.text = [text stringByAppendingFormat:@"."];
        }
    }
    else {
        stackView1.text = [text stringByAppendingFormat:@"%d", sender.tag];
    }
    
    [text release];
}

- (IBAction)controlHit:(UIButton*)sender {
    NSString* text;
    NSUInteger count;
    
    switch(sender.tag) {
        case 0: // ENTER
            text = [stackView1.text retain];
            if(text.length == 0) {
                [_stack addObject:[_stack lastObject]];    
            }
            else {
                [self push];
            }
            [self updateStackView];
            [text release];
            break;
        
        case 1: // DELETE
            text = [stackView1.text retain];
            NSUInteger length = text.length;
            if(length > 0) {
                stackView1.text = [text substringToIndex:(length-1)];
            }
            [text release];
            break;
            
        case 2: // DROP
            [self pop];
            [self updateStackView];
            break;
        
        case 3: // SWAP
            count = _stack.count;
            if(count>=2) {
                NSDecimalNumber *tmp = [[_stack lastObject] retain];
                [_stack replaceObjectAtIndex:(count-1) withObject:[_stack objectAtIndex:(count-2)]];
                [_stack replaceObjectAtIndex:(count-2) withObject:tmp];
                [tmp release];
                [self updateStackView];
            }
            break;
    }
}


- (IBAction)singleParameterOperationHit:(UIButton*)sender {
    [self push];
    
    NSDecimalNumber* op1 = [[self pop] retain];
    
    NSDecimalNumber* result;
    
    switch (sender.tag) {
        case -1: // NEGATE
            result = [op1 decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithMantissa:1 exponent:0 isNegative:YES]];
            break;
            
        case 0: // SIN
            result = (NSDecimalNumber*)[NSDecimalNumber numberWithDouble:sin([op1 doubleValue])];
            break;
            
        case 1: // COS
            result = (NSDecimalNumber*)[NSDecimalNumber numberWithDouble:cos([op1 doubleValue])];
            break;
            
        case 2: // TAN
            result = (NSDecimalNumber*)[NSDecimalNumber numberWithDouble:tan([op1 doubleValue])];
            break;
            
        case 3: // SQRT
            if([op1 compare:[NSDecimalNumber zero]] != NSOrderedAscending) {
                result = (NSDecimalNumber*)[NSDecimalNumber numberWithDouble:sqrt([op1 doubleValue])];
            }
            else {
                result = [NSDecimalNumber zero];
            }
            break;
            
        case 4: // INVERT
            result = [[NSDecimalNumber one] decimalNumberByDividingBy:op1];
            break;
            
        default:
            result = op1;
            break;
    }

    [_stack addObject:result];
    
    [op1 release];
    
    [self updateStackView];
}

- (IBAction)doubleParametersOperationHit:(UIButton*)sender {
    [self push];
    
    NSDecimalNumber* op1 = [[self pop] retain];
    NSDecimalNumber* op2 = [[self pop] retain];
    
    NSDecimalNumber* result;
    
    switch (sender.tag) {
        case 0: // ADD
            result = [op2 decimalNumberByAdding:op1];
            break;
            
        case 1: // SUBSTRACT
            result = [op2 decimalNumberBySubtracting:op1];
            break;
            
        case 2: // MULTIPLY
            result = [op2 decimalNumberByMultiplyingBy:op1];
            break;
        
        case 3: // DIVIDE
            result = [op2 decimalNumberByDividingBy:op1];
            break;
            
        case 4: // POWER
            result = (NSDecimalNumber*)[NSDecimalNumber numberWithDouble:pow([op2 doubleValue], [op1 doubleValue])];
            break;
            
        default:
            result = op1;
            break;
    }
    
    [_stack addObject:result];
    
    [op1 release];
    [op2 release];
    
    [self updateStackView];
}

-(void)updateStackView {
    NSUInteger count = [_stack count];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.maximumFractionDigits = 30;
    
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
    [result autorelease];
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
    [stackView1 release];
    [stackView2 release];
    [stackView3 release];
    [stackView4 release];
    [_stack release];
    [super dealloc];
}


@end
