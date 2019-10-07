//
//  GFImageFullScreen.m
//  Fanfa
//
//  Created by Guido Fanfani on 07/10/19.
//  Copyright © 2019 Fanfa. All rights reserved.
//

#import "GFImageFullScreen.h"

@interface GFImageFullScreen ()

@property bool isShow;
@property bool isAnimation;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewFullScreen;
@property (strong, nonatomic) IBOutlet UIView *viewBackground;
@property CGRect screenRect;
@property CGRect prevFrame;
@property float animationDuration;
@property float margin;


@property (nonatomic, assign) float firstX;
@property (nonatomic, assign) float firstY;
@property (nonatomic, assign) float MIN_OFFSET;
@property (nonatomic, assign) float alphaBackground;

@property float borderWidth;
@property float cornerRadius;
@property (nonatomic, strong) UIColor* borderColor;
@property (nonatomic, strong) UIColor* backgroundColor;

@end

@implementation GFImageFullScreen

+ (instancetype)privateInstance {
	static dispatch_once_t once;
	static GFImageFullScreen *privateInstance;
	dispatch_once(&once, ^{
		privateInstance = [[self alloc] init];
	});
	return privateInstance;
}

- (id)init {
	self = [super init];
	if (self) {
		_isShow = true;
		
		self = [[NSBundle bundleForClass:self.classForCoder] loadNibNamed:@"GFImageFullScreen.bundle/GFImageFullScreen" owner:self options:nil][0];
		
		self.backgroundColor = [UIColor clearColor];
		
		// Get the size of the entire screen
		_screenRect = [[UIScreen mainScreen] bounds];
		self.frame = CGRectMake(0, 0, _screenRect.size.width, _screenRect.size.height);
		//        _viewBackground.backgroundColor = [UIColor colorWithWhite:0.2
		//                                                            alpha:0.7];
		_viewBackground.frame = _screenRect;
		
		[_viewBackground addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeFullScreen)]];
		[_imageViewFullScreen addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeFullScreen)]];
		UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
		panGesture.minimumNumberOfTouches = 1;
		panGesture.maximumNumberOfTouches = 1;
		[_imageViewFullScreen addGestureRecognizer:panGesture];
		
		UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
		[keyWindow addSubview:self];
		
		[self initDefaults];
		
	}
	return self;
}

- (void)initDefaults {
	_animationDuration = 0.3;
	_MIN_OFFSET = 100;
	_alphaBackground = 0.95;
	
	_margin = 20;
	_borderWidth = 4;
	_cornerRadius = -1;
	_borderColor = [UIColor whiteColor];
	_backgroundColor = [UIColor clearColor];
}

- (void)updateLayout:(UIImageView*)imageView {
	self.frame = _screenRect;
	_viewBackground.frame = _screenRect;
	_viewBackground.backgroundColor = [UIColor colorWithWhite:0.2
														alpha:_alphaBackground];
	CGPoint point = [imageView.superview convertPoint:imageView.frame.origin toView:nil];
	CGRect rect = CGRectMake(point.x, point.y, imageView.bounds.size.width, imageView.bounds.size.height);
	_prevFrame = rect;
	_imageViewFullScreen.frame = rect;
	_imageViewFullScreen.image = imageView.image;
	_imageViewFullScreen.layer.cornerRadius = imageView.layer.cornerRadius;
	_imageViewFullScreen.layer.masksToBounds = true;
	_imageViewFullScreen.layer.borderWidth = _borderWidth;
	_imageViewFullScreen.layer.borderColor = _borderColor.CGColor;
	_imageViewFullScreen.backgroundColor = _backgroundColor;
}

+ (void)showFromImageView:(UIImageView*)imageView {
	GFImageFullScreen *view = [GFImageFullScreen privateInstance];
	if (view.isAnimation) {
		return;
	}
	[view.layer removeAllAnimations];
	view.isShow = true;
	view.isAnimation = true;
	
	[view updateLayout:imageView];
	
	UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
	[UIView animateWithDuration:view.animationDuration
						  delay:0.0
						options: UIViewAnimationOptionCurveEaseInOut
					 animations:^{
		[keyWindow addSubview:view];
		float width = [UIScreen mainScreen].bounds.size.width - view.margin*2.0f;
		CGRect rect = CGRectMake(view.margin, [UIScreen mainScreen].bounds.size.height/2.0f - width/2.0f, width, width);
		view.imageViewFullScreen.layer.cornerRadius = width/2.0f;
		[view.imageViewFullScreen setFrame:rect];
		[view.imageViewFullScreen layoutIfNeeded];
	}
					 completion:^(BOOL finished) {
		view.isAnimation = false;
	}];
}

