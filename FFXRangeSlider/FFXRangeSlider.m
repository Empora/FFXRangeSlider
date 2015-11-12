//
//  FFXRangeSlider.m
//  FFXRangeSliderDemo
//
//  Created by Robert Biehl on 12/11/2015.
//  Copyright © 2015 Robert Biehl. All rights reserved.
//

#import "FFXRangeSlider.h"
#import "FFXRangeSliderHandle.h"
#import "FFXRangeStepView.h"

static CGFloat const kRangeSliderDimension = 32.0f;
static CGFloat const kRangeSliderTransitionDuration = 0.2f;

@interface FFXRangeSlider ()

@property (nonatomic, assign) CGFloat underlyingFromValue;
@property (nonatomic, assign) CGFloat underlyingToValue;

@property (nonatomic, assign) NSUInteger fromIndex;
@property (nonatomic, assign) NSUInteger toIndex;

@property (nonatomic, assign) UIEdgeInsets trackAdjustments;

@property (nonatomic, strong) CALayer *trackLayer;
@property (nonatomic, strong) CALayer *selectedTrackLayer;

@property (nonatomic, strong) FFXRangeSliderHandle *leftHandle;
@property (nonatomic, strong) FFXRangeSliderHandle *rightHandle;

@property (nonatomic, strong) FFXRangeStepView *stepView;

@end

@implementation FFXRangeSlider

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self ms_init];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self ms_init];
    }
    
    return self;
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(UIViewNoIntrinsicMetric, _handleDiameter);
}

- (void)layoutSubviews
{
    [self ms_updateThumbs];
    [self ms_updateTrackLayers];
    [self ffx_updateStepView];
}

- (void)setFromValue:(CGFloat)value
{
    value = [self ms_applySteps:value leftBoundIndex:NSNotFound rightBoundIndex:self.toIndex];
    if (_fromValue != value) {
        _fromValue = value;
        [self ffx_updateStepView];

    }
    self.underlyingFromValue = value;
}

- (void)setToValue:(CGFloat)value
{
    value = [self ms_applySteps:value leftBoundIndex:self.fromIndex rightBoundIndex:NSNotFound];
    if (_toValue != value) {
        _toValue = value;
        [self ffx_updateStepView];
    }
    self.underlyingToValue = value;
}

- (NSUInteger)fromIndex{
    return [self ms_calcStep:self.fromValue];
}

- (NSUInteger)toIndex{
    return [self ms_calcStep:self.toValue];
}

- (void)setEdgeInsets:(UIEdgeInsets)edgeInsets{
    _edgeInsets = edgeInsets;
    [self setNeedsLayout];
}

- (void)setMinimumValue:(CGFloat)minValue
{
    _minValue = minValue;
    [self ms_alignValues];
    [self setNeedsLayout];
}

- (void)setMaximumValue:(CGFloat)maxValue
{
    _maxValue = maxValue;
    [self ms_alignValues];
    [self setNeedsLayout];
}

- (void)setMinimumInterval:(CGFloat)minInterval
{
    _minInterval = minInterval;
    [self ms_alignValues];
    [self setNeedsLayout];
}

- (void)setSelectedTrackTintColor:(UIColor *)selectedTrackTintColor
{
    NSParameterAssert(selectedTrackTintColor);
    _selectedTrackTintColor = selectedTrackTintColor;
    self.selectedTrackLayer.backgroundColor = selectedTrackTintColor.CGColor;
    _stepView.activeColor = self.selectedTrackTintColor;
}

- (void)setTrackTintColor:(UIColor *)trackTintColor
{
    NSParameterAssert(trackTintColor);
    _trackTintColor = trackTintColor;
    self.trackLayer.backgroundColor = trackTintColor.CGColor;
    _stepView.color = self.trackTintColor;
}

