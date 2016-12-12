//
//  MLCityHeaderView.m
//  MLCitySelector
//
//  Created by maweilong-PC on 2016/12/8.
//  Copyright © 2016年 maweilong. All rights reserved.
//

#import "MLCityHeaderView.h"
#import "MLButton.h"

@interface MLCityHeaderView () <UISearchBarDelegate>
@property (nonatomic,strong)   UILabel *currentCityLanbel;
@property (nonatomic,strong)   MLButton *ShowBtn;
@property (nonatomic,strong)   UISearchBar *searchBar;

@end

@implementation MLCityHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self addSearchBar];
        [self addLabels];
        [self addButton];
    }
    return self;
}

- (void)addSearchBar{
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.delegate = self;
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    searchBar.placeholder = @"输入城市名称";
    [self addSubview:searchBar];
    self.searchBar = searchBar;
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(self.bounds.size.width - 10);
        make.height.offset(40);
        make.top.equalTo(self.mas_top).offset(0);
    }];
}
- (void)setCityName:(NSString *)CityName {
    self.currentCityLanbel.text = CityName;
}

- (void)setButtonTitle:(NSString *)buttonTitle {
    self.ShowBtn.title = buttonTitle;
}
- (void)addLabels {
    UILabel *currentLabel = [[UILabel alloc] init];
    currentLabel.text = @"当前:";
    currentLabel.textAlignment = NSTextAlignmentLeft;
    currentLabel.textColor = [UIColor blackColor];
    currentLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:currentLabel];
    [currentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(40);
        make.height.offset(21);
        make.left.equalTo(self.mas_left).offset(10);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
    }];
    
    self.currentCityLanbel = [[UILabel alloc] init];
    self.currentCityLanbel.textColor  = [UIColor blackColor];
    self.currentCityLanbel.textAlignment = NSTextAlignmentLeft;
    self.currentCityLanbel.font = [UIFont systemFontOfSize:14];
    //self.currentCityLanbel.text = self.CityName;
    [self addSubview:self.currentCityLanbel];
    [self.currentCityLanbel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(200);
        make.height.offset(21);
        make.left.equalTo(currentLabel.mas_right).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
    }];
}

- (void)addButton {
    self.ShowBtn = [[MLButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 95, self.frame.size.height - 31, 75, 21)];
    [self.ShowBtn addTarget:self action:@selector(touchUpJFButtonEnevt:) forControlEvents:UIControlEventTouchUpInside];
    self.ShowBtn.imageName = @"down_arrow_icon1";
    //self.ShowBtn.title = @"选择区县";
    self.ShowBtn.titleColor = RGBAColor(155, 155, 155, 1.0);
    [self addSubview:self.ShowBtn];
}
- (void)touchUpJFButtonEnevt:(MLButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        sender.imageName = @"down_arrow_icon2";
    }else {
        sender.imageName = @"down_arrow_icon1";
    }
    if (self.cityNameBlock) {
        self.cityNameBlock(sender.selected);
    }
}

#pragma mark - block
- (void)cityNameBlock:(MLCityHeaderViewBlock)block{
    _cityNameBlock = block;
}

#pragma mark - 搜索 

//search开始编辑的时候调用
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;
    if (self.beginSearchBlock) {
        self.beginSearchBlock();
    }
}
//文本改变时立即调用
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchBar.text.length > 0) {
        if (self.searchResultBlock) {
            self.searchResultBlock(searchBar.text);
        }
    }
}

//点击键盘搜索按钮时调用
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if (searchBar.text.length > 0) {
                if (self.searchResultBlock) {
                    self.searchResultBlock(searchBar.text);
                }
            }
        NSLog(@"点击搜索按钮编辑的结果是%@",searchBar.text);
}

//点击取消按钮时调用
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self cancelSearch];
}

-(void)cancelSearch{
    [_searchBar resignFirstResponder];
    _searchBar.showsCancelButton = NO;
    _searchBar.text = nil;
    if (self.didSearchBlock) {
        self.didSearchBlock();
    }
}

- (void)beginSearchBlock:(MLCityHeaderViewSearchBlock)block{
    self.beginSearchBlock = block;
}

- (void)didSearchBlock:(MLCityHeaderViewSearchBlock)block{
    self.didSearchBlock = block;
    
}

- (void)searchResultBlock:(MLCityHeaderViewSearchResultBlock)block{
    self.searchResultBlock = block;
}

@end
