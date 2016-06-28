//
//  FFXRangeSliderDemoTests.m
//  FFXRangeSliderDemoTests
//
//  Created by Robert Biehl on 12/11/2015.
//  Copyright © 2015 Robert Biehl. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "FFXRangeSlider.h"

@interface FFXRangeSliderDemoTests : XCTestCase

@end

@implementation FFXRangeSliderDemoTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testStepsFromValue {
    FFXRangeSlider* slider = [[FFXRangeSlider alloc] init];
    slider.steps = @[@"step1", @"step2", @"step5", @"step4", @"step5"];
    
    slider.fromValue = 0.0;
    XCTAssertEqualWithAccuracy(slider.fromValue, 0.0, FLT_EPSILON, @"With steps enabled the value should jump to the nearest value.");
    slider.fromValue = 0.1;
    XCTAssertEqualWithAccuracy(slider.fromValue, 0.0, FLT_EPSILON, @"With steps enabled the value should jump to the nearest value.");
    slider.fromValue = 0.2;
    XCTAssertEqualWithAccuracy(slider.fromValue, 0.25, FLT_EPSILON, @"With steps enabled the value should jump to the nearest value.");
    slider.fromValue = 0.3;
    XCTAssertEqualWithAccuracy(slider.fromValue, 0.25, FLT_EPSILON, @"With steps enabled the value should jump to the nearest value.");
    slider.fromValue = 0.4;
    XCTAssertEqualWithAccuracy(slider.fromValue, 0.5, FLT_EPSILON, @"With steps enabled the value should jump to the nearest value.");
    slider.fromValue = 0.5;
    XCTAssertEqualWithAccuracy(slider.fromValue, 0.5, FLT_EPSILON, @"With steps enabled the value should jump to the nearest value.");
    slider.fromValue = 0.6;
    XCTAssertEqualWithAccuracy(slider.fromValue, 0.5, FLT_EPSILON, @"With steps enabled the value should jump to the nearest value.");
    slider.fromValue = 0.7;
    XCTAssertEqualWithAccuracy(slider.fromValue, 0.75, FLT_EPSILON, @"With steps enabled the value should jump to the nearest value.");
    slider.fromValue = 0.8;
    XCTAssertEqualWithAccuracy(slider.fromValue, 0.75, FLT_EPSILON, @"With steps enabled the value should jump to the nearest value.");
}

- (void)testStepsToValue {
    FFXRangeSlider* slider = [[FFXRangeSlider alloc] init];
    slider.steps = @[@"step1", @"step2", @"step5", @"step4", @"step5"];
    
    slider.toValue = 0.2;
    XCTAssertEqualWithAccuracy(slider.toValue, 0.25, FLT_EPSILON, @"With steps enabled the value should jump to the nearest value.");
    slider.toValue = 0.3;
    XCTAssertEqualWithAccuracy(slider.toValue, 0.25, FLT_EPSILON, @"With steps enabled the value should jump to the nearest value.");
    slider.toValue = 0.4;
    XCTAssertEqualWithAccuracy(slider.toValue, 0.5, FLT_EPSILON, @"With steps enabled the value should jump to the nearest value.");
    slider.toValue = 0.5;
    XCTAssertEqualWithAccuracy(slider.toValue, 0.5, FLT_EPSILON, @"With steps enabled the value should jump to the nearest value.");
    slider.toValue = 0.6;
    XCTAssertEqualWithAccuracy(slider.toValue, 0.5, FLT_EPSILON, @"With steps enabled the value should jump to the nearest value.");
    slider.toValue = 0.7;
    XCTAssertEqualWithAccuracy(slider.toValue, 0.75, FLT_EPSILON, @"With steps enabled the value should jump to the nearest value.");
    slider.toValue = 0.8;
    XCTAssertEqualWithAccuracy(slider.toValue, 0.75, FLT_EPSILON, @"With steps enabled the value should jump to the nearest value.");
    slider.toValue = 0.9;
    XCTAssertEqualWithAccuracy(slider.toValue, 1.0, FLT_EPSILON, @"With steps enabled the value should jump to the nearest value.");
    slider.toValue = 1.0;
    XCTAssertEqualWithAccuracy(slider.toValue, 1.0, FLT_EPSILON, @"With steps enabled the value should jump to the nearest value.");
}


@end