- (void)setThumbTintColor:(UIColor *)handleTintColor
{
    NSParameterAssert(handleTintColor);
    _handleTintColor = handleTintColor;
    self.leftHandle.tintColor = handleTintColor;
    self.rightHandle.tintColor = handleTintColor;
}

- (void)setHandleBorderWidth:(CGFloat)handleBorderWidth{
    if (_handleBorderWidth != handleBorderWidth) {
        _handleBorderWidth = handleBorderWidth;
        self.leftHandle.borderWidth = handleBorderWidth;
        self.rightHandle.borderWidth = handleBorderWidth;
    }
}

- (void)setHandleBorderColor:(UIColor*)handleBorderColor{
    if (_handleBorderColor != handleBorderColor) {
        _handleBorderColor = handleBorderColor;
        self.leftHandle.borderColor = handleBorderColor;
        self.rightHandle.borderColor = handleBorderColor;
    }
}

- (void)setSteps:(NSArray<NSString *> *)steps{
    if (_steps != steps) {
        _steps = steps;
        
        if (steps.count) {
            self.stepView.steps = steps;
            self.stepView.hidden = NO;
        } else {
            self.stepView.hidden = YES;
        }
    }
}

#pragma mark - Private methods

- (void)ms_init
{
    _trackWidth = _selectedTrackWidth = 2.0;
    _minValue = 0.0;
    _maxValue = 1.0;
    _minInterval = 0.1;
    _fromValue = _underlyingFromValue = _minValue;
    _toValue = _underlyingToValue = _maxValue;
    
    _handleDiameter = kRangeSliderDimension;
    _edgeInsets  = UIEdgeInsetsMake(5.0, 8.0, 5.0, 8.0);
    
    _trackAdjustments = UIEdgeInsetsMake(0, _handleDiameter/2.0, 0.0, _handleDiameter/2.0);
    
    _selectedTrackTintColor = [UIColor colorWithRed:0.0 green:122.0 / 255.0 blue:1.0 alpha:1.0];
    _trackTintColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0];
    _handleTintColor = [UIColor whiteColor];
    
    self.trackLayer = [CALayer layer];
    self.trackLayer.backgroundColor = self.trackTintColor.CGColor;
    self.trackLayer.cornerRadius = 1.3;
    [self.layer addSublayer:self.trackLayer];
    
    self.selectedTrackLayer = [CALayer layer];
    self.selectedTrackLayer.backgroundColor = self.selectedTrackTintColor.CGColor;
    self.selectedTrackLayer.cornerRadius = 1.3;
    [self.layer addSublayer:self.selectedTrackLayer];
    
    self.leftHandle = [[FFXRangeSliderHandle alloc] init];
    self.leftHandle.diameter = _handleDiameter;
    [self addSubview:self.leftHandle];
    UIGestureRecognizer *fromGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(ms_didPanFromThumbView:)];
    [self.leftHandle addGestureRecognizer:fromGestureRecognizer];
    
    self.rightHandle = [[FFXRangeSliderHandle alloc] init];
    self.rightHandle.diameter = _handleDiameter;
    [self addSubview:self.rightHandle];
    UIGestureRecognizer *toGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(ms_didPanToThumbView:)];
    [self.rightHandle addGestureRecognizer:toGestureRecognizer];
}

- (void)ms_alignValues
{
    _minValue = MIN(self.maxValue, self.minValue);
    _maxValue = MAX(self.maxValue, self.minValue);
    _minInterval = MIN(self.minInterval, self.maxValue - self.minValue);
    _toValue = MIN(MAX(self.toValue, self.fromValue + self.minInterval), self.maxValue);
    _fromValue = MAX(MIN(self.fromValue, self.toValue - self.minInterval), self.minValue);
}

