//
//  MainViewController.h
//  Swahili
//
//  Created by Nicolas LEHUEN on 15/08/10.
//  Copyright CRM Company Group 2010. All rights reserved.
//

#import "FlipsideViewController.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate> {
	NSMutableArray *_stack;
}

@property(nonatomic,retain) IBOutlet UILabel *stackView1;
@property(nonatomic,retain) IBOutlet UILabel *stackView2;
@property(nonatomic,retain) IBOutlet UILabel *stackView3;
@property(nonatomic,retain) IBOutlet UILabel *stackView4;

- (IBAction)showInfo:(id)sender;
- (IBAction)numberHit:(id)sender;
- (IBAction)controlHit:(id)sender;
- (IBAction)operationHit:(id)sender;

- (void)updateStackView;
- (void)push;
- (NSDecimalNumber*)pop;

@end
