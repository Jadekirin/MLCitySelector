//
//  MLCityViewController.m
//  MLCitySelector
//
//  Created by maweilong-PC on 2016/12/6.
//  Copyright © 2016年 maweilong. All rights reserved.
//

#import "MLCityViewController.h"
#import "MLCityTableViewCell.h"
#import "MLAreaDataManager.h"
#import "Location.h"
#import "ChineseSorting.h"
#import "MLCityHeaderView.h"
#import "MLSearchView.h"

#define KCURRENTCITYINFODEFAULTS [NSUserDefaults standardUserDefaults]

@interface MLCityViewController () <UITableViewDelegate,UITableViewDataSource,MLocationDelegate>
{
    NSMutableArray *_indexMutableArray;   //存字母索引下标数组
    NSMutableArray *_sectionMutableArray; //存处理过以后的数组
    NSInteger      _HeaderSectionTotal;   //头section的个数
    CGFloat        _cellHeight;           // 添加的(显示区县名称)cell的高度
}

@property (nonatomic,strong) UITableView *rootTableView;
@property (nonatomic,strong) MLCityTableViewCell *cell;
@property (nonatomic,strong) MLAreaDataManager *manager;
@property (nonatomic,strong) Location *locationManager;
@property (nonatomic,strong) MLCityHeaderView *CityHeaderView;
@property (nonatomic,strong) MLSearchView *searchView;

//所有市级城市的名称
@property (nonatomic,strong) NSMutableArray *cityMutableArray;
//根据citynumber在数据库查到的区县
@property (nonatomic,strong) NSMutableArray *areaMutableArray;
//历史搜索城市
@property (nonatomic,strong) NSMutableArray *historyCityMutableArray;
//热门城市
@property (nonatomic,strong) NSArray *hotCityMutableArray;


@end

@implementation MLCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _HeaderSectionTotal = 3;
    
    //注册选中城市时候得通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseCityWithName:) name:MLCityTableViewCellDidChangeCityNotification object:nil];
    
    //创建返回键
    [self createButton];
    //初始化数组
   // [self SetValueArray];
    
    //初始化数据库  获取“市”级城市的名称
    [self initWithMLAreaDataManager];
    [self.view addSubview:self.rootTableView];
    self.rootTableView.tableHeaderView = self.CityHeaderView;
    [self.rootTableView reloadData];
   // _manager = [[MLAreaDataManager alloc] init];
//
}

