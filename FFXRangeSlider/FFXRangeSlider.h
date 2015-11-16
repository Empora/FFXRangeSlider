//
//  FFXRangeSlider.h
//  FFXRangeSliderDemo
//
//  Created by Robert Biehl on 12/11/2015.
//  Copyright © 2015 Robert Biehl. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
IB_DESIGNABLE

/**
 *  @abstract The FFXRangeSlider class implements the range slider control.
 */
@interface FFXRangeSlider : UIControl

/**
 *  @abstract The slider's minimum value. The default value is 0.0. Should be lower than maxValue.
 */
@property (nonatomic, assign) IBInspectable CGFloat minValue;
/**
 *  @abstract The slider's maximum value. The default value is 1.0. Should be higher than minValue.
 */
@property (nonatomic, assign) IBInspectable CGFloat maxValue;
/**
 *  @abstract The minimum diapason between sliders. The default value is 0.1.
 */
@property (nonatomic, assign) IBInspectable CGFloat minInterval;
/**
 *  @abstract The color used to tint the selected range.
 */
@property (nonatomic, strong) IBInspectable UIColor *selectedTrackTintColor;// UI_APPEARANCE_SELECTOR;
/**
 *  @abstract Whether to highlight the track for default 0-MAX settings
 */
@property (nonatomic, assign) IBInspectable BOOL selectTrackForDefaultSelection;// UI_APPEARANCE_SELECTOR;


/**
 *  @abstract The slider's line width
 */
@property (nonatomic, assign) IBInspectable CGFloat trackWidth;

/**
 *  @abstract The slider's selected line segment width
 */
@property (nonatomic, assign) IBInspectable CGFloat selectedTrackWidth;

/**
 *  @abstract The color used to tint the unselected range.
 */
@property (nonatomic, strong) IBInspectable UIColor *trackTintColor;// UI_APPEARANCE_SELECTOR;
/**
 * @abstract Display steps on the slider's track
 */
@property (nonatomic, assign) IBInspectable NSArray<NSString*>* steps;

/**
 *  @abstract The slider's line width
 */
@property (nonatomic, assign) IBInspectable CGFloat handleDiameter;

/**
 *  @abstract The color used to tint the handle.
 */
@property (nonatomic, strong) IBInspectable UIColor *handleTintColor;// UI_APPEARANCE_SELECTOR;
/**
 *  @abstract The color used to tint the handle if the value has changed.
 */
@property (nonatomic, strong) IBInspectable UIColor *activeHandleTintColor;// UI_APPEARANCE_SELECTOR;
/**
 *  @abstract Handle border width. The default value is 0.0;
 */
@property (nonatomic, assign) IBInspectable CGFloat handleBorderWidth;// UI_APPEARANCE_SELECTOR;
/**
 *  @abstract Handle border width. The default value is [UIColor clearColor];
 */
@property (nonatomic, strong) IBInspectable UIColor* handleBorderColor;// UI_APPEARANCE_SELECTOR;


/**
 *  @abstract Edge insets for the whole slider
 */
@property (nonatomic, assign) IBInspectable UIEdgeInsets edgeInsets;// UI_APPEARANCE_SELECTOR;

/**
 *  @abstract The left handle's position. The default value is 0.0. this value will be pinned to min/max.
 */
@property (nonatomic, assign) IBInspectable CGFloat fromValue;
/**
 *  @abstract The right handle's position. The default value is 1.0. this value will be pinned to min/max.
 */
@property (nonatomic, assign) IBInspectable CGFloat toValue;

/**
 *  The font used in this control
 */
@property (nonatomic, strong) IBInspectable UIFont* font;

/**
 *  @abstract If the slider is stepped the fromIndex represents the left handle's index
 */
@property (nonatomic, assign) NSUInteger fromIndex;
/**
 *  @abstract If the slider is stepped the toIndex represents the right handle's index
 */
@property (nonatomic, assign) NSUInteger toIndex;

@end

NS_ASSUME_NONNULL_END