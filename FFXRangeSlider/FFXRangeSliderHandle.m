//
//  FFXRangeSliderHandle.m
//  FFXRangeSliderDemo
//
//  Created by Robert Biehl on 12/11/2015.
//  Copyright © 2015 Robert Biehl. All rights reserved.
//

#import "FFXRangeSliderHandle.h"

@interface FFXRangeSliderHandle()

@property (nonatomic, strong) CALayer *thumbLayer;


@end

@implementation FFXRangeSliderHandle

- (void)setDiameter:(CGFloat)diameter{
    if (_diameter != diameter) {
        _diameter = diameter;
        self.thumbLayer.cornerRadius = diameter / 2;
    }
}
- (void)setBorderColor:(UIColor *)borderColor{
    _borderColor = borderColor;
    self.thumbLayer.borderColor = borderColor.CGColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth{
    _borderWidth = borderWidth;
    self.thumbLayer.borderWidth = borderWidth;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.thumbLayer = [CALayer layer];
        
        self.thumbLayer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:.4].CGColor;
        self.thumbLayer.borderWidth = .5;
        self.thumbLayer.backgroundColor = [UIColor whiteColor].CGColor;
        self.thumbLayer.shadowColor = [UIColor blackColor].CGColor;
        self.thumbLayer.shadowOffset = CGSizeMake(0.0, 3.0);
        self.thumbLayer.shadowRadius = 2;
        self.thumbLayer.shadowOpacity = 0.3f;
        [self.layer addSublayer:self.thumbLayer];
    }
    
    return self;
}

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    if (layer != self.layer) {
        return;
    }

    self.thumbLayer.bounds = CGRectMake(0, 0, self.diameter, self.diameter);
    self.thumbLayer.position = CGPointMake(self.diameter / 2, self.diameter / 2);
}

- (void)setTintColor:(UIColor *)tintColor
{
    _tintColor = tintColor;
    self.thumbLayer.backgroundColor = tintColor.CGColor;
}

@end
