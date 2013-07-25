//
//  ViewController.m
//  AnnotationMoveSample
//
//  Created by Masamichi Ueta on 12/06/27.
//  Copyright (c) 2012年 The University of Tokyo. All rights reserved.
//

#import "ViewController.h"
#import "CustomAnnotation.h"
#import "CustomAnnotationView.h"

@interface ViewController (){
    CustomAnnotation *moveAnnotation;
    NSTimer *timer;
    CLLocationCoordinate2D coors[2];
    double lat_gap;
    double lon_gap;
    
}
@property (retain, nonatomic) CustomAnnotation *moveAnnotation;
@property (retain, nonatomic) NSTimer *timer;

-(void)startTimer;
-(void)stopTimer;
-(void)move;

@end

@implementation ViewController
@synthesize mapView;
@synthesize moveAnnotation;
@synthesize timer;

- (void)viewDidLoad
{
    [super viewDidLoad];
    CLLocationCoordinate2D co;
    //    co.latitude = 35.688185;
    //    co.longitude = 139.760009;
    co.latitude = 35.700000;
    co.longitude = 139.78000;
    [mapView setCenterCoordinate:co animated:NO];
    
    MKCoordinateRegion cr = mapView.region;
    cr.center = co;
    cr.span.latitudeDelta = 0.06;
    cr.span.longitudeDelta = 0.06;
    [mapView setRegion:cr animated:NO];
    [mapView setDelegate: self];
    
    coors[0] = CLLocationCoordinate2DMake(35.710702,139.812935);
    coors[1] = CLLocationCoordinate2DMake(35.690747,139.756866);
    
//    [mapView addAnnotation:
//     [[[CustomAnnotation alloc]initWithLocationCoordinate:coors[0]                                                    title:@"大手町駅" subtitle:@"千代田線・半蔵門線・丸ノ内線・東西線・三田線"]autorelease]];
    [mapView addAnnotation:
    [[[CustomAnnotation alloc]initWithLocationCoordinate:coors[0]                                                    title:@"押上" subtitle:@"ホノルル目指してスタート★"]autorelease]];
    [mapView addAnnotation:
     [[[CustomAnnotation alloc]initWithLocationCoordinate:coors[1]                                                    title:@"竹橋駅" subtitle:@"仮想ホノルル！"]autorelease]];
    
    MKPolyline *line = [MKPolyline polylineWithCoordinates:coors count:2];
    [mapView addOverlay:line];
    
    moveAnnotation = [[CustomAnnotation alloc] initWithLocationCoordinate:coors[0] title:@"move" subtitle:nil];
    [mapView addAnnotation:moveAnnotation];
    
    //lat_gap = (coors[1].latitude - coors[0].latitude) / 20;
    //lon_gap = (coors[1].longitude - coors[0].longitude) / 20;
    lat_gap = (coors[1].latitude - coors[0].latitude) / 80;
    lon_gap = (coors[1].longitude - coors[0].longitude) / 80;
    
    
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)dealloc {
    [mapView release];
    [timer release];
    [moveAnnotation release];
    [super dealloc];
}


- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {
    MKPolylineView *view = [[[MKPolylineView alloc] initWithOverlay:overlay]
                            autorelease];
    //view.strokeColor = [UIColor blueColor];
    view.strokeColor = [UIColor redColor];
    
    //view.lineWidth = 5.0;
    view.lineWidth = 12.0;
    return view;
}


-(MKAnnotationView*)mapView:(MKMapView*)mapView viewForAnnotation:(id)annotation{
    
    if(annotation == moveAnnotation){
        CustomAnnotationView *annotationView;
        NSString* identifier = @"move";
        
       
        annotationView = (CustomAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if(nil == annotationView) {
            
            annotationView = [[[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];
        }
        
        [annotation willChangeValueForKey:@"coordinate"];
        [annotation didChangeValueForKey:@"coordinate"];
        
        
        annotationView.annotation = annotation;
        annotationView.canShowCallout = YES;
        return annotationView;
    }
    
    
    static NSString *PinIdentifier = @"Pin";
    MKPinAnnotationView *pav = (MKPinAnnotationView*) [self.mapView dequeueReusableAnnotationViewWithIdentifier:PinIdentifier];
    
    if(pav == nil){
        pav = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:PinIdentifier] autorelease];
        pav.animatesDrop = YES;  
        pav.pinColor = MKPinAnnotationColorRed;  
        pav.canShowCallout = YES;
    }
    return pav;
    
}


-(void)startTimer{
    //self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0/20.0
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0/5.0
                                                      target:self
                                                    selector:@selector(move)
                                                    userInfo:nil
                                                     repeats:YES];
}



-(void)stopTimer{
    if(self.timer){
        [self.timer invalidate];
    }
}

-(void)move{
    
    double curentUserLat = moveAnnotation.coordinate.latitude + lat_gap;
    double currentUserLon = moveAnnotation.coordinate.longitude + lon_gap;
    CLLocationCoordinate2D co;
    co.latitude = curentUserLat;
    co.longitude = currentUserLon;
    [moveAnnotation changeCoordinate:co]; 
    [mapView addAnnotation:moveAnnotation];
    
    //if(co.latitude >= coors[1].latitude){
    if(co.latitude <= coors[1].latitude){
        [self stopTimer];
//        co = coors[0];
//        [moveAnnotation changeCoordinate:co];
//        [mapView addAnnotation:moveAnnotation];
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"おめでとうございます！" message:@"ホノルルに到着しました★"
                                  delegate:self cancelButtonTitle:nil otherButtonTitles:@"終了する", nil];
        [alert show];

    }
}

- (IBAction)playButton:(id)sender {
    [self startTimer];
}
@end
