//
//  FFXRangeSliderHandle.h
//  FFXRangeSliderDemo
//
//  Created by Robert Biehl on 12/11/2015.
//  Copyright © 2015 Robert Biehl. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FFXRangeSlider.h"

@interface FFXRangeSliderHandle : UIView

@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, assign) CGFloat diameter;

@property (nonatomic, strong) UIColor* borderColor;
@property (nonatomic, assign) CGFloat borderWidth;

@end
