//
//  IMonthPicker.h
//  Practice
//
//  Created by xujunwu on 16/3/1.
//  Copyright © 2016年 xujunwu. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef IBInspectable
#define IBInspectable
#endif

@class IMonthPicker;

@protocol IMonthPickerDelegate <NSObject>

@optional
- (void)monthPickerWillChangeDate:(IMonthPicker *)monthPicker;
- (void)monthPickerDidChangeDate:(IMonthPicker *)monthPicker;

@end

@interface IMonthPicker : UIPickerView<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, weak) id<IMonthPickerDelegate> monthPickerDelegate;
@property (nonatomic, strong) IBInspectable NSDate* date;

@property (nonatomic, strong, readonly) NSCalendar *calendar;

@property (nonatomic) IBInspectable NSInteger minimumYear;

@property (nonatomic) IBInspectable NSInteger maximumYear;

@property (nonatomic) IBInspectable BOOL yearFirst;

@property (nonatomic) IBInspectable BOOL wrapMonths;

@property (nonatomic) BOOL enableColourRow;

@property (nonatomic, getter = enableColourRow, setter = setEnableColourRow:) IBInspectable BOOL enableColorRow;

@property (nonatomic, strong) UIFont *font;

@property (nonatomic, strong) UIColor *fontColour;

@property (nonatomic, strong, getter = fontColour, setter = setFontColour:) IBInspectable UIColor *fontColor;

-(id)init;

-(id)initWithDate:(NSDate *)date;


-(id)initWithDate:(NSDate *)date calendar:(NSCalendar *)calendar;

@end
