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


@end
