//
//  FlatCardLayout.swift
//  Test
//
//  Created by E35 PTW on 2025/1/10.
//

import UIKit

protocol FlatCardLayoutDelegate: AnyObject {
    func flatCardScrollingType() -> LayoutModel.LayoutScrollingType
    func spacingBetweenFlatCard(in collectionView: UICollectionView) -> CGFloat
    func flatCardItemSize(in collectionView: UICollectionView) -> CGSize
}

class FlatCardLayout: UICollectionViewLayout {
    
    weak var delegate: FlatCardLayoutDelegate?
    
    // MARK: CollectionView Layout設定
    private var scrollDirection: LayoutModel.LayoutScrollingType {
        guard let delegate = delegate else { return .horizontal }
        return delegate.flatCardScrollingType()
    }
    
    private var contentSize: CGSize {
        guard let collectionView = collectionView else {
            return CGSize()
        }
        
        let itemCount = CGFloat(collectionView.numberOfItems(inSection: 0))
        switch self.scrollDirection {
        case .vertical:
            let insets = collectionView.contentInset
            let w = collectionView.bounds.width - (insets.left + insets.right)
            
            let extendHeight = (collectionView.bounds.height - itemSize.height) / 2 + 50
            let h = (itemSize.height + spacing) * itemCount + extendHeight
            return CGSize(width: w, height: h)
            
        case .horizontal:
            let extendWidth = (collectionView.bounds.width - itemSize.width) / 2 + 50
            let w = (itemSize.width + spacing) * itemCount + extendWidth
            
            let insets = collectionView.contentInset
            let h = collectionView.bounds.height - (insets.top + insets.bottom)
            return CGSize(width: w, height: h)
        }
    }
    
    private var spacing: CGFloat {
        guard let collectionView = collectionView,
              let delegate = delegate else {
            return 16
        }
        return delegate.spacingBetweenFlatCard(in: collectionView)
    }
    
    private var itemSize: CGSize {
        guard let collectionView = collectionView,
              let delegate = delegate else {
            return CGSize(width: 250, height: 400)
        }
        return delegate.flatCardItemSize(in: collectionView)
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
        return contentSize
    }
    
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView else { return nil }
        
        let totalItemsCount = collectionView.numberOfItems(inSection: 0)
        var attributes = [UICollectionViewLayoutAttributes]()
        for i in 0..<totalItemsCount {
            let attribute = computeLayoutAttributesForItem(indexPath: IndexPath(item: i, section: 0))
            attributes.append(attribute)
        }
        
        return attributes
    }
    
    override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    private func computeLayoutAttributesForItem(indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
        guard let collectionView = collectionView else { return UICollectionViewLayoutAttributes(forCellWith:indexPath)}
        
        let attributes = UICollectionViewLayoutAttributes(forCellWith:indexPath)
        let cardIndex = indexPath.row
        attributes.size = itemSize
        attributes.center = CGPoint(x: (itemSize.width + spacing) * CGFloat(cardIndex) + collectionView.bounds.width / 2,
                                    y: collectionView.bounds.midY)
        
        let contentCenterX = collectionView.contentOffset.x + collectionView.bounds.width / 2
        let scale = 1.3 - abs(attributes.center.x - contentCenterX) / (collectionView.bounds.width / 2)
        attributes.transform = CGAffineTransform(scaleX: scale, y: scale)
        
        return attributes
    }
}
