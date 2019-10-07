//
//  GFViewController.m
//  GFImageFullScreen
//
//  Created by guidosette on 10/07/2019.
//  Copyright (c) 2019 guidosette. All rights reserved.
//

#import "GFViewController.h"
#import "GFImageFullScreen.h"

@interface GFViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (strong, nonatomic) IBOutlet UISlider *imageSize;
@property (strong, nonatomic) IBOutlet UISlider *borderWidth;
@property (strong, nonatomic) IBOutlet UISlider *cornerRadius;
@property (strong, nonatomic) IBOutlet UISwitch *imageOn;
@property (strong, nonatomic) IBOutlet UILabel *borderWidthLabel;
@property (strong, nonatomic) IBOutlet UILabel *imageSizeLabel;
@property (strong, nonatomic) IBOutlet UILabel *cornerRadiusLabel;
@property (strong, nonatomic) IBOutlet UIView *colorBackgroundView;
@property (strong, nonatomic) IBOutlet UIView *colorSpinnerStrokeView;

@end

@implementation GFViewController {
	UIColor* colorBackground;
	UIColor* colorBorder;
	float margin;
	
	bool settingColorCircleBackground;

}

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	_image.userInteractionEnabled = true;
	[_image addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageToFullScreen)]];
	
	[_imageSize addTarget:self action:@selector(onChangeImageSize:) forControlEvents:UIControlEventValueChanged];
	[_borderWidth addTarget:self action:@selector(onChangeBorderWidth:) forControlEvents:UIControlEventValueChanged];
	[_cornerRadius addTarget:self action:@selector(onChangeCornerRadius:) forControlEvents:UIControlEventValueChanged];
	_imageSizeLabel.text = [NSString stringWithFormat:@"%.0f", _imageSize.value];
	_borderWidthLabel.text = [NSString stringWithFormat:@"%.0f", _borderWidth.value];
	_cornerRadiusLabel.text = [NSString stringWithFormat:@"%.0f", _cornerRadius.value];
	colorBackground = [UIColor whiteColor];
	colorBorder = [UIColor grayColor];
	margin = 20;
}

-(void)showImageToFullScreen {
	[self setSettings];
	[GFImageFullScreen showFromImageView:_image];
}

- (void)setSettings {
//	image
	[GFImageFullScreen setCornerRadius:_cornerRadius.value];
	[GFImageFullScreen setMargin:_imageSize.value];
	[GFImageFullScreen setBackgroundColor:colorBackground];
//	border
	[GFImageFullScreen setBorderColor:colorBorder];
	[GFImageFullScreen setBorderWidth:_borderWidth.value];
}

- (IBAction)onChangeImageSize:(UISlider *)sender {
	_imageSizeLabel.text = [NSString stringWithFormat:@"%.0f", sender.value];
	[GFImageFullScreen setCustomLayout:true];
}

- (IBAction)onChangeBorderWidth:(UISlider *)sender {
	_borderWidthLabel.text = [NSString stringWithFormat:@"%.0f", sender.value];
	[GFImageFullScreen setCustomLayout:true];
}

- (IBAction)onChangeCornerRadius:(UISlider *)sender {
	_cornerRadiusLabel.text = [NSString stringWithFormat:@"%.0f", sender.value];
	[GFImageFullScreen setCustomLayout:true];
}

- (IBAction)chooseColor:(id)sender {
    FCColorPickerViewController *colorPicker = [FCColorPickerViewController colorPicker];
	if (((UIView*)sender).tag == 1) {
		colorPicker.color = colorBackground;
		settingColorCircleBackground = true;
	} else {
		colorPicker.color = colorBorder;
		settingColorCircleBackground = false;
	}
    colorPicker.delegate = self;
    
    [colorPicker setModalPresentationStyle:UIModalPresentationFormSheet];
    [self presentViewController:colorPicker animated:YES completion:nil];
	
}

#pragma mark - FCColorPickerViewControllerDelegate Methods

- (void)colorPickerViewController:(FCColorPickerViewController *)colorPicker didSelectColor:(UIColor *)color {
	[GFImageFullScreen setCustomLayout:true];
	if (settingColorCircleBackground) {
		colorBackground = color;
		_colorBackgroundView.backgroundColor = color;
	} else {
		colorBorder = color;
		_colorSpinnerStrokeView.backgroundColor = color;
	}
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)colorPickerViewControllerDidCancel:(FCColorPickerViewController *)colorPicker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
