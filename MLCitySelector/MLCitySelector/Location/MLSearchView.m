//
//  MLSearchView.m
//  MLCitySelector
//
//  Created by maweilong-PC on 2016/12/8.
//  Copyright © 2016年 maweilong. All rights reserved.
//

#import "MLSearchView.h"
static NSString *ID = @"searchCell";

@interface MLSearchView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *SearchTableView;

@end

@implementation MLSearchView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
    }
    return self;
}

-(void)setResultMutableArray:(NSMutableArray *)ResultMutableArray{
    _ResultMutableArray = ResultMutableArray;
    [self addSubview:self.SearchTableView];
    [_SearchTableView reloadData];
}
- (UITableView *)SearchTableView {
    if (!_SearchTableView) {
        _SearchTableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        [_SearchTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
        _SearchTableView.delegate = self;
        _SearchTableView.dataSource = self;
        _SearchTableView.backgroundColor = [UIColor clearColor];
    }
    return _SearchTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_ResultMutableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    NSDictionary *dataDic = _ResultMutableArray[indexPath.row];
    NSString *text = [NSString stringWithFormat:@"%@，%@",[dataDic valueForKey:@"city"],[dataDic valueForKey:@"super"]];
    cell.textLabel.text = text;
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dataDic = _ResultMutableArray[indexPath.row];
    if (![[dataDic valueForKey:@"city"] isEqualToString:@"抱歉"]) {
        if (self.resultBlock) {
            self.resultBlock(dataDic);
        }
    }
}

- (void)resultBlock:(MLSearchViewChoseCityReultBlock)block{
    self.resultBlock = block;
}

- (void)touchViewBlock:(MLSearchViewBlock)block{
    self.touchViewBlock = block;
}


@end
