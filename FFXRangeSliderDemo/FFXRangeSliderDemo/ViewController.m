//
//  ViewController.m
//  FFXRangeSliderDemo
//
//  Created by Robert Biehl on 12/11/2015.
//  Copyright © 2015 Robert Biehl. All rights reserved.
//

#import "ViewController.h"

#import "FFXRangeSlider.h"

@interface ViewController ()

@property (nonatomic, strong) IBOutlet UILabel* label;
@property (nonatomic, strong) IBOutlet FFXRangeSlider* slider;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toggleSteps:(UISwitch*)sender{
    self.slider.steps = sender.on ? @[@"0", @"100", @"300", @"500", @"MAX"] : nil;
}
- (IBAction)toggleSelectTrackForDefaultSelection:(UISwitch*)sender{
    self.slider.selectTrackForDefaultSelection = sender.on;
}

- (IBAction)valueChanged:(FFXRangeSlider*)slider{
    self.label.text = [NSString stringWithFormat:@"%f - %f", slider.fromValue, slider.toValue];
}

@end
