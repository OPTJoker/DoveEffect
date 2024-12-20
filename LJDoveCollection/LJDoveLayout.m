//
//  CustomLayout.m
//  LJDoveCollection
//
//  Created by sharon on 2024/12/16.
//

#import "LJDoveLayout.h"

@interface LJDoveLayout ()
@property (nonatomic, assign) NSInteger itemCnt;
@property (nonatomic, strong) NSMutableArray *attributes;

@end

@implementation LJDoveLayout
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cardOffset = 80;
        super.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}

- (void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection {
    NSAssert(NO, @"不能修改滚动方向，目前只支持横向效果~");
}

- (CGSize)collectionViewContentSize {
    CGFloat cw = self.collectionView.bounds.size.width;
    CGFloat ch = self.collectionView.bounds.size.height;
    
    CGFloat w = self.itemCnt * cw;
    return CGSizeMake(w, ch);
}

- (CGFloat)cellWidth {
    if (_cellWidth <= 0.1) {
        _cellWidth = self.itemSize.width;
        if (_cellWidth <= 0.1) {
            _cellWidth = self.collectionView.bounds.size.width;
        }
    }
    return _cellWidth;
}
- (CGFloat)cellHeight {
    if (_cellHeight <= 0.1) {
        _cellHeight = self.itemSize.height;
        if (_cellHeight <= 0.1) {
            _cellHeight = self.collectionView.bounds.size.height;
        }
    }
    return _cellHeight;
}

//重写shouldInvalidateLayoutForBoundsChange,每次重写布局内部都会自动调用
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (void)reset {
    [self.attributes removeAllObjects];
    self.itemCnt = 0;
}

- (void)prepareLayout {
    [super prepareLayout];
    if (self.attributes.count > 0) {
        return;
    }
    
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
    NSInteger topmostIdx = offx/self.cellWidth;
    
    NSInteger i = indexPath.item;
    
    //创建布局实例
    UICollectionViewLayoutAttributes *attr = [self.attributes objectAtIndex:indexPath.item];
    
    attr.size = CGSizeMake(self.cellWidth, self.cellHeight);
    
    CGFloat xPosition = attr.frame.origin.x;
    
    UICollectionViewCell<LJDoveCellDelegate> *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    
    if (i < topmostIdx) {
        xPosition = offx-self.cellWidth;
    } else if (i == topmostIdx) {
        CGFloat relaX = fmod(offx, self.cellWidth);
        CGFloat res = topmostIdx*self.cellWidth;
        xPosition = res;

        // <LJDoveDelegate>
        /* 先直接帮用户改变contentView的偏移量，并开启裁切，如果有问题，再启用这段代码，让用户自己去控制contentView或其他layer层去做mask遮罩偏移效果
         */
        if ([cell respondsToSelector:@selector(progress:curIdx:topmostIdx:)]) {
            CGFloat pro = (double)relaX/(double)self.cellWidth;
            [cell progress:pro curIdx:i topmostIdx:topmostIdx];
        }
        
        // 下面这段是遮罩视差效果的核心代码
//        CGFloat scale = 1 - self.cardOffset/self.cellWidth;
//        CGFloat scalex = relaX * scale;
//        CGRect frm = cell.contentView.frame;
//        frm.origin.x = scalex;
//        cell.contentView.frame = frm;
//        cell.clipsToBounds = YES;
        
    } else if (i == topmostIdx + 1) {
        CGFloat relaX = fmod(offx, self.cellWidth);
        CGFloat res = offx + (1 - relaX/self.cellWidth) * self.cardOffset;
        xPosition = res;
        if ([cell respondsToSelector:@selector(progress:curIdx:topmostIdx:)]) {
            CGFloat pro = (double)relaX/(double)self.cellWidth;
            [cell progress:pro curIdx:i topmostIdx:topmostIdx];
        }
        
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
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    
    if (self.attributes.count == self.itemCnt && self.itemCnt > 0) {
        CGFloat offx = self.collectionView.contentOffset.x;
        //最上层卡片的idx
        NSInteger topmostIdx = offx/self.cellWidth;
        
        for (short i=topmostIdx-1; i<=topmostIdx+1; i++) {
            //保护数组别越界
            if (!(i<0 || i >= self.itemCnt)) {
                UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
                self.attributes[i] = attrs;
            }
        }
        return self.attributes;
        
    } else {
        NSMutableArray *arrayM = [NSMutableArray array];
        //给每一个item创建并设置布局属性
        for (int i = 0; i < count; i++)
        {
            //创建item的布局属性
            UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
            
             [arrayM addObject:attrs];
        }
        return arrayM;
    }
}


#pragma mark - lazy
- (NSMutableArray *)attributes {
    if (!_attributes) {
        _attributes = [NSMutableArray new];
    }
    return _attributes;
}


@end
