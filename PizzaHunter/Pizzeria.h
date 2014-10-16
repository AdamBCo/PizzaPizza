//
//  Pizzeria.h
//  PizzaHunter
//
//  Created by Adam Cooper on 10/15/14.
//  Copyright (c) 2014 Adam Cooper. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface Pizzeria : MKMapItem

@property (nonatomic,copy) NSString *name;
@property (readonly) NSString  *address;
@property (readonly) CLLocation *location;
@property  float distanceFromLocationPizza;
-(instancetype)initCreatePizzeria:(MKMapItem *)pizzeriaLocation;
-(float)distanceFromLocation:(CLLocation *)userLocation;


@end