- (void)closeFullScreen {
	if (_isAnimation) {
		return;
	}
	_isAnimation = true;
	[self.layer removeAllAnimations];
	[UIView animateWithDuration:_animationDuration
						  delay:0.0
						options: UIViewAnimationOptionCurveEaseInOut
					 animations:^{
		self->_imageViewFullScreen.layer.cornerRadius = self->_prevFrame.size.width/2;
		[self->_imageViewFullScreen setFrame:self->_prevFrame];
		[self->_imageViewFullScreen layoutIfNeeded];
		[self layoutIfNeeded];
	}
					 completion:^(BOOL finished){
		[self removeFromSuperview];
		self->_isAnimation = false;
		self->_isShow = false;
	}];
}


- (void)panGestureRecognizer:(UIPanGestureRecognizer *)sender{
	[self.imageViewFullScreen bringSubviewToFront:sender.view];
	CGPoint translatedPoint = [sender translationInView:sender.view.superview];
	translatedPoint = CGPointMake(sender.view.center.x+translatedPoint.x, sender.view.center.y+translatedPoint.y);
	[sender.view setCenter:translatedPoint];
	[sender setTranslation:CGPointZero inView:sender.view];
	switch(sender.state){
		case UIGestureRecognizerStateBegan: {
			_firstX = sender.view.center.x;
			_firstY = sender.view.center.y;
			break;
		}
		case UIGestureRecognizerStateChanged: {
			float translation = MAX(ABS(translatedPoint.x-_firstX), ABS(translatedPoint.y-_firstY));
			float perc = translation / _MIN_OFFSET;
			if (perc > _alphaBackground) {
				perc = _alphaBackground;
			}
			perc = _alphaBackground-perc;
			self.viewBackground.backgroundColor = [UIColor colorWithWhite:0.2
																	alpha:perc];
			break;
		}
		case UIGestureRecognizerStateEnded: {
			float translation = MAX(ABS(translatedPoint.x-_firstX), ABS(translatedPoint.y-_firstY));
			if (translation > _MIN_OFFSET) {
				[self closeFullScreen];
			} else {
				_viewBackground.backgroundColor = [UIColor colorWithWhite:0.2
																	alpha:_alphaBackground];
				CGFloat velocityX = (0.2*[sender velocityInView:self.imageViewFullScreen].x);
				CGFloat velocityY = (0.2*[sender velocityInView:self.imageViewFullScreen].y);
				CGFloat animationDuration = (ABS(MIN(velocityX, velocityY))*.0002)+.2;
				[UIView beginAnimations:nil context:NULL];
				[UIView setAnimationDuration:animationDuration];
				[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
				[UIView setAnimationDelegate:self];
				[UIView setAnimationDidStopSelector:@selector(animationPanDidFinish)];
				[[sender view] setCenter:CGPointMake(_firstX, _firstY)];
				[UIView commitAnimations];
			}
			
			break;
		}
		default: {
			break;
		}
	}
}

- (void)animationPanDidFinish {
	
}

#pragma mrk - Customizable

+ (void)setBackgroundColor:(UIColor*)color {
	GFImageFullScreen *instance = [GFImageFullScreen privateInstance];
	instance.backgroundColor =  color;
}

+ (void)setBorderColor:(UIColor*)color {
	GFImageFullScreen *instance = [GFImageFullScreen privateInstance];
	instance.borderColor =  color;
}

+ (void)setBorderWidth:(int)width {
	GFImageFullScreen *instance = [GFImageFullScreen privateInstance];
	instance.borderWidth = width;
}

+ (void)setCornerRadius:(int)radius {
	GFImageFullScreen *instance = [GFImageFullScreen privateInstance];
	instance.cornerRadius = radius;
}

+ (void)setMargin:(float)magin {
	GFImageFullScreen *instance = [GFImageFullScreen privateInstance];
	instance.margin = magin;
}

@end