#pragma mark - 创建返回键
- (void)createButton{
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [leftButton addTarget:self action:@selector(backrootTableViewController) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setTitle:@"<返回" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
}

#pragma mark - 初始化数组
- (NSMutableArray *)historyCityMutableArray {
    if (!_historyCityMutableArray) {
        _historyCityMutableArray = [[NSMutableArray alloc] init];
        

    }
    
    return _historyCityMutableArray;
}

- (NSArray *)hotCityMutableArray {
    if (!_hotCityMutableArray) {
        _hotCityMutableArray = @[@"北京市", @"上海市", @"广州市", @"深圳市", @"武汉市", @"天津市", @"西安市", @"南京市", @"杭州市", @"成都市", @"重庆市"];
    }
    return _hotCityMutableArray;
}

- (NSMutableArray *)characterMutableArray {
    if (!_characterMutableArray) {
        _characterMutableArray = [NSMutableArray arrayWithObjects:@"!", @"#", @"$", nil];
    }
    return _characterMutableArray;
}

- (NSMutableArray *)areaMutableArray {
    if (!_areaMutableArray) {
        _areaMutableArray = [NSMutableArray arrayWithObject:@"全城"];
    }
    return _areaMutableArray;
}
#pragma mark - 初始化数据库  获取“市”级城市的名称
- (void)initWithMLAreaDataManager{
    _manager = [MLAreaDataManager shareManager];
    [_manager areaSqliteDBData];
    // 获取所有市区的名称
    [_manager cityData:^(NSMutableArray *dataArray) {
        _cityMutableArray =dataArray;
    }];
    
    //处理得到的数据  按字母顺序排列
    _indexMutableArray = [NSMutableArray new];
    _sectionMutableArray = [NSMutableArray array];
    if ([KCURRENTCITYINFODEFAULTS objectForKey:@"cityData"]) {
        self.characterMutableArray = [NSKeyedUnarchiver unarchiveObjectWithData:[KCURRENTCITYINFODEFAULTS objectForKey:@"cityData"]];
        _sectionMutableArray = [NSKeyedUnarchiver unarchiveObjectWithData:[KCURRENTCITYINFODEFAULTS objectForKey:@"sectionData"]];
        [_rootTableView reloadData];
    }else{
        //在子线程中异步执行汉字转拼音再转汉字的耗时操作
        dispatch_queue_t serialQueue = dispatch_queue_create("com.city.www", DISPATCH_QUEUE_SERIAL);
        dispatch_async(serialQueue, ^{
            ChineseSorting *sort = [[ChineseSorting alloc] init];
            [sort processData:_cityMutableArray block:^(NSMutableArray *indexArray, NSMutableArray *resultArray, NSMutableArray *charaterArray) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    _indexMutableArray = indexArray;
                    _sectionMutableArray = resultArray;
                    [self.characterMutableArray addObjectsFromArray:charaterArray];
                    NSData *cityData = [NSKeyedArchiver archivedDataWithRootObject:self.characterMutableArray];
                    NSData *sectionData = [NSKeyedArchiver archivedDataWithRootObject:_sectionMutableArray];
                    
                    //拼音转换太耗时，这里把第一次转换结果存到单例中
                    [KCURRENTCITYINFODEFAULTS setValue:cityData forKey:@"cityData"];
                    [KCURRENTCITYINFODEFAULTS setObject:sectionData forKey:@"sectionData"];

                    [_rootTableView reloadData];
                    self.locationManager = [[Location alloc] init];
                    _locationManager.delegate = self;
                });
               
            }];
        });
    }
    if ([NSKeyedUnarchiver unarchiveObjectWithData:[KCURRENTCITYINFODEFAULTS objectForKey:@"historyCity"]]) {
         self.historyCityMutableArray = [NSKeyedUnarchiver unarchiveObjectWithData:[KCURRENTCITYINFODEFAULTS objectForKey:@"historyCity"]];
    }
   
    
}



#pragma  mark - 返回按钮
- (void)backrootTableViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 添加历史访问城市
- (void)historyCity:(NSString *)city{
    //避免重复添加 先删除再添加
    [_historyCityMutableArray removeObject:city];
    [_historyCityMutableArray insertObject:city atIndex:0];
    if (_historyCityMutableArray.count > 3) {
        [_historyCityMutableArray removeLastObject];
    }
    //存储数据
    NSData *historyCityData = [NSKeyedArchiver archivedDataWithRootObject:self.historyCityMutableArray];
    [KCURRENTCITYINFODEFAULTS setObject:historyCityData forKey:@"historyCity"];
}

