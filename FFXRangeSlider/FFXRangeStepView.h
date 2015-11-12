//
//  FFXRangeStepView.h
//  FFXRangeSliderDemo
//
//  Created by Robert Biehl on 12/11/2015.
//  Copyright © 2015 Robert Biehl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFXRangeStepView : UIView

@property (nonatomic, assign) CGSize lineSize;
@property (nonatomic, assign) CGFloat sliderHeight;
@property (nonatomic, assign) CGFloat padding;

@property (nonatomic, strong) UIFont* font;
@property (nonatomic, strong) UIColor* color;
@property (nonatomic, strong) UIColor* activeColor;
@property (nonatomic, strong) NSArray<NSString*>* steps;
@property (nonatomic, strong) NSIndexSet* activeIndexes;

@end