- (void)ms_updateTrackLayers
{
    CGFloat width = CGRectGetWidth(self.bounds);
    
    self.trackLayer.bounds = CGRectMake(0, 0, width - (self.edgeInsets.left+self.edgeInsets.right), _trackWidth);
    self.trackLayer.position = CGPointMake(self.edgeInsets.left+self.trackLayer.bounds.size.width/2.0, self.edgeInsets.top + _handleDiameter/2.0-_trackWidth/2.0);
    
    CGFloat from = CGRectGetMinX(self.leftHandle.frame);
    CGFloat to = CGRectGetMaxX(self.rightHandle.frame);
    
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue
                     forKey:kCATransactionDisableActions];
    self.selectedTrackLayer.bounds = CGRectMake(0, 0, to - from, _selectedTrackWidth);
    self.selectedTrackLayer.position = CGPointMake((from + to) / 2, self.edgeInsets.top + _handleDiameter/2.0-_selectedTrackWidth/2.0);
    [CATransaction commit];
}

- (void)setUnderlyingFromValue:(CGFloat)underlyingFromValue{
    if (_underlyingFromValue != underlyingFromValue) {
        _underlyingFromValue = underlyingFromValue;
        [self ms_alignValues];
        [self setNeedsLayout];
    }
}

- (void)setUnderlyingToValue:(CGFloat)underlyingToValue{
    if (_underlyingToValue != underlyingToValue) {
        _underlyingToValue = underlyingToValue;
        [self ms_alignValues];
        [self setNeedsLayout];
    }
}

- (void)ms_didPanFromThumbView:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded || gestureRecognizer.state == UIGestureRecognizerStateCancelled || gestureRecognizer.state == UIGestureRecognizerStateFailed) {

        [UIView transitionWithView:self
                          duration:kRangeSliderTransitionDuration
                           options:UIViewAnimationOptionCurveEaseInOut
                        animations:^{
                            self.fromValue = self.underlyingFromValue;
                            [self layoutIfNeeded];
                            [self sendActionsForControlEvents:UIControlEventValueChanged];
                        } completion:^(BOOL finished) {
                            
                        }
         ];


    }
    
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan && gestureRecognizer.state != UIGestureRecognizerStateChanged) {
        return;
    }
    
    CGPoint translation = [gestureRecognizer translationInView:self];
    [gestureRecognizer setTranslation:CGPointZero inView:self];
    CGFloat fromValue = [self ms_applyTranslation:translation.x forValue:self.underlyingFromValue];
    self.underlyingFromValue = MAX(MIN(fromValue, self.toValue - self.minInterval), self.minValue);
    

}

- (void)ms_didPanToThumbView:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {

        [UIView transitionWithView:self
                          duration:kRangeSliderTransitionDuration
                           options:UIViewAnimationOptionCurveEaseInOut
                        animations:^{
                            self.toValue = self.underlyingToValue;
                            [self layoutIfNeeded];
                            [self sendActionsForControlEvents:UIControlEventValueChanged];
                        } completion:^(BOOL finished) {
                            
                        }
         ];

    }
    
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan && gestureRecognizer.state != UIGestureRecognizerStateChanged) {
        return;
    }
    
    CGPoint translation = [gestureRecognizer translationInView:self];
    [gestureRecognizer setTranslation:CGPointZero inView:self];
    
    CGFloat toValue = [self ms_applyTranslation:translation.x forValue:self.underlyingToValue];
    self.underlyingToValue = MIN(MAX(toValue, self.fromValue + self.minInterval), self.maxValue);
}

- (CGFloat)ms_applyTranslation:(CGFloat)translation forValue:(CGFloat)value
{
    CGFloat width = CGRectGetWidth(self.bounds) - 2 * _handleDiameter;
    CGFloat valueRange = (self.maxValue - self.minValue);
    
    return value + valueRange * translation / width;
}

#pragma mark update handle positions

