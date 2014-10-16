//
//  Pizzeria.m
//  PizzaHunter
//
//  Created by Adam Cooper on 10/15/14.
//  Copyright (c) 2014 Adam Cooper. All rights reserved.
//

#define METERS_TO_MILES 0.000621371;

#import "Pizzeria.h"


@implementation Pizzeria {
    MKMapItem *pizzeria;
}

-(instancetype)initCreatePizzeria:(MKMapItem *)pizzeriaLocation{
    self = [super init];
    if (self) {
        pizzeria = pizzeriaLocation;
    }
    return self;
}

-(float)distanceFromLocation:(CLLocation *)userLocation{
    CLLocationDistance distanceOne = [pizzeria.placemark.location distanceFromLocation:userLocation];
    return distanceOne * METERS_TO_MILES;
}

-(NSString *)name{
    return pizzeria.placemark.name;
}

-(MKPlacemark *)placemark{
    return pizzeria.placemark;
}



-(NSString *)address{
    
    NSString *stringOne = [NSString stringWithFormat:@"%@", pizzeria.placemark.subThoroughfare];
    NSString *stringTwo = [NSString stringWithFormat:@"%@", pizzeria.placemark.thoroughfare];
    NSString *stringThree = [NSString stringWithFormat:@"%@", pizzeria.placemark.locality];
    NSString *addressString = [NSString stringWithFormat:@"%@ %@ , %@", stringOne,stringTwo,stringThree];
    NSLog(@"Hello %@",pizzeria.placemark.location);
    return addressString;
}

@end
