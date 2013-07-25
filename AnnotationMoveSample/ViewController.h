//
//  ViewController.h
//  AnnotationMoveSample
//
//  Created by Masamichi Ueta on 12/06/27.
//  Copyright (c) 2012年 The University of Tokyo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController<MKMapViewDelegate>{
    
}
@property (retain, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)playButton:(id)sender;

@end