#pragma mark - tableView
- (UITableView *)rootTableView{
    if (!_rootTableView) {
        _rootTableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        _rootTableView.delegate = self;
        _rootTableView.dataSource = self;
        _rootTableView.sectionIndexColor = [UIColor colorWithRed:0/255.0f green:132/255.0f blue:255/255.0f alpha:1];
        [_rootTableView registerClass:[MLCityTableViewCell class] forCellReuseIdentifier:@"cityCell"];
        [_rootTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cityNameCell"];
    }
    return _rootTableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  self.characterMutableArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section < _HeaderSectionTotal ? 1 : [_sectionMutableArray[0][self.characterMutableArray[section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section < _HeaderSectionTotal) {
        self.cell = [tableView dequeueReusableCellWithIdentifier:@"cityCell" forIndexPath:indexPath];
        if (_HeaderSectionTotal == 4 && indexPath.section == 0) {
            _cell.cityNameArray = _areaMutableArray;
        }
        if (indexPath.section == _HeaderSectionTotal - 3) {
            NSString *locationCity = [KCURRENTCITYINFODEFAULTS objectForKey:@"locationCity"];
            _cell.cityNameArray = locationCity ? @[locationCity]:@[@"正在定位..."];
        }
        if (indexPath.section == _HeaderSectionTotal - 2) {
            _cell.cityNameArray = self.historyCityMutableArray;
        }
        if (indexPath.section == _HeaderSectionTotal - 1) {
            _cell.cityNameArray = self.hotCityMutableArray;
        }
        return _cell;
    }else{
    
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cityNameCell" forIndexPath:indexPath];
        NSArray *currentArray = _sectionMutableArray[0][self.characterMutableArray[indexPath.section]];
        cell.textLabel.text = currentArray[indexPath.row];
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_HeaderSectionTotal == 4 && indexPath.section == 0) {
        return  _cellHeight;
    }else{
        return indexPath.section == (_HeaderSectionTotal - 1)? 200 :44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_HeaderSectionTotal == 4 && section == 0) {
        return 0;
    }else{
        return 40;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (_HeaderSectionTotal == 3) {
        switch (section) {
            case 0:
                return @"定位城市";
                break;
            case 1:
                return @"最近访问的城市";
                break;
            case 2:
                return @"热门城市";
                break;
            default:
                return self.characterMutableArray[section];
                break;
        }
    }else {
        switch (section) {
            case 1:
                return @"定位城市";
                break;
            case 2:
                return @"最近访问的城市";
                break;
            case 3:
                return @"热门城市";
                break;
            default:
                return self.characterMutableArray[section];
                break;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (self.choseCityBlock) {
        self.choseCityBlock(cell.textLabel.text);
    }
    _CityHeaderView.CityName = cell.textLabel.text;
    [KCURRENTCITYINFODEFAULTS setObject:cell.textLabel.text forKey:@"currentCity"];
    [KCURRENTCITYINFODEFAULTS setObject:cell.textLabel.text forKey:@"currentCity"];
    [_manager cityNumberWithCity:cell.textLabel.text cityNumber:^(NSString *cityNumber) {
        [KCURRENTCITYINFODEFAULTS setObject:cityNumber forKey:@"cityNumber"];
    }];
    [self historyCity:cell.textLabel.text];
    [self dismissViewControllerAnimated:YES completion:nil];
}
//设置右侧的索引标题，这里返回一个数组
- ( NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.characterMutableArray;
}

#pragma mark - 设置头视图
- (MLCityHeaderView *)CityHeaderView{
    if (!_CityHeaderView) {
        _CityHeaderView = [[MLCityHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 80)];
        _CityHeaderView.backgroundColor = [UIColor whiteColor];
        _CityHeaderView.buttonTitle = @"选择县区";
        _CityHeaderView.CityName = [KCURRENTCITYINFODEFAULTS objectForKey:@"currentCity"] ? [KCURRENTCITYINFODEFAULTS objectForKey:@"currentCity"] : [KCURRENTCITYINFODEFAULTS objectForKey:@"locationCity"];
        //获取当前城市下的所有辖区
        [self GetAearOfCurrentCity];
        
    }
    return _CityHeaderView;
}
#pragma mark-- headerView的JFCityHeaderViewSearchBlock
- (void)GetAearOfCurrentCity{
    //_manager = [[MLAreaDataManager alloc] init];
    [_CityHeaderView cityNameBlock:^(BOOL selected) {
        if (selected) {
            [_manager areaData:[KCURRENTCITYINFODEFAULTS objectForKey:@"cityNumber"] areaData:^(NSMutableArray *areaData) {
                [self.areaMutableArray addObjectsFromArray:areaData];
                if ((self.areaMutableArray.count%3) == 0) {
                    _cellHeight = self.areaMutableArray.count/3*50;
                }else{
                    _cellHeight = (self.areaMutableArray.count/3+1)*50;
                }
                if (_cellHeight >300) {
                    _cellHeight = 300;
                }
            }];
            //添加一行cell
            [_rootTableView endUpdates];
            [_characterMutableArray insertObject:@"*" atIndex:0];
            _HeaderSectionTotal = 4;
            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
            [self.rootTableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
            [_rootTableView endUpdates];
        }else{
            //清空辖区数组
            self.areaMutableArray = nil;
            //删除一行cell
            [_rootTableView endUpdates];
            [_characterMutableArray removeObjectAtIndex:0];
            _HeaderSectionTotal = 3;
            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
            [self.rootTableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
            [_rootTableView endUpdates];
        }
    }];
    
#pragma mark - 头部搜索
    __weak typeof(self) weakSelf = self;
    [_CityHeaderView beginSearchBlock:^{
        [weakSelf.view addSubview:weakSelf.searchView];
    }];
    [_CityHeaderView didSearchBlock:^{
        //移除searchView
        [_searchView removeFromSuperview];
        _searchView = nil;
    }];
    [_CityHeaderView searchResultBlock:^(NSString *result) {
       [weakSelf.manager searchCityData:result result:^(NSMutableArray *result) {
           if ([result count] > 0)  {
               _searchView.backgroundColor = [UIColor whiteColor];
               _searchView.ResultMutableArray = result;
           }
       }];
    }];
    
}


#pragma mark - 创建搜索View
- (MLSearchView *)searchView{
    if (!_searchView) {
         CGRect frame = [UIScreen mainScreen].bounds;
        _searchView = [[MLSearchView alloc] initWithFrame:CGRectMake(0, 104, frame.size.width, frame.size.height  - 104)];
        _searchView.backgroundColor = [UIColor colorWithRed:155/255 green:155/255 blue:155/255 alpha:0.5];
        __weak typeof(self) weakSelf = self;
        [_searchView resultBlock:^(NSDictionary *cityData) {
            [KCURRENTCITYINFODEFAULTS setObject:[cityData valueForKey:@"city"] forKey:@"currentCity"];
            [KCURRENTCITYINFODEFAULTS setObject:[cityData valueForKey:@"city_number"] forKey:@"cityNumber"];
            if (weakSelf.choseCityBlock) {
                weakSelf.choseCityBlock([cityData valueForKey:@"city"]);
            }
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
            [self historyCity:[cityData valueForKey:@"city"]];
        }];
        [_searchView touchViewBlock:^{
            [weakSelf.CityHeaderView cancelSearch];
        }];
    }
    return _searchView;
}


#pragma mark - 定位代理
- (void)locating{
    NSLog(@"定位中.....");
}
//定位成功
- (void)currentLocation:(NSDictionary *)locationDictionary{
    NSString *city = [locationDictionary valueForKey:@"City"];
    [KCURRENTCITYINFODEFAULTS setObject:city forKey:@"locationCity"];
    [_manager cityNumberWithCity:city cityNumber:^(NSString *cityNumber) {
        [KCURRENTCITYINFODEFAULTS setObject:cityNumber forKey:@"cityNumber"];
    }];
    _CityHeaderView.CityName = city;
    [self historyCity:city];
    [_rootTableView reloadData];
}

/// 拒绝定位
- (void)refuseToUsePositioningSystem:(NSString *)message {
    NSLog(@"%@",message);
}

/// 定位失败
- (void)locateFailure:(NSString *)message {
    NSLog(@"%@",message);
}
#pragma mark - 选择城市通知回调事件
- (void)chooseCityWithName:(NSNotification *)info{
    NSDictionary *cityDic = info.userInfo;
    NSString *cityName = [[NSString alloc] init];
    
    if ([[cityDic valueForKey:@"cityName"] isEqualToString:@"全城"]) {
        __weak typeof(self) weakSelf = self;
        [_manager currentCity:[KCURRENTCITYINFODEFAULTS objectForKey:@"cityNumber"] currentCityName:^(NSString *name) {
            [KCURRENTCITYINFODEFAULTS setObject:name forKey:@"currentCity"];
            weakSelf.CityHeaderView.CityName = name;
            if (weakSelf.choseCityBlock) {
                weakSelf.choseCityBlock(name);
            }
        }];
    }else {
        cityName = [cityDic valueForKey:@"cityName"];
    _CityHeaderView.CityName = cityName;
    [KCURRENTCITYINFODEFAULTS setObject:[cityDic valueForKey:@"cityName"] forKey:@"currentCity"];
        
    [_manager cityNumberWithCity:cityName cityNumber:^(NSString *cityNumber) {
        [KCURRENTCITYINFODEFAULTS setObject:cityNumber forKey:@"cityNumber"];
    }];
    if (self.choseCityBlock) {
        self.choseCityBlock(cityName);
    }
    [self historyCity:cityName];
    }
    //销毁通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - block
- (void)choseCityBlock:(MLCityViewControllerBlock)block{
    _choseCityBlock = block;
}
@end
