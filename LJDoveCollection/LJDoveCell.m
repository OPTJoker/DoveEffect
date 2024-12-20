//
//  LJDoveCell.m
//  LJDoveCollection
//
//  Created by sharon on 2024/12/17.
//

#import "LJDoveCell.h"

#import "LJDoveLayout.h"

@interface LJDoveCell ()
<LJDoveCellDelegate>
@end


@implementation LJDoveCell

- (void)progress:(CGFloat)progress curIdx:(NSInteger)curIdx topmostIdx:(NSInteger)topmostIdx
{
    if (curIdx == topmostIdx) {
        NSLog(@"xllog pro:%.1f", progress);
    } else {
        
    }
}



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    [self addSubview:self.imgView];
    [self addSubview:self.lab];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.imgView.frame = self.bounds;
    self.lab.frame = CGRectMake(0, 30, self.bounds.size.width, 30);
}


- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
    }
    return _imgView;
}
- (UILabel *)lab {
    if (!_lab) {
        _lab = [[UILabel alloc] init];
        _lab.font = [UIFont boldSystemFontOfSize:20];
    }
    return _lab;
}
@end
