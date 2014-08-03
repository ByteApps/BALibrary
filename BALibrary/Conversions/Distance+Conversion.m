//
//  Conversions.c
//  BALibrary
//
//  Created by Salvador Guerrero on 6/27/14.
//  Copyright (c) 2014 ByteApps. All rights reserved.
//


#include "Distance+Conversion.h"

#define MeterToMileMultiplier (0.000621371192)
#define MeterToYardMultiplier (1.0936)
#define MeterToFeetMultiplier (3.280839895)

NSString* formatDistanceFromMeters(double meters)
{
    double value = metersToFeet(meters);

    if (value < 1000)
    {
        NSString *result = [NSString stringWithFormat:@"%.2f feet", value];

        if(value > 1)
        {
            result = [result stringByAppendingString:@"s"];
        }

        return result;
    }

    value = metersToYards(meters);

    if (value < 1000)
    {
        NSString *result = [NSString stringWithFormat:@"%.2f yard", value];

        if(value > 1)
        {
            result = [result stringByAppendingString:@"s"];
        }

        return result;
    }

    NSString *result = [NSString stringWithFormat:@"%.2f mile", metersToMiles(meters)];

    if(value > 1)
    {
        result = [result stringByAppendingString:@"s"];
    }

    return result;
}

double metersToMiles(double meters)
{
    return meters * MeterToMileMultiplier;
}

double metersToYards(double meters)
{
    return meters * MeterToYardMultiplier;
}

double metersToFeet(double meters)
{
    return meters * MeterToFeetMultiplier;
}