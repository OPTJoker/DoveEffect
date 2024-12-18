//
//  CustomLayout.h
//  LJDoveCollection
//
//  Created by sharon on 2024/12/16.
//

#import <UIKit/UIKit.h>

#ifndef kCellH
#define kCellH 520.0
#endif

#ifndef kCellW
#define kCellW 375.0
#endif


NS_ASSUME_NONNULL_BEGIN


/// 沉浸式横滑容器 - 遮罩视差效果
/// 体验效果请戳：https://file.ljcdn.com/nebula/imghandle/common/tutieshi_592x1280_14s_1734489953939.gif
/// 使用方式：
/// LJDoveLayout *layout = [[LJDoveLayout alloc] init];
/// layout.cellWidth = 375;
/// layout.cellHeight = 520;
///
/// _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
///
@interface LJDoveLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) CGFloat cellWidth;
@property (nonatomic, assign) CGFloat cellHeight;

/// 卡片从右往左出现时候 视差效果的 偏移量 默认80
@property (nonatomic, assign) CGFloat cardOffset;

@end

NS_ASSUME_NONNULL_END
