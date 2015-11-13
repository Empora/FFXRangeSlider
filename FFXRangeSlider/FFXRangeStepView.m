//
//  FFXRangeStepView.m
//  FFXRangeSliderDemo
//
//  Created by Robert Biehl on 12/11/2015.
//  Copyright © 2015 Robert Biehl. All rights reserved.
//

#import "FFXRangeStepView.h"

@interface FFXRangeStepView()

@property (nonatomic, strong, nullable) NSArray<NSLayoutConstraint*>* constraints;

@property (nonatomic, strong, nullable) NSArray<UIView*>* verticalLines;
@property (nonatomic, strong, nullable) NSArray<UILabel*>* labels;

@end

@implementation FFXRangeStepView

- (instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _lineSize = CGSizeMake(1.0, 10.0);
        _padding = 5.0;
    }
    return self;
}

- (void) invalidateConstraints{
    [self removeConstraints:_constraints];
    _constraints = nil;
    [self setNeedsLayout];
    [self setNeedsUpdateConstraints];
}

- (CGSize)intrinsicContentSize{
    return CGSizeMake(UIViewNoIntrinsicMetric, ((self.labels.count > 0) ? (_sliderHeight/2.0 + _lineSize.height/2.0 + _padding + [[self.labels firstObject] intrinsicContentSize].height) : UIViewNoIntrinsicMetric));
}

#pragma mark Properties

- (void)setSteps:(NSArray<NSString *> *)steps{
    if (_steps != steps) {
        _steps = steps;
        
        for (UIView* view in self.verticalLines) {
            [view removeFromSuperview];
        }
        for (UIView* view in self.labels) {
            [view removeFromSuperview];
        }
        
        NSMutableArray* labels = [NSMutableArray arrayWithCapacity:steps.count];
        NSMutableArray* lines = [NSMutableArray arrayWithCapacity:steps.count];
        
        for (NSString* step in steps) {
            // add line
            UIView* line = [[UIView alloc] init];
            line.backgroundColor = self.color;
            line.translatesAutoresizingMaskIntoConstraints = NO;
            [lines addObject:line];
            [self addSubview:line];
            
            // add label
            UILabel* label = [[UILabel alloc] init];
            label.text = step;
            label.font = self.font;
            if (step == [steps firstObject]) {
                label.textAlignment = NSTextAlignmentLeft;
            } else if(step == [steps lastObject]){
                label.textAlignment = NSTextAlignmentRight;
            } else {
                label.textAlignment = NSTextAlignmentCenter;
            }
            label.translatesAutoresizingMaskIntoConstraints = NO;
            [labels addObject:label];
            [self addSubview:label];
        }
        self.labels = labels;
        self.verticalLines = lines;
        
        self.activeIndexes = [NSIndexSet indexSet];
        
        [self invalidateConstraints];
    }
}

- (void)setLineSize:(CGSize)lineSize{
    _lineSize = lineSize;
    [self invalidateConstraints];
}

- (void)setPadding:(CGFloat)padding{
    _padding = padding;
    [self invalidateConstraints];
}

- (void)setSliderHeight:(CGFloat)sliderHeight{
    _sliderHeight = sliderHeight;
    [self invalidateConstraints];
}

- (void)setActiveIndexes:(NSIndexSet *)activeIndexes{
    __block NSUInteger maxIndex = 0;
    __block NSUInteger minIndex = self.steps.count;
    [activeIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        if (idx > maxIndex) {
            maxIndex = idx;
        }
        if (idx < minIndex) {
            minIndex = idx;
        }
    }];
    
    for (int i = 0; i<self.labels.count; i++) {
        if ([activeIndexes containsIndex:i]) {
            self.labels[i].textColor = self.activeColor;
        } else {
            self.labels[i].textColor = self.color;
        }
    }
    
    // do not highlight if range has not been modified and goes from 0 - MAX
    BOOL isDefaultSetting = (minIndex == 0 && maxIndex == self.steps.count-1);
    
    for (NSUInteger i = 0; i < self.steps.count; i++) {
        if (i < minIndex || i > maxIndex || isDefaultSetting) {
            self.verticalLines[i].backgroundColor = self.color;
            self.labels[i].textColor = self.color;
        } else {
            self.verticalLines[i].backgroundColor = self.activeColor;
            self.labels[i].textColor = self.activeColor;
        }
    }
    [self setNeedsLayout];
}

#pragma mark UIView

- (void)updateConstraints{
    if (!_constraints) {
        NSMutableArray* constraints = [NSMutableArray array];
        
        if (!self.steps.count){
            [super updateConstraints];
            return;
        }

        int i = 0;
        NSMutableString* format = nil;
        NSDictionary* metrics = nil;
        NSMutableDictionary* views = nil;

        // Set up line constraints
        [constraints addObject:[NSLayoutConstraint constraintWithItem:[self.verticalLines firstObject] attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:(_sliderHeight-_lineSize.height)/2.0]];
        
        views = [NSMutableDictionary dictionaryWithCapacity:self.verticalLines.count];
        format = [NSMutableString string];
        metrics = @{@"width" : @(_lineSize.width)};
        i = 0;
        for (UIView* view in self.verticalLines) {
            double multiplier = ((double)i)/(((double)self.steps.count)-1.0);
            if (multiplier<=0) {
                [constraints addObject:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
            } else {
                [constraints addObject:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:multiplier constant:0.0]];
            }
            
            [constraints addObject:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:_lineSize.height]];
            
            NSString* key = [NSString stringWithFormat:@"view%d", i];
            views[key] = view;
            [format appendFormat:@"-(>=0)-[%@(==width)]", key];
            i++;
        }
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|%@", format] options:NSLayoutFormatAlignAllCenterY metrics:metrics views:views]];
        
        // Set up label constraints
        [constraints addObject:[NSLayoutConstraint constraintWithItem:[self.labels firstObject] attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-5.0]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:[self.labels lastObject] attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationLessThanOrEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:5.0]];
        
        i = 0;
        format = [NSMutableString string];
        views = [NSMutableDictionary dictionaryWithCapacity:self.labels.count];
        for (UIView* view in self.labels) {
            NSLayoutConstraint* centerConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.verticalLines[i] attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
            centerConstraint.priority = UILayoutPriorityDefaultLow;
            [constraints addObject:centerConstraint];
            
            [constraints addObject:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:_sliderHeight+_padding]];
            if (i != 0) {
            }
            ++i;
        }
        _constraints = constraints;
        [self addConstraints:constraints];
        
        [self invalidateIntrinsicContentSize];
    }
    
    [super updateConstraints];
}

@end
