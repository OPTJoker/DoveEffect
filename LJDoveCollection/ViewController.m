//
//  ViewController.m
//  LJDoveCollection
//
//  Created by sharon on 2024/12/09.
//

#import "ViewController.h"
#import "LJDoveLayout.h"
#import "LJDoveCell.h"


@interface ViewController ()
<UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) LJDoveLayout *layout;



@end

@implementation ViewController

static NSString *kCellIDE = @"UICollectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerClass:[LJDoveCell class] forCellWithReuseIdentifier:kCellIDE];
    [self.view addSubview:self.collectionView];
    CGSize s = [UIScreen mainScreen].bounds.size;
    self.collectionView.frame = CGRectMake(0, 0, s.width, s.height);
}

#pragma mark - 事件

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 50; // 示例数据
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kCellW, kCellH);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LJDoveCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIDE forIndexPath:indexPath];
    //cell.backgroundColor = [UIColor colorWithHue:(CGFloat)indexPath.item / 10.0 saturation:1.0 brightness:1.0 alpha:1.0];
    
    UILabel *relab = [cell.contentView viewWithTag:911];
    UIImageView *reImg = [cell.contentView viewWithTag:912];
    if (!relab) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kCellW, 30)];
        lab.numberOfLines = 0;
        //lab.backgroundColor = UIColor.darkGrayColor;
        lab.tag = 911;
        lab.font = [UIFont boldSystemFontOfSize:20];
        [cell.contentView addSubview:lab];
        relab = lab;
    }
    if (!reImg) {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectZero];
        [cell.contentView addSubview:img];
        img.frame = cell.contentView.bounds;
        reImg = img;
        [cell.contentView bringSubviewToFront:relab];
    }
    
    
    NSString *s = [NSString stringWithFormat:@" idx: %ld", (long)indexPath.item];
    NSString *ts = s;
    for (short i=0; i<20; i++) {
        ts = [ts stringByAppendingString:s];
    }
    
    relab.text = ts;
    reImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld", (long)indexPath.item%5+1]];
    
    return cell;
}


#pragma mark - lazy
- (LJDoveLayout *)layout {
    if (!_layout) {
        _layout = [[LJDoveLayout alloc] init];
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _layout.minimumInteritemSpacing = 0;
        _layout.minimumLineSpacing = 0;
    }
    return _layout;
}


- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        LJDoveLayout *layout = [[LJDoveLayout alloc] init];
        layout.cellWidth = 375;
        layout.cellHeight = 520;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        
        _collectionView.pagingEnabled = YES;
        _collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
        _collectionView.dataSource = self;
        _collectionView.layer.borderColor = UIColor.yellowColor.CGColor;
    }
    return _collectionView;
}

@end
