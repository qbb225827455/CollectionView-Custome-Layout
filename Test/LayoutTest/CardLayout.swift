//
//  CardLayout.swift
//  Test
//
//  Created by E35 PTW on 2025/1/6.
//

import UIKit

protocol CardLayoutDelegate: AnyObject {
    func cardScrollingType() -> LayoutModel.LayoutScrollingType
    func numberOfVisibleItems(in collectionView: UICollectionView) -> Int
    func spacingBetweenCard(in collectionView: UICollectionView) -> CGFloat
    func cardItemSize(in collectionView: UICollectionView) -> CGSize
}

class CardLayout: UICollectionViewLayout {
    
    weak var delegate: CardLayoutDelegate?
    
    // MARK: CollectionView Layout設定
    private var scrollDirection: LayoutModel.LayoutScrollingType {
        guard let delegate = delegate else { return .horizontal }
        return delegate.cardScrollingType()
    }
    
    private var contentSize: CGSize {
        guard let collectionView = collectionView else {
            return CGSize()
        }
        
        switch self.scrollDirection {
        case .vertical:
            let insets = collectionView.contentInset
            let w = collectionView.bounds.width - (insets.left + insets.right)
            
            let itemCount = CGFloat(collectionView.numberOfItems(inSection: 0))
            let h = collectionView.bounds.height * itemCount
            return CGSize(width: w, height: h)
            
        case .horizontal:
            let itemCount = CGFloat(collectionView.numberOfItems(inSection: 0))
            let w = collectionView.bounds.width * itemCount
            
            let insets = collectionView.contentInset
            let h = collectionView.bounds.height - (insets.top + insets.bottom)
            return CGSize(width: w, height: h)
        }
    }
    
    private var maximumVisibleItems: Int {
        guard let collectionView = collectionView,
              let delegate = delegate else {
            return 4
        }
        return delegate.numberOfVisibleItems(in: collectionView)
    }
    
    private var spacing: CGFloat {
        guard let collectionView = collectionView,
              let delegate = delegate else {
            return 16
        }
        return delegate.spacingBetweenCard(in: collectionView)
    }
    
    private var itemSize: CGSize {
        guard let collectionView = collectionView,
              let delegate = delegate else {
            return CGSize(width: 250, height: 400)
        }
        return delegate.cardItemSize(in: collectionView)
    }
    
    // MARK: -
    override open func prepare() {
        super.prepare()
        guard let collectionView = collectionView else {
            return
        }
        
        switch self.scrollDirection {
        case .vertical:
            collectionView.showsVerticalScrollIndicator = false
        case .horizontal:
            collectionView.showsHorizontalScrollIndicator = false
        }
    }
    
    override var collectionViewContentSize: CGSize {
        return self.contentSize
    }
    
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView else { return nil }
        
        // 計算當前可視項目的範圍
        let totalItemsCount = collectionView.numberOfItems(inSection: 0)
        var minVisibleIndex: Int!
        var maxVisibleIndex: Int!
        switch self.scrollDirection {
        case .vertical:
            minVisibleIndex = max(0, Int(collectionView.contentOffset.y) / Int(collectionView.bounds.height))
        case .horizontal:
            minVisibleIndex = max(0, Int(collectionView.contentOffset.x) / Int(collectionView.bounds.width))
        }
        maxVisibleIndex = min(totalItemsCount, minVisibleIndex + maximumVisibleItems)
        
        // 中心點計算(依據當前可視區域計算中心點)
        let contentCenterX = collectionView.contentOffset.x + collectionView.bounds.width / 2
        // 位移量計算
        var deltaOffset: Int!
        // 位移的比例
        var percentageDeltaOffset: CGFloat!
        switch self.scrollDirection {
        case .vertical:
            deltaOffset = Int(collectionView.contentOffset.y) % Int(collectionView.bounds.height)
            percentageDeltaOffset = CGFloat(deltaOffset) / collectionView.bounds.height
        case .horizontal:
            deltaOffset = Int(collectionView.contentOffset.x) % Int(collectionView.bounds.width)
            percentageDeltaOffset = CGFloat(deltaOffset) / collectionView.bounds.width
        }
        
        var attributes = [UICollectionViewLayoutAttributes]()
        for i in minVisibleIndex..<maxVisibleIndex {
            let attribute = computeLayoutAttributesForItem(indexPath: IndexPath(item: i, section: 0),
                                                           minVisibleIndex: minVisibleIndex,
                                                           contentCenterX: contentCenterX,
                                                           deltaOffset: CGFloat(deltaOffset),
                                                           percentageDeltaOffset: percentageDeltaOffset)
            attributes.append(attribute)
        }
        
        return attributes
    }
    
    override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    private func computeLayoutAttributesForItem(indexPath: IndexPath,
                                                minVisibleIndex: Int,
                                                contentCenterX: CGFloat,
                                                deltaOffset: CGFloat,
                                                percentageDeltaOffset: CGFloat) -> UICollectionViewLayoutAttributes {
        guard let collectionView = collectionView else { return UICollectionViewLayoutAttributes(forCellWith:indexPath)}
        
        let attributes = UICollectionViewLayoutAttributes(forCellWith:indexPath)
        let cardIndex = indexPath.row - minVisibleIndex
        attributes.size = itemSize
        attributes.center = CGPoint(x: contentCenterX + spacing * CGFloat(cardIndex),
                                    y: collectionView.bounds.midY + spacing * CGFloat(cardIndex))
        // 控制卡片的疊加順序，cardIndex越小，zIndex越大，確保顯示在最上層
        attributes.zIndex = maximumVisibleItems - cardIndex
        
        switch cardIndex {
        case 0:
            // 第一張卡片
            if self.scrollDirection == .horizontal {
                attributes.center.x -= deltaOffset
            } else {
                attributes.center.y -= deltaOffset
            }
        case 1..<maximumVisibleItems:
            // 其它可見的卡片
            attributes.center.x -= spacing * percentageDeltaOffset
            attributes.center.y -= spacing * percentageDeltaOffset
            
            // 最後一張卡片，透明度變化
            if cardIndex == maximumVisibleItems - 1 {
                attributes.alpha = percentageDeltaOffset
            }
        default:
            break
        }
        
        return attributes
    }
}
