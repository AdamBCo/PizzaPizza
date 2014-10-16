//
//  ViewController.m
//  PizzaHunter
//
//  Created by Adam Cooper on 10/15/14.
//  Copyright (c) 2014 Adam Cooper. All rights reserved.
//

#define METERS_TO_MILES 0.000621371;

#import "ViewController.h"
#import "Pizzeria.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@interface ViewController () <CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *pizzeriaTableView;
@property (weak, nonatomic) IBOutlet MKMapView *pizzeriaMapView;
@property CLLocationManager *myLocationManager;
@property NSMutableArray *listOfPizzarias;
@property UIRefreshControl *refreshControl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myLocationManager = [CLLocationManager new];
    [self.myLocationManager requestWhenInUseAuthorization];
    self.myLocationManager.delegate = self;
    self.pizzeriaMapView.delegate = self;
    [self.myLocationManager startUpdatingLocation];
    

}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"We failed to connect: %@",error);
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    for (CLLocation *location in locations) {
        if (location.verticalAccuracy < 1000 && location.horizontalAccuracy < 1000) {
            [self reverseGeocode:location];
            NSLog(@"My location is: %@",location);
            [self.myLocationManager stopUpdatingLocation];
        }
    }
}

-(void)reverseGeocode:(CLLocation *)location{
    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = placemarks.firstObject;
        [self findPizzeraNearMe:placemark.location];
    }];
    
}


-(void)findPizzeraNearMe:(CLLocation *)location{
    MKLocalSearchRequest *request = [MKLocalSearchRequest new];
    request.naturalLanguageQuery = @"pizza";
    request.region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(1, 1));
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        self.listOfPizzarias = [NSMutableArray new];
        NSArray *mapItems = response.mapItems;
        for (MKMapItem *mapItem in mapItems) {
            Pizzeria *pizzeria = [[Pizzeria alloc]initCreatePizzeria:mapItem];
            pizzeria.distanceFromLocationPizza = [pizzeria distanceFromLocation:location];
            if (pizzeria.distanceFromLocationPizza < 5) {
                [self.listOfPizzarias addObject:pizzeria];
                [self.pizzeriaTableView reloadData];
                [self.pizzeriaMapView addAnnotation:pizzeria.placemark];
                [self.pizzeriaMapView showAnnotations:self.pizzeriaMapView.annotations animated:YES];
            }
        }
        
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Pizzeria *pizzeria = [self.listOfPizzarias objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = pizzeria.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f miles", pizzeria.distanceFromLocationPizza];
    cell.imageView.image = [UIImage imageNamed:@"pizza_hut"];
    return cell;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listOfPizzarias.count;
}



- (IBAction)refreshTableView:(id)sender {
    [self.pizzeriaTableView reloadData];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    if (annotation == self.pizzeriaMapView.userLocation) {
        return nil;
    }
    MKAnnotationView* annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MyCustomAnnotation"];
    annotationView.image = [UIImage imageNamed:@"pizza"];
    annotationView.centerOffset = CGPointMake(10, -20);
    annotationView.canShowCallout = YES;
    annotationView.enabled = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    

    
    return annotationView;
}


@end
