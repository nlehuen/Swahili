//
//  NSDecimalNumber.m
//  Swahili
//
//  Created by Nicolas LEHUEN on 16/08/10.
//  Copyright 2010 CRM Company Group. All rights reserved.
//

#import "NSDecimalNumber.h"


@implementation NSDecimalNumber (Convertor)
+decimalNumberWithDouble:(double)value {
	return [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%21.10f", value]];
}
@end
