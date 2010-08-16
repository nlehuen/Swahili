//
//  FlipsideViewController.h
//  Swahili
//
//  Created by Nicolas LEHUEN on 15/08/10.
//  Copyright CRM Company Group 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MapKit/MapKit.h>

@protocol FlipsideViewControllerDelegate;

@interface FlipsideViewController : UIViewController {
    id <FlipsideViewControllerDelegate> delegate;
}

@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet MKMapView* mapView;

- (IBAction)done:(id)sender;

@end


@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

