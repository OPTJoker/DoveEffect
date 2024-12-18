//
//  CustomLayout.m
//  LJDoveCollection
//
//  Created by sharon on 2024/12/16.
//

#import "LJDoveLayout.h"
//#import "LJDoveDelegate.h"

@interface LJDoveLayout ()
@property (nonatomic, assign) NSUInteger itemCnt;
@property (nonatomic, strong) NSMutableArray *attributes;

@end

@implementation LJDoveLayout
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cellWidth = kCellW;
        self.cellHeight = kCellH;
        self.cardOffset = 80;
    }
    return self;
}


- (CGFloat)cellWidth {
    if (_cellWidth <= 0.1) {
        NSIndexPath *idx = [NSIndexPath indexPathForItem:0 inSection:0];
        
        _cellWidth = self.itemSize.width;
    }
    return _cellWidth;
}

//重写shouldInvalidateLayoutForBoundsChange,每次重写布局内部都会自动调用
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}


- (void)prepareLayout {
    [super prepareLayout];
    
    self.itemCnt = [self.collectionView numberOfItemsInSection:0];
    
    for (short i=0; i<self.itemCnt; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        attr.size = CGSizeMake(self.cellWidth, self.cellHeight);
        CGFloat x = self.cardOffset;
        
        attr.frame = CGRectMake(x, 0, self.cellWidth, self.cellHeight);
        
        //小index在上，越靠后的卡片层级越低
        attr.zIndex = [self.collectionView numberOfItemsInSection:indexPath.section] - indexPath.item;
        [self.attributes addObject:attr];
    }
    
}


/// 重写layoutAttributesForItemAtIndexPath,返回每一个item的布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat offx = self.collectionView.contentOffset.x;
    //最上层卡片的idx
    NSUInteger topmostIdx = offx/self.cellWidth;
    // NSLog(@"xllog curIdx:%d", topmostIdx);
    //创建布局实例
    UICollectionViewLayoutAttributes *attr = [self.attributes objectAtIndex:indexPath.item];
    
    attr.size = CGSizeMake(self.cellWidth, self.cellHeight);
    
    CGFloat xPosition = attr.frame.origin.x;
    NSUInteger i = indexPath.item;
    
    
    if (i < topmostIdx) {
        xPosition = offx-self.cellWidth;
    } else if (i == topmostIdx) {
        CGFloat relaX = fmod(offx, self.cellWidth);
        CGFloat res = topmostIdx*self.cellWidth;
        xPosition = res;

        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
        
        // <LJDoveDelegate>
        /* 先直接帮用户改变contentView的偏移量，并开启裁切，如果有问题，再启用这段代码，让用户自己去控制contentView或其他layer层去做mask遮罩偏移效果
        if ([cell respondsToSelector:@selector(relativeOffx:curIdx:topmostIdx:)]) {
            [cell relativeOffx:relaX curIdx:i topmostIdx:topmostIdx];
        }*/
        
        // 下面这段是遮罩视差效果的核心代码
        CGFloat scale = 1 - self.cardOffset/self.cellWidth;
        CGFloat scalex = relaX * scale;
        CGRect frm = cell.contentView.frame;
        frm.origin.x = scalex;
        cell.contentView.frame = frm;
        cell.clipsToBounds = YES;
        
    } else if (i == topmostIdx + 1) {
        CGFloat relaX = fmod(offx, self.cellWidth);
        CGFloat res = offx + (1 - relaX/self.cellWidth) * self.cardOffset;
        xPosition = res;
        
    } else {
        xPosition = offx + self.cardOffset;
    }
    
    CGRect oriFrm = attr.frame;
    oriFrm.origin.x = xPosition;
    attr.frame = oriFrm;

    return attr;
}


////重写layoutAttributesForElementsInRect,设置所有cell的布局属性（包括item、header、footer）
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *arrayM = [NSMutableArray array];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    
    //给每一个item创建并设置布局属性
    for (int i = 0; i < count; i++)
    {
        //创建item的布局属性
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        
         [arrayM addObject:attrs];
    }
    return arrayM;
}


#pragma mark - lazy
- (NSMutableArray *)attributes {
    if (!_attributes) {
        _attributes = [NSMutableArray new];
    }
    return _attributes;
}


@end