- (CGPoint)ms_thumbCenterLocationForValue:(CGFloat)value
{
    CGFloat leftOffset = _edgeInsets.left + _trackAdjustments.left;
    
    CGFloat width = CGRectGetWidth(self.bounds) - (_edgeInsets.left + _edgeInsets.right);
    CGFloat availableWidthForThumbCenters = width - (_trackAdjustments.left + _trackAdjustments.right);
    CGFloat ratio = availableWidthForThumbCenters/width;
    
    CGFloat valueRange = (self.maxValue - self.minValue);
    
    CGFloat x = valueRange == 0 ? 0 : width * (value - self.minValue) / valueRange;
    x = leftOffset + ratio*x;
    return CGPointMake(x, _edgeInsets.top);
}


- (void)ms_updateThumbs
{
    CGPoint fromThumbLocation = [self ms_thumbCenterLocationForValue:self.underlyingFromValue];
    self.leftHandle.frame = CGRectMake(fromThumbLocation.x - _handleDiameter/2.0, fromThumbLocation.y, _handleDiameter, _handleDiameter);
    
    CGPoint toThumbLocation = [self ms_thumbCenterLocationForValue:self.underlyingToValue];
    self.rightHandle.frame = CGRectMake(toThumbLocation.x - _handleDiameter/2.0, toThumbLocation.y, _handleDiameter, _handleDiameter);
    
    BOOL atDefaultValue = (self.underlyingFromValue == self.minValue) && (self.underlyingToValue == self.maxValue);
    
    self.leftHandle.tintColor = atDefaultValue ? self.handleTintColor : self.activeHandleTintColor;
    self.rightHandle.tintColor = atDefaultValue ? self.handleTintColor : self.activeHandleTintColor;
    self.leftHandle.borderColor = atDefaultValue ? self.handleBorderColor : self.activeHandleTintColor;
    self.rightHandle.borderColor = atDefaultValue ? self.handleBorderColor : self.activeHandleTintColor;
}

#pragma mark Display Steps

- (FFXRangeStepView *)stepView{
    if (!_stepView) {
        _stepView = [[FFXRangeStepView alloc] initWithFrame:self.bounds];
        _stepView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _stepView.color = self.trackTintColor;
        _stepView.activeColor = self.selectedTrackTintColor;
        _stepView.lineSize = CGSizeMake(self.trackWidth, 15.0);
        _stepView.font = self.font;
        _stepView.sliderHeight = _handleDiameter;
        _stepView.padding = self.edgeInsets.bottom;
        [self addSubview:_stepView];
        [self sendSubviewToBack:_stepView];
    }
    return _stepView;
}

- (void) ffx_updateStepView{
    _stepView.frame = CGRectMake(self.edgeInsets.left, self.edgeInsets.top, self.bounds.size.width-(self.edgeInsets.left+self.edgeInsets.right), self.bounds.size.height - self.edgeInsets.top);
    
    NSMutableIndexSet* indexSet = [NSMutableIndexSet indexSet];
    if (self.fromIndex!=NSNotFound) {
        [indexSet addIndex:self.fromIndex];
    }
    if (self.toIndex != NSNotFound) {
        [indexSet addIndex:self.toIndex];
    }
    
    [_stepView setActiveIndexes:indexSet];
}

- (NSInteger) ms_calcStep:(CGFloat) value{
    if (self.steps.count) {
        NSUInteger numSteps = self.steps.count;
        return (NSInteger)round(value*(numSteps-1));
    }
    return NSNotFound;
}

- (CGFloat) ms_applySteps:(CGFloat) value leftBoundIndex:(NSUInteger) leftBoundIndex rightBoundIndex:(NSUInteger) rightBoundIndex{
    NSInteger step = [self ms_calcStep:value];
    if (step != NSNotFound) {
        if (leftBoundIndex != NSNotFound && step <= leftBoundIndex) {
            step = leftBoundIndex + 1;
        }
        if (rightBoundIndex != NSNotFound && step >= rightBoundIndex) {
            step = rightBoundIndex - 1;
        }

        NSUInteger numSteps = self.steps.count;
        value = step*(self.maxValue/(numSteps-1));
        
        if (value < 0) {
            NSLog(@"aa");
        }
    }
    return value;
}

@end